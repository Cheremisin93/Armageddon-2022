//
//  FilterViewController.swift
//  Armageddon 2022
//
//  Created by Cheremisin Andrey on 22.04.2022.
//

import UIKit

class FilterViewController: UIViewController {
    
    var labelTextDanger = UILabel()
    var switchDanger = UISwitch()
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
        labelTextDanger = UILabel(frame: CGRect(x: 50, y: 113, width: 400, height: 50))
        labelTextDanger.text = "Показать только опасные"
        view.addSubview(labelTextDanger)
    }
    private func createSwitch() {
        switchDanger = UISwitch(frame: CGRect(x: 300, y: 124, width: 53, height: 31))
        switchDanger.addTarget(self, action: #selector(filterDanger), for: .valueChanged)
        view.addSubview(switchDanger)
    }
    @objc dynamic func filterDanger(filterTarget: UISwitch) {
        
        

        if filterTarget.isOn {
//            for item in asterVC.asteroids {
//                if item.isPotentiallyHazardousAsteroid == false {
//                    try! asterVC.realm.write({
//                        asterVC.realm.delete(item)
//                    })
//                }
//            }
            print("SwitchON")
        } else {
            print("SwitchOFF")
        }

            asterVC.tableView.reloadData()
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
