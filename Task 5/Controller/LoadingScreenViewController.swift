//
//  ViewController.swift
//  Task 5
//
//  Created by Amais Sheikh on 29/10/2020.
//  Copyright © 2020 AmaisSheikh. All rights reserved.
//

import UIKit
import Firebase

class LoadingScreenViewController: UIViewController
{
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupNavigationBarProperties()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        handleActivityIndicator()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func setupNavigationBarProperties()
    {
        let navbar = navigationController?.navigationBar
        navbar?.isTranslucent = false
        
        navbar?.barTintColor = Utilities.colorFromHex(0x373A40)
        navbar?.barStyle = .black
        navbar?.tintColor = .white
    }

    func handleActivityIndicator()
    {
        activityIndicatorView.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3)
        {
            if let _ = Auth.auth().currentUser
            {
                self.performSegue(withIdentifier: SEGUE_LOADING_TO_MAIN, sender: self)
            }
            else
            {
                self.performSegue(withIdentifier: SEGUE_LOADING_TO_SIGNIN, sender: self)
            }
        }
    }

}

