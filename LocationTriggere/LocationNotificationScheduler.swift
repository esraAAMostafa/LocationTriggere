//
//  LocationNotificationScheduler.swift
//  LocationTriggere
//
//  Created by Esraa on 5/16/19.
//  Copyright © 2019 example. All rights reserved.
//

import CoreLocation
import UserNotifications

protocol LocationNotificationSchadulerDelegate: class {
    func locationPermissionDenied()
    func notificationPermissionDenied()
    func notificationSchaduled(error: Error?)
}

class LocationNotificationSchaduler: NSObject, UNUserNotificationCenterDelegate {

    weak var delegate: LocationNotificationSchadulerDelegate? {
        didSet {
            UNUserNotificationCenter.current().delegate = self
        }
    }
    
    private let locationManager = CLLocationManager()
    
    func requestNotification(with notificationInfo: LocationNotificationInfo) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            askForNotificationPermition(notificationInfo: notificationInfo)
        case .restricted, .denied:
            delegate?.locationPermissionDenied()
        }
    }
}

private extension LocationNotificationSchaduler {
    func askForNotificationPermition(notificationInfo: LocationNotificationInfo) {
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            guard granted else {
                self?.delegate?.notificationPermissionDenied()
                return
            }
            self?.requestNotification(notificationInfo: notificationInfo)
        }
    }
    
    func requestNotification(notificationInfo: LocationNotificationInfo) {
        let notification = noificationContent(notificationInfo: notificationInfo)
        let destRegion = destinationRegion(notificationInfo: notificationInfo)
        let trigger = UNLocationNotificationTrigger(region: destRegion, repeats: false)
        
        let request = UNNotificationRequest(identifier: notificationInfo.notificationInfo.notficationId,
                                            content: notification,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { [weak self] (error) in
            DispatchQueue.main.async {
                self?.delegate?.notificationSchaduled(error: error)
            }
        }
    }
    
    func noificationContent(notificationInfo: LocationNotificationInfo) -> UNMutableNotificationContent {
        let notificationInfo = notificationInfo.notificationInfo
        let notification = UNMutableNotificationContent()
        notification.title = notificationInfo.title
        notification.body = notificationInfo.body
        notification.sound = UNNotificationSound.default
        
        if let data = notificationInfo.data {
            notification.userInfo = data
        }
        return notification
    }
    
    func destinationRegion(notificationInfo: LocationNotificationInfo) -> CLCircularRegion {
        let notificationInfo = notificationInfo.locationInfo
        let destRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: notificationInfo.coordinates.latitude, longitude: notificationInfo.coordinates.longitude),
                                          radius: notificationInfo.radius,
                                          identifier: notificationInfo.locationId)
        destRegion.notifyOnEntry = true
        destRegion.notifyOnExit = false
        return destRegion
    }
}
