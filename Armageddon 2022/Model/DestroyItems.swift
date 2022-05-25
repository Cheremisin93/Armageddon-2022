//
//  DestroyItems.swift
//  Armageddon 2022
//
//  Created by Cheremisin Andrey on 15.05.2022.
//

import RealmSwift

class DestroyItems: Object {
    
    @Persisted var name = ""
    @Persisted var isPotentiallyHazardousAsteroid: Bool?
    
    
}
