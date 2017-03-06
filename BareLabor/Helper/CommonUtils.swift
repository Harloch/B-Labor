//
//  CommonUtils.swift
//  For all swift projects
//
//  Created by Dustin Allen on 01/08/2016.
//  Copyright © 2016 BareLabor. All rights reserved.
//

import UIKit
import MBProgressHUD
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class CommonUtils: NSObject {
    
    static var progressView : MBProgressHUD = MBProgressHUD.init()

    // show alert view
    static func showAlert(_ title: String, message: String) {

        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        rootVC?.present(ac, animated: true){}
    }
    
    // Email Validator
    static func isValidEmail(_ email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluate(with: email)
        
        return result
    }
    // convert string to date
    static func stringToDate(_ dateStr: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let s = dateFormatter.date(from: dateStr)
        return s!
    }
    
    // show progress view
    static func showProgress(_ view : UIView, label : String) {
        progressView = MBProgressHUD.showAdded(to: view, animated: true)
        progressView.labelText = label
    }

    // hide progress view
    static func hideProgress(){
        progressView.removeFromSuperview()
        progressView.hide(true)
    }

    //compare two days and return string
    
    static func compareDate(_ fromDate: Date, toDate: Date) -> String {
        var difference = 0
        if Int(fromDate.year) == Int(toDate.year) {  // if year is same
            if Int(fromDate.month) == Int(toDate.month) {  // if month is same
                if Int(fromDate.date) == Int(toDate.date) {  // if date is same
                    if Int(fromDate.hour) == Int(toDate.hour) {  // if hour is same
                        if Int(fromDate.minute) == Int(toDate.minute) {  // if minute is same
                            return "RIGHT NOW"
                        }
                        else{
                            difference = Int(fromDate.minute)! - Int(toDate.minute)!
                            return "\(difference) MIN AGO"
                        }
                    }
                    else{
                        difference = Int(fromDate.hour)! - Int(toDate.hour)!
                        return "\(difference) HOUR AGO"
                    }
                }
                else{
                    difference = Int(fromDate.date)! - Int(toDate.date)!
                    return "\(difference) DAY AGO"
                }
            }
            else{
                difference = Int(fromDate.month)! - Int(toDate.month)!
                return "\(difference) MONTH AGO"
            }
        }
        else{
            difference = Int(fromDate.year)! - Int(toDate.year)!
            return "\(difference) YEAR AGO"
        }
        
    }
    // compare two days for bigger
    static func isBigger(_ fromDate: Date, toDate: Date) -> Bool {
        if Int(fromDate.year) == Int(toDate.year) {
            if Int(fromDate.monthNum) == Int(toDate.monthNum) {
                if Int(fromDate.date) == Int(toDate.date) {
                    if Int(fromDate.hourAMPM) == Int(toDate.hourAMPM) {
                        if Int(fromDate.minute) == Int(toDate.minute) {
                            return false
                        } else if Int(fromDate.minute) > Int(toDate.minute) {
                            return false
                        } else {
                            return true
                        }
                    } else if Int(fromDate.hourAMPM) > Int(toDate.hourAMPM) {
                        return false
                    } else {
                        return true
                    }
                } else if Int(fromDate.date) > Int(toDate.date) {
                    return false
                } else {
                    return true
                }
            } else if Int(fromDate.monthNum) > Int(toDate.monthNum) {
                return false
            } else {
                return true
            }
        } else if Int(fromDate.year) > Int(toDate.year) {
            return false
        } else {
            return true
        }
    }
    
    // compare two days for equal or bigger
    static func isEqualBigger(_ fromDate: Date, toDate: Date) -> Bool {
        if Int(fromDate.year) == Int(toDate.year) {
            if Int(fromDate.monthNum) == Int(toDate.monthNum) {
                if Int(fromDate.date) == Int(toDate.date) {
                    if Int(fromDate.hourAMPM) == Int(toDate.hourAMPM) {
                        if Int(fromDate.minute) == Int(toDate.minute) {
                            return true
                        } else if Int(fromDate.minute) > Int(toDate.minute) {
                            return false
                        } else {
                            return true
                        }
                    } else if Int(fromDate.hourAMPM) > Int(toDate.hourAMPM) {
                        return false
                    } else {
                        return true
                    }
                } else if Int(fromDate.date) > Int(toDate.date) {
                    return false
                } else {
                    return true
                }
            } else if Int(fromDate.monthNum) > Int(toDate.monthNum) {
                return false
            } else {
                return true
            }
        } else if Int(fromDate.year) > Int(toDate.year) {
            return false
        } else {
            return true
        }
    }
    
    static func colorWithHexString (_ hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercased()
        
        if cString.hasPrefix("#") {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if cString.characters.count != 6 {
            return UIColor.gray
        }
        
        var rgbValue : UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}



// for custom font
extension UILabel {
    // regular
    var substituteFontName : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.range(of: "Bold") == nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
    
    // bold
    var substituteFontNameBold : String {
        get { return self.font.fontName }
        set {
            if self.font.fontName.range(of: "Bold") != nil {
                self.font = UIFont(name: newValue, size: self.font.pointSize)
            }
        }
    }
}

// for get date
extension Date {
    // year
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYY"
        return dateFormatter.string(from: self)
    }
    
    // week day
    var weekDay: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self)
    }
    
    // month
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    // month - Number
    var monthNum: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M"
        return dateFormatter.string(from: self)
    }
    
    // week day
    var date: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    // hour
    var hour: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH"
            
            if self.AMPM == "PM" {
                return String(stringInterpolationSegment: Int(dateFormatter.string(from: self))! - 12)
            } else {
                return dateFormatter.string(from: self)
            }
        }
    }
    
    var hourAMPM: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH"
            
            return dateFormatter.string(from: self)
        }
    }
    
    // week
    var minute: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        return dateFormatter.string(from: self)
    }
    
    // AM & PM
    var AMPM: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a"
        return dateFormatter.string(from: self)
    }
}


extension UIImageView {
    func downloadedFrom(link:String, contentMode mode: UIViewContentMode) {
        guard
            let url = URL(string: link)
            else {return}
        contentMode = mode
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async { () -> Void in
                self.image = image
            }
        }).resume()
    }
}
