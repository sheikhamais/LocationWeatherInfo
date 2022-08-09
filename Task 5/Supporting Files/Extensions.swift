//
//  Extensions.swift
//  Task 5
//
//  Created by Amais Sheikh on 02/11/2020.
//  Copyright © 2020 AmaisSheikh. All rights reserved.
//

import UIKit

extension UIViewController
{
    func addEndEditingGesture()
    {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func handleTap()
    {
        self.view.endEditing(true)
    }
}
