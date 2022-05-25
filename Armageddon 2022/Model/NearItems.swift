//
//  DataModel.swift.swift
//  Armageddon 2022
//
//  Created by Cheremisin Andrey on 11.05.2022.
//

import Foundation
import RealmSwift

class NearItems: Object {
    
    @Persisted var name = ""
    @Persisted var isPotentiallyHazardousAsteroid: Bool?
    @Persisted var estimatedDiameter = 0
    @Persisted var closeApproachDateFull = ""
    @Persisted var missDistance = ""
}
