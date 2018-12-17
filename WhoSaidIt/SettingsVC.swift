//
//  SettingsVC.swift
//  WhoSaidIt
//
//  Created by Jake Thurman on 11/11/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import UIKit
import TwitterKit

class SettingsVC: UITableViewController, URLSessionDelegate, URLSessionDownloadDelegate {
    let repo = SettingsRepo.instance
    var selectedOption: Int = 0
    var imageMap = [String:UIImage]()
    var downloadTaskIdToMetadata = [Int:(String, Int)]()
    var urlSession: URLSession! = nil
    
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
        let api = TweetLoader()
        
        let allNames = SettingsRepo.options.enumerated().flatMap {[
            (index: $0.offset, username: $0.element.0),
            (index: $0.offset, username: $0.element.1)
        ]}
        
        for pair in allNames {
            api.getProfilePhotoURL(username: pair.username,
                onError: { err in print(err) },
                onSuccess: { urlStr in
                    self.sendRequestFor(urlStr: urlStr, rowToReload: pair.index, username: pair.username)
                })
        }
    }
    
    func sendRequestFor(urlStr: String, rowToReload: Int, username: String) {
        guard let url = URL(string: urlStr) else {
            print("Attempt to load invalid URL: \(urlStr)")
            return
        }
    
        let downloadTask = self.urlSession.downloadTask(with: url)
    
        let metadata = (username, rowToReload)
        downloadTaskIdToMetadata[downloadTask.taskIdentifier] = metadata
    }
    
    // Read in the image. It has been loaded in the background.
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let (username, rowToReload) = downloadTaskIdToMetadata[downloadTask.taskIdentifier]!
        
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
        return SettingsRepo.options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = SettingsRepo.options[indexPath.row]
        let isSelected = indexPath.row == selectedOption
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! TwitterOptionCell
        
        cell.render(isSelected: isSelected,
                    twitterOne: (option.0, imageMap[option.0]),
                    twitterTwo: (option.1, imageMap[option.1]))

        return cell
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
}
