//
//  Extensions.swift
//  Armageddon 2022
//
//  Created by Cheremisin Andrey on 25.05.2022.
//

import UIKit

// MARK: Анимация кнопки
extension UIButton {
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.fromValue = 0.90
        pulse.toValue = 1
        layer.add(pulse, forKey: nil)
    }
}


// MARK: Закругление углов изображения
extension UIImageView {
    
    func roundCorners(_ corners: UIRectCorner, radius: Double) {
            let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            layer.mask = shape
    }
}
