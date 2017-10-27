//
//  Channel.swift
//  RxAstroChannels
//
//  Created by Candice H on 10/24/17.
//  Copyright © 2017 Candice H. All rights reserved.
//

import Foundation
import RealmSwift
class Channel : Object {
    
    dynamic var id: Int = 0
    dynamic var title: String?
    dynamic var stbNumber: Int = 0
    dynamic var descriptionChannel: String?
    dynamic var category: String?
    dynamic var isFavorite: Bool = false
    var events: [Event] = []
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
extension Channel {
    private enum Keys: String, SerializationKey {
        case channelId = "channelId"
        case channelTitle = "channelTitle"
        case channelStbNumber = "channelStbNumber"
        case channelDescription
        case channelCategory
    }
    
    convenience init(serialization: Serialization) {
        self.init()
        self.id = serialization.value(forKey: Keys.channelId)!
        self.title = serialization.value(forKey: Keys.channelTitle)
        self.stbNumber = serialization.value(forKey: Keys.channelStbNumber)!
    }
}
