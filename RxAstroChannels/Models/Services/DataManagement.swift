//
//  DataManagement.swift
//  RxAstroChannels
//
//  Created by Candice H on 10/27/17.
//  Copyright © 2017 Candice H. All rights reserved.
//

import Foundation
import RealmSwift

class DataManagement: NSObject {
    
    static func addChannel(channel: Channel) {
        DispatchQueue.global(qos: .background).async {
            let myRealm = try! Realm()
            try! myRealm.write {
                myRealm.dynamicCreate("Channel", value: channel, update: true)
            }
        }
    }
    
    static func updateChannel(channel: Channel) {
        DispatchQueue.global(qos: .background).async {
            let myRealm = try! Realm()
            let dataChannel = myRealm.objects(Channel.self).filter("id == %@", channel.id).first
            try! myRealm.write {
                dataChannel!.category = channel.category
                dataChannel!.isFavorite = channel.isFavorite
                dataChannel!.descriptionChannel = channel.descriptionChannel
                dataChannel!.stbNumber = channel.stbNumber
            }
        }
    }
}
