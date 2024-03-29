//
//  UIColorExtension.swift
//  iSense
//
//  Created by Abdullah Javed on 27/08/2022.
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
    
    
    static var greenColor: UIColor?{
        return hexStringToUIColor(hex: "#09A250")
    }
    
    
    static var redColor: UIColor?{
        return hexStringToUIColor(hex: "#5D1111")
    }
    
    
    static var redNoDetectColor: UIColor?{
        return hexStringToUIColor(hex: "#FF3333")
    }
    
    static var greenDetectColor: UIColor?{
        return hexStringToUIColor(hex: "#40ED90")
    }
    
    static var noDetectRedColor: UIColor? {
        return UIColor(red: 0.4450474977493286, green: 0.10395798832178116, blue: 0.08132988959550858, alpha: 1.0)
    }
    
    static var noDetectTextColor: UIColor? {
        return UIColor(red: 255/255, green: 51/255, blue: 51/255, alpha: 1.0)
    }
    
    static var disabledColor: UIColor?{
        return .darkGray
    }
    
    static func hexStringToUIColor (hex:String,alpha: CGFloat = 1.0) -> UIColor {
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
            alpha: alpha
        )
    }
}
