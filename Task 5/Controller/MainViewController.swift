//
//  MainViewController.swift
//  Task 5
//
//  Created by Amais Sheikh on 29/10/2020.
//  Copyright © 2020 AmaisSheikh. All rights reserved.
//

import UIKit
import Firebase
import SideMenu
import CoreLocation

class MainViewController: UIViewController
{
    var sideMenu: SideMenuNavigationController?
    var sideMenuBtn: UIBarButtonItem?
    
    var locManager = CLLocationManager()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupCoreLocation()
        setupCurrentScreenNavigationBar()
        setupSideMenu()
    }
    
    func setupCoreLocation()
    {
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locManager.requestWhenInUseAuthorization()
        locManager.startUpdatingLocation()
    }
    
    func setupCurrentScreenNavigationBar()
    {
        self.navigationItem.title = "Main"
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let signOutBtn = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleSignOut))
        self.navigationItem.rightBarButtonItems = [signOutBtn]
        
        sideMenuBtn = UIBarButtonItem(image: UIImage(systemName: "chevron.right.2"), style: .plain, target: self, action: #selector(handleSideMenu))
        self.navigationItem.leftBarButtonItems = [sideMenuBtn!]
    }
    
    func setupSideMenu()
    {
        let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "sideMenuRootVC") as! MainScreenSideMenuViewController
        vc.delegate = self
        self.sideMenu = SideMenuNavigationController(rootViewController: vc)
        self.sideMenu?.leftSide = true
        self.sideMenu?.menuWidth = self.view.frame.size.width / 1.25
    }
    
    @objc func handleSignOut()
    {
        let alert = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive)
        { [unowned self] (alertAction) in
            do
            {
                try Auth.auth().signOut()
                self.navigationController?.popToRootViewController(animated: true)
            } catch
            {
                print(error)
            }
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleSideMenu()
    {
        guard sideMenu != nil else {return}
        self.present(sideMenu!, animated: true, completion: nil)
        sideMenuBtn?.image = UIImage(systemName: "chevron.left.2")
    }
}

extension MainViewController: SideMenuNavigationControllerDelegate, MainScreenSideMenuViewControllerDelegate
{
    func getUserLocationData() -> CLLocationManager?
    {
        return locManager
    }
    
    func sideMenuWillDisappear(menu: SideMenuNavigationController, animated: Bool)
    {
        self.sideMenuBtn?.image = UIImage(systemName: "chevron.right.2")
    }
}

extension MainViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard let lastLocation = locations.last else {return}
        if lastLocation.horizontalAccuracy > 0
        {
            locManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print(error)
    }
}
