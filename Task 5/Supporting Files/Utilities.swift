//
//  Utilities.swift
//  Task 5
//
//  Created by Amais Sheikh on 29/10/2020.
//  Copyright © 2020 AmaisSheikh. All rights reserved.
//

import UIKit

class  Utilities
{
    // function to validate email format in a text field
    static func isValidEmail(_ email: String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // function to validate password in the password field
    static func isPasswordValid(_ pass: String) -> Bool
    {
        //this part is for checking if password contains a letter, a number and is of length 8
        let passRegEx = "^(?=.*[a-z])(?=.*[0-9]).{8,}$"
        let passPred = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let Res1 = passPred.evaluate(with: pass)
        
        //this part checks if password contains any of special characters
        var Res2 = true
        do
        {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: pass, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, pass.count))
            {
                Res2 = false
            }

        } catch
        {
            debugPrint(error.localizedDescription)
            print("We were in catch block of password validation function!")
            return false
        }

        //if password succeeds in both upper cases then result is sent true
        //for succeeding a password must only contains letters and numbers, and must be at least length 8 char
        if Res1 && Res2
        {
            return true
        }
        else
        {
            return false
        }
        
    }
    
    static func colorFromHex(_ rgbValue: UInt) -> UIColor
    {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
