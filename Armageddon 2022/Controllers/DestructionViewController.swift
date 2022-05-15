//
//  ProfileViewController.swift
//  Armageddon 2022
//
//  Created by Cheremisin Andrey on 19.04.2022.
//

import UIKit
import RealmSwift

class DestructionViewController: UIViewController {
    
    var arrayOfDestroy: Results<DestroyItems>!
    let realm = try! Realm()
    
    var tableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.backgroundColor = .white
        createTableView()
        setupButton()
        
        arrayOfDestroy = realm.objects(DestroyItems.self)
        
    }
    
    private func createTableView() {
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellDestr")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
    }
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15
        button.setTitle("Заказать бригаду им. Брюса Уиллиса", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setupButton() {
        self.view.addSubview(self.button)
        self.button.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
        self.button.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        self.button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    @objc private func buttonAction() {
        button.pulsate()
    }

    func addArrayObject(nearAster: NearItems) {

        let destroyItem = DestroyItems()
        destroyItem.name = nearAster.name
        destroyItem.id = Int(nearAster.id ?? 0)
        destroyItem.isPotentiallyHazardousAsteroid = nearAster.isPotentiallyHazardousAsteroid
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            try! self.realm.write{
                self.realm.add(destroyItem)
            }
        }
        
        
    }
}

extension DestructionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let array = arrayOfDestroy else { return 0}
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDestr", for: indexPath)
        
        cell.textLabel?.text = arrayOfDestroy![indexPath.row].name
    
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                realm.delete(arrayOfDestroy[indexPath.row])
                tableView.deselectRow(at: indexPath, animated: true)
                tableView.reloadData()
            }
        }
    }
}
