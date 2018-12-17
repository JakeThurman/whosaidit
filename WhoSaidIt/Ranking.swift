//
//  Ranking.swift
//  WhoSaidIt
//
//  Created by Benjamin Green on 11/13/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import Foundation

class Ranking: NSObject {
    static let fields = ["localRank", "score", "name", "date", "twitterPair"]
    
    @objc var localRank: Int
    @objc var score: Int
    @objc var name: String
    @objc var date: String
    @objc var twitterPair: Int

    override init() {
        localRank = 0
        score = 0
        name = ""
        date = Date().description
        twitterPair = 0
        super.init()
    }
    
    init(localRank: Int, score: Int, name: String, date: String, twitterPair: Int) {
        self.localRank = localRank
        self.score = score
        self.name = name
        self.date = date
        self.twitterPair = twitterPair
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "score": score,
            "localRank": localRank,
            "date": date,
            "twitterPair": twitterPair
        ]
    }
}
