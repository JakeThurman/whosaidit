//
//  Setting.swift
//  WhoSaidIt
//
//  Created by Benjamin Green on 11/14/18.
//  Copyright © 2018 TGS. All rights reserved.
//

import Foundation

class Setting: NSObject {
    static let fields = ["name", "value", "order"]
    
    @objc var name: String
    @objc var value: Any
    @objc var order: Int
    
    override init() {
        name = ""
        value = ""
        order = 0
        super.init()
    }
    
    init(name: String, value: Any, order: Int) {
        self.name = name
        self.value = value
        self.order = 0
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "value": value,
            "order": order
        ]
    }
}
