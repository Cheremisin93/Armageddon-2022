//
//  FeedViewController.swift
//  Armageddon 2022
//
//  Created by Cheremisin Andrey on 19.04.2022.
//

import UIKit
import RealmSwift

class AsteroidViewController: UIViewController {
    
//    var asteroids: Results<NearItems>!
    let realm = try! Realm()
    
    var result: Objects?
    
    var tableView = UITableView()
    let identifier = "cell"
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var dateStart: String {
        get {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd"
            let formatteddate = formatter.string(from: date as Date)
            return formatteddate
        }
    }
    var dateEnd: String {
        get {
            
            return "2022-05-21"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTableView()
        createNavigationMenu()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        var asteroids = realm.objects(DataManager.obtainAsters().self)
        
//        if asteroids.count == 0 {
//            parseJSON()
//            addActivityIndicator()
//        }
        
    }
    
    
    private func createNavigationMenu() {
        let menu = UIMenu(title: "", children: [
            UIAction(title: "Фильтр", image: UIImage(named: "filter"), handler: { [unowned self] _ in self.filterObject() }),
            UIAction(title: "Обновить таблицу", image: UIImage(named: "reload"), handler: { [unowned self] _ in self.updateTableView() }),
            UIAction(title: "Установить дату", image: UIImage(named: "weekly"), handler: { [unowned self] _ in self.changeDate() })
        ])
        let saveButton = UIBarButtonItem(image: UIImage(named: "SF Symbol"), menu: menu)
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func changeDate() {
        let alert = UIAlertController(title: "Введите дату", message: "Измените дату", preferredStyle: .alert)
        
        alert.addTextField()
        
        let actionOK = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            // date
            self.tableView.reloadData()
        }
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addAction(actionOK)
        alert.addAction(actionCancel)
        
        present(alert, animated: true)
    }
    
    
    @objc func filterObject() {
        let filterView = FilterViewController()
        navigationController?.pushViewController(filterView, animated: true)
        
//        if filterView.switchDanger.isOn {
//            
//            for item in asteroids {
//                if item.isPotentiallyHazardousAsteroid == false {
//                    
//                    try! self.realm.write({
//                        self.realm.delete(item)
//                    })
//                }
//            }
//            print("SwitchOFF")
//        } else {
//            print("SwitchOFF")
//        }
//        tableView.reloadData()
    }
    
    @objc func updateTableView() {
        
        try! realm.write {
            realm.delete(DataManager.obtainAsters())
        }
        addActivityIndicator()
        parseJSON()
        tableView.reloadData()
    }
    
    private func addActivityIndicator() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    //MARK: Сохранение в БД
//
    func saveData(aster: NearEarthObject) {
        
        let nearObject = NearItems()
        nearObject.name = aster.name
        nearObject.id = Int(aster.id) ?? 0
        nearObject.isPotentiallyHazardousAsteroid = aster.isPotentiallyHazardousAsteroid
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            try! self.realm.write{
                self.realm.add(nearObject)
            }
        }
    }
    
    private func parseJSON() {
        
        let url = "https://api.nasa.gov/neo/rest/v1/feed?start_date=\(dateStart)&end_date=\(dateEnd)&api_key=w6JgeuisSazG6hoclBnbZyfmC82QeEXwQIVXLQdw"
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { [unowned self] data, _ , error  in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else { return }
            do  {
                self.result = try JSONDecoder().decode(Objects.self, from: data)
                
                if let arrayAllObject = result?.nearEarthObjects.values.flatMap({ $0 }) {
                
                    for asteroid in arrayAllObject {
                        saveData(aster: asteroid)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
                
            } catch {
                print(error)
            }
        }.resume()
        
    }
    private func createTableView() {
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UINib(nibName: "TVCell", bundle: nil), forCellReuseIdentifier: identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
}

extension AsteroidViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return asteroids.count
        return DataManager.obtainAsters().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TVCell
        
        cell.nameLabel.text = DataManager.obtainAsters()[indexPath.row].name
        cell.diameter.text =  "0 метров"
        cell.approachDateLabel.text = "0 дата"
        cell.distanceLabel.text = "0 км"
        
        if DataManager.obtainAsters()[indexPath.row].isPotentiallyHazardousAsteroid! {
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
        
        cell.completionHandler  = { index in
            
            return DataManager.obtainAsters()[index]
            
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
        if DataManager.obtainAsters().count == 0 {
            return "Идет загрузка..."
        }
        return "Найдено \(DataManager.obtainAsters().count) астероидов"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
extension UIButton {
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.fromValue = 0.90
        pulse.toValue = 1
        layer.add(pulse, forKey: nil)
    }
}

