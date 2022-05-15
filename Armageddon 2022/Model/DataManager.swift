//
//  DataManager.swift
//  Armageddon 2022
//
//  Created by Cheremisin Andrey on 11.05.2022.
//

import RealmSwift

let realm = try! Realm()


class DataManager {
    
//    var asteroids: Results<NearItems>!
    
    static func saveObject(_ object: NearItems) {
        try! realm.write{
            realm.add(object)
        }
    }
    
    static func obtainAsters() -> [NearItems]{
        let model = realm.objects(NearItems.self)
        return Array(model)
    }
    
}


