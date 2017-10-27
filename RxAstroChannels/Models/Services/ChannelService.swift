//
//  ChannelService.swift
//  RxAstroChannels
//
//  Created by Candice H on 10/24/17.
//  Copyright © 2017 Candice H. All rights reserved.
//

import Foundation
import RxSwift

class ChannelService {
        
    private var channels = Variable<[Channel]>([])
    private var events = Variable<[Event]>([])
    private var disposeBag = DisposeBag()
    
    init() {
        channels.value = [Channel]()
    }
    // MARK: - fetching Channels from server and update observable channels
    private func fetchData() -> [Channel] {
        let observable = AstroAPI.channels.asObservable()
        observable.subscribe(onNext: { [weak self] (channels) in
            self?.channels.value = channels.sorted (by: {$0.title! < $1.title!})
            for channel in (self?.channels.value)! {
                DataManagement.addChannel(channel: channel)
            }
        }).addDisposableTo(disposeBag)
        return channels.value
    }
    
    // MARK: - return observable channels
    func fetchObservableData() -> Observable<[Channel]> {
        channels.value = fetchData()
        return channels.asObservable()
    }
    
    // MARK: - sort by
    public func sort(withChannel type: Int) {
        channels.value = type == 0 ? channels.value.sorted (by: {$0.title! < $1.title!}) : channels.value.sorted (by: {$0.stbNumber < $1.stbNumber})
    }
    
    // MARK: - toggle selected channel's isFavorite value
    public func updateFavorite(withIndex index: Int) {
        if index >= 0 && index <= channels.value.count {
            let channel = channels.value[index]
            channel.isFavorite = !channel.isFavorite
            channels.value[index] = channel
            DataManagement.updateChannel(channel: channels.value[index])
        }
    }
    
    // MARK: - fetching Channels from server and update observable channels
    public func fetchEvents(withChannelIDs ids: [Int]) {
        let observable = AstroAPI.getEvents(withChannelIDs: ids).asObservable()
        observable.subscribe(onNext: { [weak self] (events) in
            self?.events.value = events
            var tempEvents:[Event] = []
            for event in events {
                if Calendar.current.isDateInToday(event.displayLocalDateTime!) {
                    tempEvents.append(event)
                }
            }
            tempEvents = tempEvents.sorted { $0.displayLocalDateTime! < $1.displayLocalDateTime! }
            
            for (index, channel) in (self?.channels.value.enumerated())! {
                let channelEvents = tempEvents.filter({$0.channelId == channel.id})
                if channelEvents.count > 0 {
                    self?.channels.value[index].events = channelEvents
                }
            }
        }).addDisposableTo(disposeBag)
    }
}
