//
//  UIView+Extension.swift
//  Pods-TVMoviesLib_Example
//
//  Created by Phincon on 13/06/22.
//

import Foundation
import UIKit

public extension UIView {
    func fromNib<T: UIView>(nibName: String, isInherited: Bool = false) -> T? {
        let bundle = Bundle(for: type(of: self))
        guard let contentView =  bundle.loadNibNamed(nibName,
                                                     owner: self,
                                                     options: nil)?.first as? T else {
                                                        return nil
        }
        contentView.backgroundColor = .clear
        if isInherited {
            self.insertSubview(contentView, at: 0)
        } else {
            self.addSubview(contentView)
        }
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.fixConstraintsInView(self)
        return contentView
    }

    func fixConstraintsInView(_ container: UIView!) {
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }

    func roundCorners(corners: UIRectCorner,
                      radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
//        self.clipsToBounds = true
    }
    
    func roundCornersWithBounds(corners: UIRectCorner,
                                radius: CGFloat, bounds: CGRect) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        self.clipsToBounds = true
    }

    func anchor(top: NSLayoutYAxisAnchor?,
                leading: NSLayoutXAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                trailing: NSLayoutXAxisAnchor?,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) {

        self.translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }

        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }

        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }

        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }

        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func applyGradientView(colours: [UIColor], isHorizontal: Bool = false) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        if isHorizontal {
            gradient.startPoint = CGPoint(x: 0.0, y: 1)
            gradient.endPoint = CGPoint(x: 1.0, y: 1)
        }
        gradient.locations = [0.0, 1.0]
        gradient.name = "gradient"
        for sublayer in layer.sublayers ?? [] where sublayer.name == "gradient" {
            sublayer.removeFromSuperlayer()
        }
        self.layer.insertSublayer(gradient, at: 0)
    }
}

public extension UIView {
    private static let kLayerNameGradientBorder = "GradientBorderLayer"
    
    func gradientBorder(width: CGFloat,
                        colors: [UIColor],
                        startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
                        endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0),
                        andRoundCornersWithRadius cornerRadius: CGFloat = 0) {
        
        let existingBorder = gradientBorderLayer()
        let border = existingBorder ?? CAGradientLayer()
        border.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y,
                              width: bounds.size.width + width, height: bounds.size.height + width)
        border.colors = colors.map { return $0.cgColor }
        border.startPoint = startPoint
        border.endPoint = endPoint
        
        let mask = CAShapeLayer()
        let maskRect = CGRect(x: bounds.origin.x + width/2, y: bounds.origin.y + width/2,
                              width: bounds.size.width - width, height: bounds.size.height - width)
        mask.path = UIBezierPath(roundedRect: maskRect, cornerRadius: cornerRadius).cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = width
        
        border.mask = mask
        
        let exists = (existingBorder != nil)
        if !exists {
            layer.addSublayer(border)
        }
    }
    
    private func gradientBorderLayer() -> CAGradientLayer? {
        let borderLayers = layer.sublayers?.filter { return $0.name == UIView.kLayerNameGradientBorder }
        if borderLayers?.count ?? 0 > 1 { fatalError() }
        return borderLayers?.first as? CAGradientLayer
    }
}

public extension CGPoint {
    enum CoordinateSide {
        case topLeft, top, topRight, right, bottomRight, bottom, bottomLeft, left
    }
    
    static func unitCoordinate(_ side: CoordinateSide) -> CGPoint {
        switch side {
        case .topLeft:      return CGPoint(x: 0.0, y: 0.0)
        case .top:          return CGPoint(x: 0.5, y: 0.0)
        case .topRight:     return CGPoint(x: 1.0, y: 0.0)
        case .right:        return CGPoint(x: 0.0, y: 0.5)
        case .bottomRight:  return CGPoint(x: 1.0, y: 1.0)
        case .bottom:       return CGPoint(x: 0.5, y: 1.0)
        case .bottomLeft:   return CGPoint(x: 0.0, y: 1.0)
        case .left:         return CGPoint(x: 1.0, y: 0.5)
        }
    }
}
