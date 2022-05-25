//
//  ProfileViewController.swift
//  Armageddon 2022
//
//  Created by Cheremisin Andrey on 19.04.2022.
//

import UIKit
import RealmSwift
import AVKit
import AVFoundation
import SwiftUI

class DestructionViewController: UIViewController {
    
    private lazy var isEmptyLabel = UILabel()
    
    var arrayOfDestroy: Results<DestroyItems>!
    
    let realm = try! Realm()
    
    
    var tableView = UITableView()
    let playerVC = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = .white
        view.backgroundColor = .white
        arrayOfDestroy = realm.objects(DestroyItems.self)
        createTableView()
        setupButton()
        createlabel()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        arrayOfDestroy = realm.objects(DestroyItems.self)
        if arrayOfDestroy.isEmpty {
            isEmptyLabel.alpha = 1
        } else {
            isEmptyLabel.alpha = 0
        }
        
        if arrayOfDestroy.count != 0 {
            tabBarController?.viewControllers![1].tabBarItem.badgeValue = String(arrayOfDestroy.count)
        } else {
            tabBarController?.viewControllers![1].tabBarItem.badgeValue = nil
        }
        tableView.reloadData()
    }
    
    private func createTableView() {
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellDestr")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
    }
    private func createlabel() {
        isEmptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))
        isEmptyLabel.text = "Здесь появиться список на уничтожение астероидов"
        isEmptyLabel.textAlignment = .center
        isEmptyLabel.textColor = .lightGray
        isEmptyLabel.numberOfLines = 0
        
        isEmptyLabel.translatesAutoresizingMaskIntoConstraints = true
        isEmptyLabel.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        isEmptyLabel.autoresizingMask = [UIView.AutoresizingMask.flexibleLeftMargin, UIView.AutoresizingMask.flexibleRightMargin, UIView.AutoresizingMask.flexibleTopMargin, UIView.AutoresizingMask.flexibleBottomMargin]
        view.addSubview(isEmptyLabel)
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
        if arrayOfDestroy.count != 0 {
            let alert = UIAlertController(title: "Вы уверены, что хотите уничтожить эти объекты?", message: "Нажмите Отмена, если вы хотите отменить выбранное действие", preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "Да, черт побери!", style: .default) { [unowned self] _ in
                let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Untitled", ofType: "mov")!))
                playerVC.player = player
                playerVC.player?.volume = 4
                playerVC.player?.play()
                present(playerVC, animated: true)
                NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerVC.player?.currentItem)
                
                try! realm.write {
                    realm.delete(arrayOfDestroy)
                }
                self.tableView.reloadData()
            }
            let actionCancel = UIAlertAction(title: "Отмена", style: .cancel)
            alert.addAction(actionOK)
            alert.addAction(actionCancel)
            
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Сначала добавьте объекты", message: "", preferredStyle: .alert)
            let actionCancel = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(actionCancel)
            
            present(alert, animated: true)
        }
    }
    @objc func playerDidFinishPlaying() {
        self.playerVC.dismiss(animated: true)
    }
    func addArrayObject(nearAster: NearItems) {
        
        let destroyItem = DestroyItems()
        destroyItem.name = nearAster.name
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "В очереди на разрушение \(arrayOfDestroy.count) объектов"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let array = arrayOfDestroy else { return 0}
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDestr", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        if arrayOfDestroy[indexPath.row].isPotentiallyHazardousAsteroid! {
            content.image = UIImage(named: "Destr_big")
            content.secondaryText = "Опасен"
            content.secondaryTextProperties.color = .red
        } else {
            content.image = UIImage(named: "Destr_small")
            content.secondaryText = "Не опасен"
            content.secondaryTextProperties.color = UIColor(#colorLiteral(red: 0.09864069106, green: 0.5854756773, blue: 0.1694956172, alpha: 1))
        }
        
        content.text = arrayOfDestroy![indexPath.row].name
        content.textProperties.font.withSize(18)
        content.imageProperties.tintColor = .lightGray
        content.imageProperties.cornerRadius = 10
        cell.contentConfiguration = content
        
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write{
                realm.delete(arrayOfDestroy[indexPath.row])
            }
            tableView.deselectRow(at: indexPath, animated: true)
            tableView.reloadData()
            tabBarController?.viewControllers![1].tabBarItem.badgeValue = String(arrayOfDestroy.count)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
