//
//  UIColorExtension.swift
//  iSense
//
//  Created by Ehtisham Badar on 27/08/2022.
//

import UIKit

extension UIColor{
    
    static var appDarkRedColor: UIColor?{
        return hexStringToUIColor(hex: "#390C0C")
    }
    
    static var appYellowColor: UIColor?{
        return hexStringToUIColor(hex: "#C6AC63")
    }
    
    static var appRedColor: UIColor?{
        return hexStringToUIColor(hex: "#AA2020")
    }
    
    static var color2: UIColor?{
        return hexStringToUIColor(hex: "#c3ab68")
    }
    
    static var color1: UIColor?{
        return hexStringToUIColor(hex: "#9e8954")
    }
    
    
    static var red1: UIColor?{
        return hexStringToUIColor(hex: "#871719")
    }
    
    static var red2: UIColor?{
        return hexStringToUIColor(hex: "#591113")
    }
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
