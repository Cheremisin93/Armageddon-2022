//
//  FeedViewController.swift
//  Armageddon 2022
//
//  Created by Cheremisin Andrey on 19.04.2022.
//

import UIKit
import RealmSwift

class AsteroidViewController: UIViewController {
    
    let realm = try! Realm()
    
    
    var tag = 0
    var switchDanger = false
    
    var asteroids: Results<NearItems>!
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
            var dateComponent = DateComponents()
            dateComponent.day = 7
            let currentDate = Date()
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
            let olDateFormatter = DateFormatter()
            olDateFormatter.dateFormat = "yyyy-MM-dd"
            let oldDate = olDateFormatter.string(from: futureDate!)
            return oldDate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTableView()
        createNavigationMenu()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        asteroids = realm.objects(NearItems.self)
        
        if asteroids.count == 0 {
            addActivityIndicator()
            parseJSON()
            tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //MARK: Сохранение в БД
    
    func saveData(aster: NearEarthObject) {
        
        let nearObject = NearItems()
        nearObject.name = aster.name
        nearObject.isPotentiallyHazardousAsteroid = aster.isPotentiallyHazardousAsteroid
        nearObject.closeApproachDateFull = aster.closeApproachData.first!.closeApproachDateFull
        nearObject.missDistance = aster.closeApproachData.first!.missDistance.kilometers
        
        let max = aster.estimatedDiameter.meters.estimatedDiameterMax
        let min = aster.estimatedDiameter.meters.estimatedDiameterMin
        let estimatedDiameter = (min + max)/2
        nearObject.estimatedDiameter = Int(estimatedDiameter)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            try! self.realm.write{
                self.realm.add(nearObject)
            }
        }
    }
    
    //MARK: Получание данных
    
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
                DispatchQueue.main.async { [unowned self] in
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
                
            } catch {
                print(error)
            }
        }.resume()
        
    }
    
    //MARK: Интерфейс
    
    private func createNavigationMenu() {
        let menu = UIMenu(title: "", children: [
            UIAction(title: "Фильтр", image: UIImage(named: "filter"), handler: { [unowned self] _ in self.filterObject() }),
            UIAction(title: "Обновить таблицу", image: UIImage(named: "reload"), handler: { [unowned self] _ in self.updateTableView() })
        ])
        let saveButton = UIBarButtonItem(image: UIImage(named: "SF Symbol"), menu: menu)
        navigationItem.rightBarButtonItem = saveButton
    }
    
    // Фильтр
    @objc func filterObject() {
        let filterView = FilterViewController()
        navigationController?.pushViewController(filterView, animated: true)
        
    }
    //Обновление
    @objc func updateTableView() {
        
        try! self.realm.write { [unowned self]  in
            self.realm.delete(asteroids)
            tableView.reloadData()
        }
        addActivityIndicator()
        parseJSON()
    }
    
    private func addActivityIndicator() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
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
    func dateForm(date: String) -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd"
        let oldDate = olDateFormatter.date(from: date)
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "d MMMM yyyy"
        convertDateFormatter.locale = Locale(identifier: "ru_RU")
        
        return convertDateFormatter.string(from: oldDate!)
    }
    
}

extension AsteroidViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asteroids.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TVCell
        
        let asteroid = asteroids[indexPath.row]
        cell.nameLabel.text = asteroid.name
        cell.diameter.text =  "\(asteroid.estimatedDiameter) метров"
        
        
        let date = dateForm(date: asteroid.closeApproachDateFull)
        cell.approachDateLabel.text = "\(date)"
        
        
        let doubleDistance = Double(asteroid.missDistance)
        let kilometers = String(format: "%.0f", doubleDistance!)
        let separatated = separatedNumber(Int(kilometers)!)
        cell.distanceLabel.text = "\(separatated) км"
        
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
        
        cell.completionHandler  = { [unowned self] index in
            return self.asteroids[index]
        }
        
        cell.deleteHandler = {
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
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
    
    func separatedNumber(_ number: Any) -> String {
        guard let itIsANumber = number as? NSNumber else { return "Not a number" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = ","
        return formatter.string(from: itIsANumber)!
    }
}

