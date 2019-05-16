//
//  LocationNotificationInfo.swift
//  LocationTriggere
//
//  Created by Esraa on 5/16/19.
//  Copyright © 2019 example. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationNotificationInfo {
    let locationInfo: LocationInfo
    let notificationInfo: NotificationInfo
}

struct LocationInfo {
    let locationId: String
    let coordinates: Location
    let radius: Double
}

struct NotificationInfo {
    let notficationId, title, body: String
    let data: [AnyHashable : Any]?
}

struct Location {
    let latitude, longitude: Double
}
