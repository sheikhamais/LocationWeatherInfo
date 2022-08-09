//
//  MainScreenSideMenuViewController.swift
//  Task 5
//
//  Created by Amais Sheikh on 02/11/2020.
//  Copyright © 2020 AmaisSheikh. All rights reserved.
//

import UIKit
import CoreLocation

class MainScreenSideMenuViewController: UIViewController
{
    @IBOutlet weak var homeBtnContainerView: UIView!
    @IBOutlet weak var locationBtnContainerView: UIView!
    
    var delegate: MainScreenSideMenuViewControllerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupGesturesForViews()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
//    func setVisuals()
//    {
//        homeBtnContainerView.layer.cornerRadius = 5
//        locationBtnContainerView.layer.cornerRadius = 5
//    }
    
    func setupGesturesForViews()
    {
        let homeViewGesture = UITapGestureRecognizer(target: self, action: #selector(handleHomeViewTap))
        let locationViewGesture = UITapGestureRecognizer(target: self, action: #selector(handleLocationViewTap))
        
        self.homeBtnContainerView.addGestureRecognizer(homeViewGesture)
        self.locationBtnContainerView.addGestureRecognizer(locationViewGesture)
    }
    
    @objc func handleHomeViewTap()
    {
        performSegue(withIdentifier: SEGUE_MAIN_TO_HOME, sender: self)
        
    }

    @objc func handleLocationViewTap()
    {
        performSegue(withIdentifier: SEGUE_MAIN_TO_CURRENTLOCATION, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == SEGUE_MAIN_TO_HOME
        {
            let vc = segue.destination as! HomeViewController
            vc.delegate = self
        }
        else if segue.identifier == SEGUE_MAIN_TO_CURRENTLOCATION
        {
            let vc = segue.destination as! CurrentLocationViewController
            vc.delegate = self
        }
    }
}

extension MainScreenSideMenuViewController: HomeAndCurrentLocationViewControllerDelegate
{
    func getUserLocation() -> CLLocationManager?
    {
        return delegate?.getUserLocationData()
    }
}

