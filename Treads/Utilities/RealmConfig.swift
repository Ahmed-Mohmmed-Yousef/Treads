//
//  RealmConfig.swift
//  Treads
//
//  Created by Ahmed on 7/28/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfig{
    static var runDataConfig: Realm.Configuration{
        let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(REALM_RUN_CONFI)
        let config = Realm.Configuration(
            fileURL: realmPath,
            schemaVersion: 0,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 0){
                    // Nothing to do
                    // Realm automaticlly detect new properties and remove properties
                }
                
        })
        return config
    }
}
