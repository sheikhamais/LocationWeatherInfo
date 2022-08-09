//
//  OTPViewController.swift
//  Task 5
//
//  Created by Amais Sheikh on 05/11/2020.
//  Copyright © 2020 AmaisSheikh. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class OTPViewController: UIViewController
{

    @IBOutlet weak var receivedCodeField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var delegate: MobileLoginDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        errorLabel.alpha = 0
    }

    @IBAction func cancelTapped(_ sender: UIButton)
    {
        askConfirmationAlert()
    }
    
    @IBAction func submitTapped(_ sender: UIButton)
    {
        let verificationCode = receivedCodeField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard verificationCode != ""
        else
        {
            errorLabel.text = "Please fill in the received code!"
            errorLabel.alpha = 1
            return
        }
        
        errorLabel.alpha = 0
        
        let verificationId = UserDefaults.standard.value(forKey: "phoneVerificationId") as! String
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: verificationCode!)
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        Auth.auth().signIn(with: credential)
        { [unowned self] (authResult, error) in
            if let err = error
            {
                print("Failed to sign in: \(err)")
                self.showErrorAlert()
            }
            else
            {
                self.dismiss(animated: true, completion: nil)
                self.delegate?.loadMainScreenAfterSuccessfulLogin()
            }
            hud.hide(animated: true)
        }
    }
    
    func askConfirmationAlert()
    {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure?\nThe app will send a new code, when you sign in again with phone number!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let goBackAction = UIAlertAction(title: "Go Back!", style: .destructive)
        { [unowned self] (alertAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(goBackAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert()
    {
        let alert = UIAlertController(title: "Error", message: "Error signing in!", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
