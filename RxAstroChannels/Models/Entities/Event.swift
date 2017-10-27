//
//  Event.swift
//  RxAstroChannels
//
//  Created by Candice H on 10/24/17.
//  Copyright © 2017 Candice H. All rights reserved.
//

import Foundation

struct Event {
    
    var eventID: Double?
    var channelId: Int?
    var channelStbNumber: String?
    var channelTitle: String?
    var displayDateTimeUtc: String?
    var displayDateTime: String?
    var displayDuration: String?
    var programmeTitle: String?
    
    var displayHour: String?
    var displayLocalDateTime: Date?
    var section: String?
    
}
extension Event {
    
    private enum Keys: String, SerializationKey {
        case eventID = "eventID"
        case channelId = "channelId"
        case channelStbNumber = "channelStbNumber"
        case channelTitle = "channelTitle"
        case displayDateTimeUtc = "displayDateTimeUtc"
        case displayDateTime = "displayDateTime"
        case displayDuration = "displayDuration"
        case programmeTitle
    }
    
    init(serialization: Serialization) {
        eventID = serialization.value(forKey: Keys.eventID)
        channelId = serialization.value(forKey: Keys.channelId)
        channelStbNumber = serialization.value(forKey: Keys.channelStbNumber)
        channelTitle = serialization.value(forKey: Keys.channelTitle)
        displayDateTimeUtc = serialization.value(forKey: Keys.displayDateTimeUtc)
        displayDateTime = serialization.value(forKey: Keys.displayDateTime)
        displayDuration = serialization.value(forKey: Keys.displayDuration)
        programmeTitle = serialization.value(forKey: Keys.programmeTitle)
        
        if let dateStringFromServer = displayDateTimeUtc {
            
            let dateFormatter =  DateFormatter()
            displayLocalDateTime = dateFormatter.date(fromSwapiString: dateStringFromServer)
            
            let secondDateFormatter = DateFormatter()
            secondDateFormatter.dateFormat = "h:mm a"
            displayHour = secondDateFormatter.string(from: displayLocalDateTime!)
            
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: displayLocalDateTime!)
            let minutes = calendar.component(.minute, from: displayLocalDateTime!)
            section = minutes < 30 ? HOURS[hour] : HALF_HOURS[hour]
        }
    }
}


