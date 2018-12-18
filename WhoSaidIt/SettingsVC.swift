//
//  SettingsVC.swift
//  WhoSaidIt
//
//  Created by Jake Thurman on 11/11/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import UIKit
import TwitterKit

class SettingsVC: UITableViewController, URLSessionDelegate {
    let repo = SettingsRepo.instance
    var selectedOption: Int = 0
    var imageMap = [String:UIImage]()
    var downloadTaskIdToMetadata = [Int:(String, Int)]()
    var urlSession: URLSession! = nil
    
    @IBAction func returnToSettings(segue: UIStoryboardSegue){
        if let sourceVC = segue.source as? CustomSettingVC  {
            let name1Maybe = sourceVC.twitterOneField.text?.replacingOccurrences(of: "@", with: "")
            let name2Maybe = sourceVC.twitterTwoField.text?.replacingOccurrences(of: "@", with: "")
            
            guard let name1 = name1Maybe else {
                return
            }
            guard let name2 = name2Maybe else {
                return
            }
            guard !name1.replacingOccurrences(of: " ", with: "").isEmpty else {
                return
            }
            guard !name2.replacingOccurrences(of: " ", with: "").isEmpty else {
                return
            }
            // Post changes to the settings repo
            repo.pushCustomTwitterPair(name1: "@" + name1, name2: "@" + name2)
            
            // Select it
            try! SettingsRepo.instance.setSettingValue(
                named: "selected_option",
                to: repo.options.count-1)
            selectedOption = repo.options.count - 1
            
            // Load profile pictures
            if imageMap[name1] == nil {
                sendImageFor(rowToReload: repo.options.count-1, username: name1.lowercased())
            }
            if imageMap[name2] == nil {
                sendImageFor(rowToReload: repo.options.count-1, username: name2.lowercased())
            }
            
            // Reload right away so we can see the updated text
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let config = URLSessionConfiguration.default
        urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)

        updateSelectedOption()
        
        loadAllImages()
        
        repo.addObserver(self, forKeyPath: "data", options: .new, context: nil)
    }

    deinit {
        repo.removeObserver(self, forKeyPath: "data")
    }
    
    func loadAllImages() {        
        let allNames = repo.options.enumerated().flatMap {[
            (index: $0.offset, username: $0.element.0.lowercased()),
            (index: $0.offset, username: $0.element.1.lowercased())
        ]}
        
        for pair in allNames {
            if imageMap[pair.username] == nil {
                sendImageFor(rowToReload: pair.index, username: pair.username)
            }
        }
    }
    
    func sendImageFor(rowToReload: Int, username: String) {
        let username = username.replacingOccurrences(of: "@", with: "")
        
        guard let url = URL(string: "https://avatars.io/twitter/\(username)/medium") else {
            print("Attempt to load invalid url for: username=\"\(username)\"")
            return
        }
        
        let downloadTask = urlSession.downloadTask(with: url) {
            (location, _request, err) in
            
            guard let location = location else {
                print(err as Any)
                return
            }
            
            do {
                let data = try Data(contentsOf: location)
                self.imageMap[username] = UIImage(data: data)
            }
            catch {
                print("Failed to load picture for \(username)")
            }
            
            OperationQueue.main.addOperation {
                self.tableView.reloadRows(at: [IndexPath(row: rowToReload, section: 0)], with: .none)
            }
        }
        
        downloadTask.resume()
    }
    
    func updateSelectedOption() {
        selectedOption = repo.selectedOptionsIndex
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        updateSelectedOption()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repo.options.count + 1
    }
    
    func maybeGetImage(user: String) -> UIImage? {
        let key = user.lowercased().replacingOccurrences(of: "@", with: "")
        return imageMap[key]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == repo.options.count {
            return tableView.dequeueReusableCell(withIdentifier: "customSettingCell", for: indexPath)
        }
        else{
            let option = repo.options[indexPath.row]
            let isSelected = indexPath.row == selectedOption
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! TwitterOptionCell
            
            cell.render(isSelected: isSelected,
                        twitterOne: (option.0, maybeGetImage(user: option.0)),
                        twitterTwo: (option.1, maybeGetImage(user: option.1)))
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tweets By:"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == repo.options.count) {
            return
        }
        
        let oldSelectedOption = selectedOption
        selectedOption = indexPath.row
        
        do {
            try SettingsRepo.instance.setSettingValue(
                named: "selected_option",
                to: indexPath.row)
        }
        catch {
            print("Twitter source change failed to save :(")
        }
        
        // Reload both rows
        tableView.reloadRows(at: [indexPath, IndexPath(row: oldSelectedOption, section: 0)], with: .none)
    }
}
