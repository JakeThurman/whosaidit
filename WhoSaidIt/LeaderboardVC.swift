//
//  LeaderboardVC.swift
//  WhoSaidIt
//
//  Created by Jake Thurman on 11/11/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import UIKit

class LeaderboardVC: UITableViewController {
    let repo = LeaderboardRepo.instance

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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath)

        cell.textLabel?.text = "\(indexPath.row + 1). \(repo.data[indexPath.row].name)"
        cell.detailTextLabel?.text = String(repo.data[indexPath.row].score)

        return cell
    }
}
