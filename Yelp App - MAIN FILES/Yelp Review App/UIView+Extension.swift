//
//  UIView+Extension.swift
//  Yelp Review App
//
//  Created by Steve Regala on 12/4/22.
//

import UIKit

extension UIView {
    func closestVC() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let vc = responder as? UIViewController {
                return vc
            }
            responder = responder?.next
        }
        return nil
    }
}
