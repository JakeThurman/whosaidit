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
    var selectedOption: Int = 0
    var imageMap = [String:UIImage]()
    
    @IBAction func unwindSaveSettings(segue: UIStoryboardSegue){
        // We don't have many rows, just reload them
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSelectedOption()
        
        repo.addObserver(self, forKeyPath: "data", options: .new, context: nil)
    }

    deinit {
        repo.removeObserver(self, forKeyPath: "data")
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
