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
            
            let name1 = sourceVC.twitterOneField.text ?? "???"
            let name2 = sourceVC.twitterTwoField.text ?? "???"
            
            // Post changes to the settings repo
            repo.changeCustomTwitters(name1: name1, name2: name2)

            // Load profile pictures
            if imageMap[name1] == nil {
                sendImageFor(rowToReload: SettingsRepo.options.count, username: name1.lowercased())
            }
            if imageMap[name2] == nil {
                sendImageFor(rowToReload: SettingsRepo.options.count, username: name2.lowercased())
            }
            
            // Reload right away so we can see the updated text
            tableView.reloadRows(at: [IndexPath(row: SettingsRepo.options.count, section: 0)], with: .automatic)
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
        let allNames = SettingsRepo.options.enumerated().flatMap {[
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
        return SettingsRepo.options.count + 1
    }
    
    func maybeGetImage(user: String) -> UIImage? {
        let key = user.lowercased().replacingOccurrences(of: "@", with: "")
        print(key, imageMap)
        return imageMap[key]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == SettingsRepo.options.count {
            let option = repo.customTwitters
            let isSelected = indexPath.row == selectedOption
            let cell = tableView.dequeueReusableCell(withIdentifier: "customSettingCell", for: indexPath) as! TwitterOptionCell
            
            cell.render(isSelected: isSelected, isCustom: true,
                        twitterOne: (option[0], maybeGetImage(user: option[0])),
                        twitterTwo: (option[1], maybeGetImage(user: option[1])))
            return cell
        }
        else{
            let option = SettingsRepo.options[indexPath.row]
            let isSelected = indexPath.row == selectedOption
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! TwitterOptionCell
            
            cell.render(isSelected: isSelected, isCustom: false,
                        twitterOne: (option.0, maybeGetImage(user: option.0)),
                        twitterTwo: (option.1, maybeGetImage(user: option.1)))
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tweets By:"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let child = segue.destination as! CustomSettingVC
        
        var name1 = repo.customTwitters[0]
        var name2 = repo.customTwitters[1]
        
        //Wipe out defaults
        if name1 == "@???"{
            name1 = "@"
        }
        if name2 == "@???"{
            name2 = "@"
        }
        
        //Drop the @ symbol
        child.twitterOne = String(name1.dropFirst())
        child.twitterTwo = String(name2.dropFirst())
    }
}
