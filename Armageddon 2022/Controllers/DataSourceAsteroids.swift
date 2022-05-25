//
//  DataSourceAsteroids.swift
//  Armageddon 2022
//
//  Created by Cheremisin Andrey on 15.05.2022.
//

import UIKit
import RealmSwift

final class DataSourceAsteroids: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var tag = 0
    let identifier = "cell"
    var switchDanger = false
    
    private var filteredInems: [NearItems] {
        asteroids.filter { $0.isPotentiallyHazardousAsteroid == true }
        
    }
//    var asteroids = DataManager.obtainNearItems()
    var asteroids: Results<NearItems>!
    
    private lazy var dataItems = asteroids
    
    func toggle() {
//        let filteredArray = FilterViewController()
////        switchDanger.toggle()
//        filteredArray.filterCompletionHandler = { [unowned self] bolean in
//            self.dataItems = self.switchDanger ? self.filteredInems : asteroids
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asteroids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TVCell
        
        let asteroid = asteroids[indexPath.row]
        cell.nameLabel.text = asteroid.name
        cell.diameter.text =  "\(asteroid.estimatedDiameter) метров"
        
        cell.approachDateLabel.text = "\(asteroid.closeApproachDateFull) дата"
        cell.distanceLabel.text = "\(asteroid.missDistance) км"
        
        if asteroids[indexPath.row].isPotentiallyHazardousAsteroid! {
            cell.isHazardousLabel.text = "Опасен"
            cell.isHazardousLabel.textColor = .red
            cell.imageAsteroid.image = UIImage(named: "big")
            cell.asteroidImage.image = UIImage(named: "bigA")
        } else {
            cell.isHazardousLabel.text = "Не опасен"
            cell.isHazardousLabel.textColor = .black
            cell.imageAsteroid.image = UIImage(named: "small")
            cell.asteroidImage.image = UIImage(named: "smallA")
        }
        cell.indexPath = indexPath.row
        tag = indexPath.row
        
        cell.completionHandler  = { index in
            
            return self.asteroids[index]
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 308
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if asteroids.count == 0 {
            return "Идет загрузка..."
        }
        return "Найдено \(asteroids.count) астероидов"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
