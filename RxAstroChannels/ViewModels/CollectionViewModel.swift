//
//  CollectionViewModel.swift
//  RxAstroChannels
//
//  Created by Candice H on 10/24/17.
//  Copyright © 2017 Candice H. All rights reserved.
//

import Foundation
import RxSwift
struct CollectionViewModel {
    
    private var channels = Variable<[Channel]>([])
    private var service = ChannelService()
    private var disposeBag = DisposeBag()
    
    init() {
        fetchTodosAndUpdateObservableTodos()
    }
    
    public func getChannels() -> Variable<[Channel]> {
        return channels
    }
    // MARK: - fetching Todos from Core Data and update observable todos
    private func fetchTodosAndUpdateObservableTodos() {
        service.fetchObservableData()
            .map({ $0 })
            .subscribe(onNext : { (todos) in
                self.channels.value = todos
            })
            .addDisposableTo(disposeBag)
    }
    // MARK: - sort by
    public func sortBy(withChannel type: Int) {
        service.sort(withChannel: type)
    }
    // MARK: - toggle selected channel's isFavorite value
    public func updateFavorite(withChannelIndex index: Int) {
        service.updateFavorite(withIndex: index)
    }
    
    // MARK: - Fetch events lazy load
    public func fetchEvents(withChannelIDs ids: [Int]) {
        service.fetchEvents(withChannelIDs: ids)
    }
}
