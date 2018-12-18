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
    @objc dynamic var data = [Int:[Ranking]]()
    
    // Load rankings in from file, if it exists
    private override init() {
        // Initialize the data object
        for i in 0...SettingsRepo.instance.options.count {
            data[i] = []
        }
        
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
                    
                    data[ranking.twitterPair]?.append(ranking)
                }
                                
                // Sort so highest score is first and ties go to the earlier date
                for var set in data.values {
                    set.sort {
                        return $0.score > $1.score || ($0.score == $1.score && $0.date < $1.date)
                    }
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
        // Create array of dictionaries from the array of rankings so it can be written as JSON
        var jsonData = [[String: Any]]()
        
        let data = self.data.values.flatMap { $0 }
        for ranking in data {
            jsonData.append(ranking.toDictionary())
        }
        
        do {
            let contents = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
            try contents.write(to: fileUrl)
        } catch {
            print("Failed to write")
        }
    }
    
    func addRanking(ranking: Ranking){
        if ranking.localRank <= 10, var arr = data[ranking.twitterPair] {
            arr.insert(ranking, at: ranking.localRank - 1 )
            if arr.count > 10 {
                arr.removeLast(arr.count - 10)
            }
            data[ranking.twitterPair] = arr
        }
        else {
            data[ranking.twitterPair] = [ranking]
        }
    }
    
    // Remove self as observer when closing
    deinit {
        removeObserver(self, forKeyPath: "data")
    }
}
