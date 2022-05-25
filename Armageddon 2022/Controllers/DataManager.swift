//
//  DataManager.swift
//  Armageddon 2022
//
//  Created by Cheremisin Andrey on 11.05.2022.
//

import RealmSwift


class DataManager {
    
    static let realm = try! Realm()
    
    var asteroids: Results<NearItems>!
    
    static func saveObject(_ object: Object) {
        try! self.realm.write{
            self.realm.add(object)
        }
    }
    
    static func obtainNearItems() -> [NearItems]{
        let model = self.realm.objects(NearItems.self)
        return Array(model)
    }
}


