//
//  FeedViewController.swift
//  Armageddon 2022
//
//  Created by Cheremisin Andrey on 19.04.2022.
//

import UIKit

class AsteroidViewController: UIViewController {
    
    var result: Objects?
    var tableView = UITableView()
    let identifier = "cell"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        parseJSON()
        createTableView()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "SF Symbol"), style: .plain, target: self, action: #selector(filterObject))
        
    }
    
    @objc dynamic func filterObject() {
        let filterView = FilterViewController()
        self.navigationController?.pushViewController(filterView, animated: true)
    }
    
    private func parseJSON() {
        let url = "https://api.nasa.gov/neo/rest/v1/feed?start_date=2022-04-08&end_date=2022-04-15&api_key=w6JgeuisSazG6hoclBnbZyfmC82QeEXwQIVXLQdw"
        guard let url = URL(string: url) else { return }
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let data = data else { return }
            do  {
                self.result = try JSONDecoder().decode(Objects.self, from: data)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
    
    private func dateForm(date: String) -> String {
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd"
        let oldDate = olDateFormatter.date(from: date)
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = "d MMMM yyyy"
        convertDateFormatter.locale = Locale(identifier: "ru_RU")
        
        return convertDateFormatter.string(from: oldDate!)
    }
    
}
extension AsteroidViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let result = result {
            return result.nearEarthObjects.values.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let array = (self.result?.nearEarthObjects.keys)!.sorted()
        return dateForm(date: array[section])
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let array = (self.result?.nearEarthObjects.keys)!.sorted()
        let model = result?.nearEarthObjects[array[indexPath.section]]![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TVCell
        
        cell.nameLabel.text = model?.name
        let diametr = model?.estimatedDiameter.meters.estimatedDiameterMax
        cell.diameter.text = String(format: "%.0f", diametr!) + " метров"
        
        if let date = model?.closeApproachData.first?.closeApproachDateFull {
            cell.approachDateLabel.text = dateForm(date: date)
        } else {
            cell.approachDateLabel.text = "0"
        }
        let distance = Double((model?.closeApproachData.first?.missDistance.kilometers)!)!
        cell.distanceLabel.text = String(format: "%.0f", distance) + " км"
        
        if (model?.isPotentiallyHazardousAsteroid)! {
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
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 308
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return result?.nearEarthObjects.keys.count ?? 0
    }
    
    
    
}
