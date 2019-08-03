//
//  Locatin.swift
//  Treads
//
//  Created by Ahmed on 7/28/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    @objc dynamic public private(set) var latitude = 0.0
    @objc dynamic public private(set) var logitude = 0.0
    
    convenience init(latitude: Double, logitude: Double) {
        self.init()
        self.latitude = latitude
        self.logitude = logitude
    }
}
