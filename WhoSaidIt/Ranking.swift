//
//  Ranking.swift
//  WhoSaidIt
//
//  Created by Benjamin Green on 11/13/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import Foundation

class Ranking: NSObject {
    static let fields = ["localRank", "score", "name", "date"]
    
    @objc var localRank: Int
    @objc var score: Int
    @objc var name: String
    @objc var date: String

    override init() {
        localRank = 0
        score = 0
        name = ""
        date = Date().description
        super.init()
    }
    
    init(localRank: Int, score: Int, name: String, date: String) {
        self.localRank = localRank
        self.score = score
        self.name = name
        self.date = date
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "score": score,
            "localRank": localRank,
            "date": date
        ]
    }
}
