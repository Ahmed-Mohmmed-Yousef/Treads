//
//  Run.swift
//  Treads
//
//  Created by Ahmed on 7/27/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import Foundation
import RealmSwift

class Run: Object{
    @objc dynamic public private(set) var id = ""
    @objc dynamic public private(set) var date = NSDate()
    @objc dynamic public private(set) var pace = 0
    @objc dynamic public private(set) var distance = 0.0
    @objc dynamic public private(set) var duration = 0
    dynamic public private(set) var locations = List<Location>()
    
    
    override class func primaryKey() -> String{
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["pace","date","duration"]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int, locations: List<Location>){
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.date = NSDate()
        self.pace = pace
        self.distance = distance
        self.duration = duration
        self.locations = locations
    }
    
    static func addRunToRealm(pace: Int, distance: Double, duration: Int, locations: List<Location>){
        let run = Run(pace: pace, distance: distance, duration: duration, locations: locations)
        REALM_QUEUE.async {
            do{
                let realm = try Realm(configuration: RealmConfig.runDataConfig)
                try realm.write {
                    realm.add(run)
                    try realm.commitWrite()
                }
            } catch{
                debugPrint("Error adding run to realm")
            }
        }
    }
    
    enum RealmError: Error {
        case cantRead
    }
    static func getAllRuns() -> Results<Run>? {
        do{
            let realm = try Realm(configuration: RealmConfig.runDataConfig)
            var runs =  realm.objects(Run.self)
            runs = runs.sorted(byKeyPath: "date", ascending: false)
            return runs
            
        } catch {
            return nil
        }
    }
}
