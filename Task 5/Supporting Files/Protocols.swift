//
//  Protocols.swift
//  Task 5
//
//  Created by Amais Sheikh on 03/11/2020.
//  Copyright © 2020 AmaisSheikh. All rights reserved.
//

import CoreLocation
import SwiftyJSON

protocol HomeAndCurrentLocationViewControllerDelegate
{
    func getUserLocation() -> CLLocationManager?
}

protocol MainScreenSideMenuViewControllerDelegate
{
    func getUserLocationData() -> CLLocationManager?
}

protocol  ChangeLocationViewControllerDelegate
{
    func loadWeatherData(with data: JSON)
}

protocol MobileLoginDelegate
{
    func loadMainScreenAfterSuccessfulLogin()
}
