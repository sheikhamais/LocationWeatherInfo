//
//  SignInViewController.swift
//  Task 5
//
//  Created by Amais Sheikh on 29/10/2020.
//  Copyright © 2020 AmaisSheikh. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class SignInViewController: UIViewController
{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var email: String?
    var password: String?
    
    var userId: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        errorLabel.alpha = 0
        self.addEndEditingGesture()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func signInBtnTapped(_ sender: UIButton)
    {
        if let error = cleanAndValidateFields()
        {
            self.errorLabel.text = "*\(error)"
            errorLabel.alpha = 1
        }
        else
        {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            Auth.auth().signIn(withEmail: self.email!, password: self.password!)
            { [unowned self] (result, error) in
                if let err = error
                {
                    print(err)
                    self.errorLabel.text = "*\(err.localizedDescription)"
                    self.errorLabel.alpha = 1
                }
                else
                {
                    self.userId = result?.user.uid
                    self.performSegue(withIdentifier: SEGUE_SIGNIN_TO_MAIN, sender: self)
                }
                hud.hide(animated: true)
            }
        }
    }
    
    @IBAction func signUpBtnTapped(_ sender: UIButton)
    {
        performSegue(withIdentifier: SEGUE_SIGNIN_TO_SIGNUP, sender: self)
    }
    
    @IBAction func signInUsingMobileNumberTapped(_ sender: UIButton)
    {
        performSegue(withIdentifier: SEGUE_SIGNIN_TO_MOBILESIGNUP, sender: self)
    }
    
    func cleanAndValidateFields() -> String?
    {
        self.email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if email == "" || password == ""
        {
            return "Please fill in all the fields!"
        }
        
        if !Utilities.isValidEmail(self.email!)
        {
            return "Email does not seems correct!"
        }
        
        if !Utilities.isPasswordValid(self.password!)
        {
            return "Password must have at least 1 alphabet and 1 number, and must be at least 8 characters long!"
        }
        
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == SEGUE_SIGNIN_TO_MOBILESIGNUP
        {
            let vc = segue.destination as! MobileNumberSignInViewController
            vc.delegate = self
        }
    }
    
}

extension SignInViewController: MobileLoginDelegate
{
    func loadMainScreenAfterSuccessfulLogin()
    {
        self.performSegue(withIdentifier: SEGUE_SIGNIN_TO_MAIN, sender: self)
    }
}
