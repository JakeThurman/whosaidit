//
//  SettingsVC.swift
//  WhoSaidIt
//
//  Created by Jake Thurman on 11/11/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import UIKit

class SettingsVC: UITableViewController {
    let repo = SettingsRepo.instance
    
    var row = 0
    
    @IBAction func unwindSaveSettings(segue: UIStoryboardSegue){
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        repo.addObserver(self, forKeyPath: "data", options: .new, context: nil)
    }

    deinit {
        repo.removeObserver(self, forKeyPath: "data")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repo.data.count
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        row = indexPath.row
        return indexPath
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)

        cell.textLabel?.text = "\(repo.data[indexPath.row].name)"
        cell.detailTextLabel?.text = "\(repo.data[indexPath.row].value)"

        return cell
    }

    /*
    // MARK: - Navigation
     */
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let child = segue.destination as? ChangeSettingVC{
            child.settingName = repo.data[row].name
            child.settingValue = repo.data[row].value
        }
    }
}
