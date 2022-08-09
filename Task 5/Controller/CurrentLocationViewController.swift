//
//  CurrentLocationViewController.swift
//  Task 5
//
//  Created by Amais Sheikh on 02/11/2020.
//  Copyright © 2020 AmaisSheikh. All rights reserved.
//

import UIKit
import GoogleMaps

class CurrentLocationViewController: UIViewController
{
    @IBOutlet weak var mapView: GMSMapView!
    
    var delegate: HomeAndCurrentLocationViewControllerDelegate?
    var location: CLLocation?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.navigationItem.title = "My Location"
        getLocationAndMoveMapCamera()
    }

    func getLocationAndMoveMapCamera()
    {
        guard let coordinates = delegate?.getUserLocation()?.location?.coordinate
        else
        {
            print("Error getting the location")
            showErrorAlert()
            return
        }
        
        mapView.isMyLocationEnabled = true
        let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 12)
        mapView.animate(to: camera)
    }
    
    func showErrorAlert()
    {
        let alert = UIAlertController(title: "Error", message: "Location is not available!", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
}
