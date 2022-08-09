//
//  SignUpViewController.swift
//  Task 5
//
//  Created by Amais Sheikh on 29/10/2020.
//  Copyright © 2020 AmaisSheikh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MBProgressHUD

class SignUpViewController: UIViewController
{
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var birthDatePickerTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var fieldsContainerView: UIView!
    
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    var dateOfBirth: String?
    var password: String?
    
    var userId: String?
    
    let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        errorLabel.alpha = 0
        setupBirthDatePicker()
        self.addEndEditingGesture()
        setupKeyboardAppearenceNotifications()
    }
    
    @IBAction func signUpBtnTapped(_ sender: UIButton)
    {
        if let error = cleanAndValidateFields()
        {
            self.errorLabel.text = "*\(error)"
            errorLabel.alpha = 1
        }
        else
        {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            let auth = Auth.auth()
            auth.createUser(withEmail: self.email!, password: self.password!)
            { [unowned self] (result, error) in
                if let err = error
                {
                    print(err)
                    self.errorLabel.text = "*\(err.localizedDescription)"
                    self.errorLabel.alpha = 1
                }
                else
                {
                    guard result?.user.uid != nil
                    else
                    {
                        return
                    }
                    self.userId = result?.user.uid
                    
                    let hud2 = MBProgressHUD.showAdded(to: self.view, animated: true)
                    let userRef = self.db.collection("users").document(self.userId!)
                    userRef.setData(["firstName": self.firstName!,
                                     "lastName": self.lastName!,
                                     "phoneNo": Int(self.phoneNumber!)!,
                                     "birthDate": self.dateOfBirth!])
                    { (error) in
                        if let err = error
                        {
                            print(err.localizedDescription)
                            self.errorLabel.text = "Unable to successfully store user data in database!"
                            self.errorLabel.alpha = 1
                        }
                        else
                        {
                            self.performSegue(withIdentifier: SEGUE_SIGNUP_TO_MAIN, sender: self)
                        }
                        hud2.hide(animated: true)
                    }
                }
                hud.hide(animated: true)
            }
        }
    }
    
    func cleanAndValidateFields() -> String?
    {
        self.firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.phoneNumber = phoneNumberTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.dateOfBirth = birthDatePickerTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let confirmPass = confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if firstName == "" || lastName == "" || email == "" || phoneNumber == "" || dateOfBirth == "" || password == "" || confirmPass == ""
        {
            return "Please fill in all the fields!"
        }
        
        if !Utilities.isValidEmail(self.email!)
        {
            return "Email does not seems correct!"
        }
        
        let phoneNum = Int(self.phoneNumber!)
        if phoneNum == nil
        {
            return "Phone number is incorrect!"
        }
        
        if self.phoneNumber!.count < 7
        {
            return "Phone number seems too short!"
        }
        
        if self.phoneNumber!.count > 15
        {
            return "Phone number seems too long!"
        }
        
        //date of birth validation to be done here
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: self.dateOfBirth!)
        if date == nil
        {
            return "Date is not correct!"
        }
        
        if !Utilities.isPasswordValid(self.password!)
        {
            return "Password must have at least 1 alphabet and 1 number, and must be at least 8 characters long!"
        }
        
        if self.password! != confirmPass
        {
            return "Your passwords do not match!"
        }
        
        self.errorLabel.alpha = 0
        return nil
    }
    
    func setupBirthDatePicker()
    {
        datePicker.datePickerMode = .date
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(handleDateDoneBtn))
        toolbar.setItems([doneBtn], animated: true)
        
        birthDatePickerTextField.inputView = datePicker
        birthDatePickerTextField.inputAccessoryView = toolbar
    }
    
    @objc func handleDateDoneBtn()
    {
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dateValue = dateFormatter.string(from: datePicker.date)
        self.birthDatePickerTextField.text = dateValue
        self.birthDatePickerTextField.endEditing(true)
    }
    
    func setupKeyboardAppearenceNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardShow(sender: NSNotification)
    {
        var keyboardY: CGFloat = 0
        if let keyboardSize = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        {
            let keyboardFrame = keyboardSize.cgRectValue
            keyboardY = keyboardFrame.origin.y
        }
        
        let fieldsContainerY = fieldsContainerView.frame.origin.y
        if phoneNumberTextField.isEditing
        {
            let fieldMaxY = phoneNumberTextField.frame.maxY
            if keyboardY < (fieldsContainerY + fieldMaxY)
            {
                self.view.frame.origin.y = keyboardY - fieldsContainerY - fieldMaxY - 1
            }
        }
        else if birthDatePickerTextField.isEditing
        {
            let fieldMaxY = birthDatePickerTextField.frame.maxY
            if keyboardY < (fieldsContainerY + fieldMaxY)
            {
                self.view.frame.origin.y = keyboardY - fieldsContainerY - fieldMaxY - 1
            }
        }
        else if passwordTextField.isEditing
        {
            let fieldMaxY = passwordTextField.frame.maxY
            if keyboardY < (fieldsContainerY + fieldMaxY)
            {
                self.view.frame.origin.y = keyboardY - fieldsContainerY - fieldMaxY - 1
            }
        }
        else if confirmPasswordTextField.isEditing
        {
            let fieldMaxY = confirmPasswordTextField.frame.maxY
            if keyboardY < (fieldsContainerY + fieldMaxY)
            {
                self.view.frame.origin.y = keyboardY - fieldsContainerY - fieldMaxY - 1
            }
        }
    }
    
    @objc func handleKeyboardHide()
    {
        self.view.frame.origin.y = 0
    }
    
}
