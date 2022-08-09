//
//  HomeViewController.swift
//  Task 5
//
//  Created by Amais Sheikh on 02/11/2020.
//  Copyright © 2020 AmaisSheikh. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import MBProgressHUD

class HomeViewController: UIViewController
{
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var bottomDesignerView: UIView!
    
    var delegate: HomeAndCurrentLocationViewControllerDelegate?
    
    var locManager: CLLocationManager?
    var climate: Climate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.bottomDesignerView.layer.cornerRadius = 400
        self.navigationItem.title = "Home"
        self.locManager = delegate?.getUserLocation()
        
        getWeatherData()
    }
    
    @IBAction func changeCityTapped(_ sender: UIButton)
    {
        performSegue(withIdentifier: SEGUE_HOME_TO_CHANGELOCATION, sender: self)
    }
    
    func getWeatherData()
    {
        guard locManager != nil, let latitude = locManager?.location?.coordinate.latitude, let longitude = locManager?.location?.coordinate.longitude
        else
        {
            self.cityNameLabel.text = "Location not available"
            return
        }
        
        let completeUrl = "\(WEATHER_API_URL)lat=\(latitude)&lon=\(longitude)&appid=\(WEATHER_API_KEY)"
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.label.text = "loading..."
        AF.request(completeUrl).responseJSON
        { [unowned self] (response) in
            switch response.result
            {
            case .success(let value):
                self.climate = Climate(json: JSON(value))
                print(JSON(value))
                self.updateUI()
            case .failure(let error):
                print(error)
            }
            hud.hide(animated: true)
        }
    }
    
    func updateUI()
    {
        guard let climate = self.climate
        else
        {
            self.cityNameLabel.text = "Location not available"
            return
        }
        
        self.cityNameLabel.text = climate.cityName
        self.temperatureLabel.text = "Temperature (Min: \(climate.temperatureMin), Max:\(climate.temperatureMax))"
        self.humidityLabel.text = "Humidity: \(climate.humidity)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == SEGUE_HOME_TO_CHANGELOCATION
        {
            let vc = segue.destination as! ChangeLocationViewController
            vc.delegate = self
        }
    }

}

extension HomeViewController: ChangeLocationViewControllerDelegate
{
    func loadWeatherData(with data: JSON)
    {
        self.climate = Climate(json: data)
        self.updateUI()
    }
}
