//
//  MobileNumberSignInViewController.swift
//  Task 5
//
//  Created by Amais Sheikh on 05/11/2020.
//  Copyright © 2020 AmaisSheikh. All rights reserved.
//

import UIKit
import SKCountryPicker
import Firebase
import MBProgressHUD

class MobileNumberSignInViewController: UIViewController
{
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var pickCountryBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var country: Country?
    var phoneNumber: String?
    var delegate: MobileLoginDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        errorLabel.alpha = 0
        setupPickCountryButtonTitle()
    }

    @IBAction func pickCountryBtnTapped(_ sender: UIButton)
    {
        let controller = CountryPickerController.presentController(on: self)
        { [unowned self] (country) in
            self.pickCountryBtn.setTitle(country.dialingCode, for: .normal)
            self.countryImageView.image = country.flag
            self.countryImageView.alpha = 1
            self.country = country
        }
        controller.flagStyle = .circular
    }
    
    
    @IBAction func signInTapped(_ sender: UIButton)
    {
        if let error = validateFields()
        {
            errorLabel.text = error
            errorLabel.alpha = 1
        }
        else
        {
            errorLabel.alpha = 0
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            PhoneAuthProvider.provider().verifyPhoneNumber(self.phoneNumber!, uiDelegate: nil)
            { [unowned self] (verificationId, error) in
                if let err = error
                {
                    print(err)
                    self.showErrorAlert()
                }
                else
                {
                    UserDefaults.standard.set(verificationId, forKey: "phoneVerificationId")
                    let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "otpVC") as! OTPViewController
                    vc.delegate = self
                    self.present(vc, animated: true, completion: nil)
                }
                hud.hide(animated: true)
            }
        }
    }
    
    
    func setupPickCountryButtonTitle()
    {
        guard let country = CountryManager.shared.currentCountry
        else
        {
            countryImageView.alpha = 0
            self.pickCountryBtn.setTitle("Pick Country", for: .normal)
            return
        }
        
        self.pickCountryBtn.setTitle(country.dialingCode, for: .normal)
        countryImageView.image = country.flag
        countryImageView.alpha = 1
    }
    
    func validateFields() -> String?
    {
        guard self.country != nil
        else
        {
            return "Please pick some country!"
        }
        
        guard mobileNumberTextField.text != ""
        else
        {
            return "Please enter a phone number"
        }
        
        let phoneNum = Int(mobileNumberTextField.text!)
        if phoneNum == nil
        {
            return "Phone number is invalid!"
        }
        
        if mobileNumberTextField.text!.count < 7
        {
            return "Phone number seems too short!"
        }
        
        if mobileNumberTextField.text!.count > 15
        {
            return "Phone number seems too long!"
        }
        
        self.phoneNumber = "\(self.country!.dialingCode!)\(phoneNum!)"
        return nil
    }
    
    func showErrorAlert()
    {
        let alert = UIAlertController(title: "Error", message: "Error signing in using mobile number!", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension MobileNumberSignInViewController: MobileLoginDelegate
{
    func loadMainScreenAfterSuccessfulLogin()
    {
        navigationController?.popViewController(animated: true)
        delegate?.loadMainScreenAfterSuccessfulLogin()
    }
}
