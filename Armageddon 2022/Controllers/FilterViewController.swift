//
//  FilterViewController.swift
//  Armageddon 2022
//
//  Created by Cheremisin Andrey on 22.04.2022.
//

import UIKit

class FilterViewController: UIViewController {
    
    var filterCompletionHandler: ((Bool) -> ())?
    let labelTextDanger = UILabel()
    let switchDanger = UISwitch()
    var backView: UIView?
    let label = UILabel()
    
    let asterVC = AsteroidViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createView()
        createlabel()
        createSwitch()
    }
    
    private func createView() {
        backView = UIView(frame: CGRect(x: 20, y: 110, width: view.frame.width - 40, height: 60))
        backView!.backgroundColor = .opaqueSeparator
        backView?.alpha = 0.3
        backView!.layer.cornerRadius = 15
        view.addSubview(backView!)
    }
    private func createlabel() {
        labelTextDanger.frame = CGRect(x: 50, y: 113, width: 400, height: 50)
        labelTextDanger.text = "Показать только опасные"
        view.addSubview(labelTextDanger)
    }
    private func createSwitch() {
        switchDanger.frame = CGRect(x: 300, y: 124, width: 0, height: 0)
        switchDanger.addTarget(self, action: #selector(filterDanger), for: .valueChanged)
        view.addSubview(switchDanger)
    }
    @objc func filterDanger(filterTarget: UISwitch) {
        
        if filterTarget.isOn {
            filterCompletionHandler? (true)   // не работает!!!
            print("SwitchON")
            asterVC.tableView.reloadData()
            navigationController?.popViewController(animated: true)
        } else {
            filterCompletionHandler?(false)
            print("SwitchOFF")
            asterVC.tableView.reloadData()
        }
    }
}
