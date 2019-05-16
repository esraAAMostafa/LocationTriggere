//
//  ViewController.swift
//  LocationTriggere
//
//  Created by Esraa on 5/16/19.
//  Copyright © 2019 example. All rights reserved.
//

import UIKit

class ViewController: UIViewController, LocationNotificationSchadulerDelegate {

    var locationNotificationSchaduler = LocationNotificationSchaduler()

    func createLocationNotificationInfo() -> LocationNotificationInfo {
        let location = Location(latitude: 30.4692, longitude: 31.1900)
        let locationInfo = LocationInfo(locationId: "1", coordinates: location, radius: 50)
        let notificationInfo = NotificationInfo(notficationId: "1", title: "congratulation!",
                                                body: "welcome to cairo city", data: ["dhjsdh":"hdahd"])
        return LocationNotificationInfo(locationInfo: locationInfo, notificationInfo: notificationInfo)
    }

    @IBAction func schaduleLocationNotificationIsPressed(_ sender: UIButton) {
        locationNotificationSchaduler.requestNotification(with: createLocationNotificationInfo())
    }

    func locationPermissionDenied() {
        print("locationPermissionDenied")
    }
    
    func notificationPermissionDenied() {
        print(notificationPermissionDenied)
    }
    
    func notificationSchaduled(error: Error?) {
        print(error as Any)
    }
}

