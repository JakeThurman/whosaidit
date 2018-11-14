//
//  Ranking.swift
//  WhoSaidIt
//
//  Created by Benjamin Green on 11/13/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import Foundation

class Ranking: NSObject {
    static let fields = ["score", "name", "date"]
    
    @objc var score: Int
    @objc var name: String
    @objc var date: String
    
    override init() {
        score = 0
        name = ""
        date = ""
        super.init()
    }
    
    init(score: Int, name: String, date: String) {
        self.score = score
        self.name = name
        self.date = date
    }
}
