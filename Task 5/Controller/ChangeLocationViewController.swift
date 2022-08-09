//
//  ChangeLocationViewController.swift
//  Task 5
//
//  Created by Amais Sheikh on 02/11/2020.
//  Copyright © 2020 AmaisSheikh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class ChangeLocationViewController: UIViewController
{
    @IBOutlet weak var enterCityNameTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var cityName: String?
    
    var delegate: ChangeLocationViewControllerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        errorLabel.alpha = 0
        self.navigationItem.title = "Change City"
    }

    @IBAction func searchBtnPressed(_ sender: UIButton)
    {
        if let err = validateFields()
        {
            self.errorLabel.text = "*\(err)"
            self.errorLabel.alpha = 1
        }
        else
        {
            errorLabel.alpha = 0
            getWeatherDataForEnteredCity()
        }
        
    }
    
    func validateFields() -> String?
    {
        self.cityName = self.enterCityNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if cityName == ""
        {
            return "Enter a valid city name!"
        }
        
        guard Int(cityName!) == nil
        else
        {
            return "City name seems invalid!"
        }
        
        return nil
    }
    
    func getWeatherDataForEnteredCity()
    {
        let completeUrl = "\(WEATHER_API_URL)q=\(self.cityName!)&appid=\(WEATHER_API_KEY)"
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "loading..."
        
        AF.request(completeUrl).validate().responseJSON
        { [unowned self] (response) in
            switch response.result
            {
            case .success(let value):
                let jsonData = JSON(value)
                self.delegate?.loadWeatherData(with: jsonData)
                hud.hide(animated: true)
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                print(error)
                hud.hide(animated: true)
                self.showErrorAlert()
            }
        }
    }
    
    func showErrorAlert()
    {
        let alert = UIAlertController(title: "Error", message: "Error getting data for the entered city!", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}
