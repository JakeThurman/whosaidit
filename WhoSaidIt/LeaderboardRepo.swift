//
//  LeaderboardRepo.swift
//  WhoSaidIt
//
//  Created by Benjamin Green on 11/13/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import Foundation

class LeaderboardRepo: NSObject {
    static let instance = LeaderboardRepo()
    
    let fileUrl: URL
    @objc dynamic var data: [Ranking]
    
    // Load rankings in from file, if it exists
    private override init() {
        data = [Ranking]()
        
        // Save file url
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        fileUrl = URL(fileURLWithPath: path).appendingPathComponent("leaderboard.json")

        super.init()
        
        addObserver(self, forKeyPath: "data", options: .new, context: nil)
        
        // Check if file exists
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: fileUrl.path) {
            do {
                // Grab JSON contents
                let contents = try Data(contentsOf: fileUrl)
                let rankArray = try JSONSerialization.jsonObject(with: contents, options: .mutableContainers) as! [[String: AnyObject]]
                
                // Append each ranking to the array
                for rank in rankArray {
                    let ranking = Ranking()
                    
                    for (key, value) in rank {
                        if Ranking.fields.contains(key) {
                            ranking.setValue(value, forKey: key)
                        }
                    }
                    
                    data.append(ranking)
                }
                                
                // Sort so highest score is first and ties go to the earlier date
                data.sort {
                    return $0.score > $1.score || ($0.score == $1.score && $0.date < $1.date)
                }
            } catch {
                print("Failed to read file")
            }
        }
        else {
            print("File does not exist")
        }
    }
    
    // Write JSON to file when rankings change
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        do {
            let contents = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            try contents.write(to: fileUrl)
        } catch {
            print("Failed to write")
        }
    }
    
    // Remove self as observer when closing
    deinit {
        removeObserver(self, forKeyPath: "data")
    }
}
