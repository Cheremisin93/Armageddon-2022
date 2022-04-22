//
//  TVCell.swift
//  Armageddon 2022
//
//  Created by Cheremisin Andrey on 21.04.2022.
//


import UIKit

class TVCell: UITableViewCell {
    
    @IBOutlet weak var backgroundCell: UIView!
    @IBOutlet weak var imageAsteroid: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var diameter: UILabel!
    @IBOutlet weak var approachDateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var isHazardousLabel: UILabel!
    @IBOutlet weak var destroyButton: UIButton!
    @IBOutlet weak var asteroidImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDesign()
    }
    
    private func setupDesign() {

        backgroundCell.layer.cornerRadius = 25
        backgroundCell.layer.shadowColor = UIColor.black.cgColor
        backgroundCell.layer.shadowOffset = CGSize(width: 0, height: 3)
        backgroundCell.layer.shadowOpacity = 0.3
        destroyButton.setTitle("Уничтожить", for: .normal)
        destroyButton.layer.cornerRadius = 12
        asteroidImage.contentMode = .topLeft
        imageAsteroid.roundCorners([.topRight, .topLeft], radius: 25)
        
    }
    @IBAction func destroyButtonTapped(_ sender: UIButton) {
        
    }
    
    
}
extension UIImageView {
    func roundCorners(_ corners: UIRectCorner, radius: Double) {
            let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            layer.mask = shape
        }
}
