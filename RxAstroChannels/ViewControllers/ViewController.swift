//
//  ViewController.swift
//  RxAstroChannels
//
//  Created by Candice H on 10/24/17.
//  Copyright © 2017 Candice H. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let cellIdentifier = "CollectionViewCell"
    
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var visibleCurrentCell: IndexPath? {
        for cell in self.collectionView.visibleCells {
            let indexPath = self.collectionView.indexPath(for: cell)
            return indexPath
        }
        return nil
    }
    
    lazy var currentHourIndex: Int? = { [unowned self] in
        let now = Date()
        let secondDateFormatter = DateFormatter()
        secondDateFormatter.dateFormat = "h:mm a"
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minutes = calendar.component(.minute, from: now)
        let currentHour:String? = minutes < 30 ? HOURS[hour] : HALF_HOURS[hour]
        return TIMES.index(where: {$0 == currentHour })
        }()
    
    var channelIDs: [Int] = []
    var previousChannelIDs: [Int] = []
    var numberIndexs: Int = 10
    
    var viewModel = CollectionViewModel()
    var disposeBag = DisposeBag()
    var channels = [Channel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        populateChannelsToCollectionView()
        setupCollectionViewCellWhenTapped()
        setupActionWhenSegmentButtonTapped()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func populateChannelsToCollectionView() {
        let observableChannels = viewModel.getChannels().asObservable()
        observableChannels.subscribe({ [weak self] items in
            self?.channels = items.element!
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }).addDisposableTo(disposeBag)
    }
    
    func setupCollectionViewCellWhenTapped() {
        collectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.collectionView.deselectItem(at: indexPath, animated: false)
                self.viewModel.updateFavorite(withChannelIndex: indexPath.section - 1)
            })
            .addDisposableTo(disposeBag)
    }
    
    func setupActionWhenSegmentButtonTapped() {
        self.sortSegmentedControl.rx.selectedSegmentIndex.asObservable().subscribe { [weak self] index in
            self?.viewModel.sortBy(withChannel: index.element!)
            }
            .addDisposableTo(disposeBag)
    }
    
    func setChannelIDs() {
        previousChannelIDs = previousChannelIDs + self.channelIDs
        self.channelIDs = []
        let maxNumber = self.numberIndexs
        for (index, currentChannel) in (self.channels.enumerated()) {
            if currentChannel.events.count > 0 || previousChannelIDs.contains(currentChannel.id) {
                continue
            }
            if index >= maxNumber {
                break
            }
            if index < maxNumber - 10 {
                continue
            }
            self.channelIDs.append(currentChannel.id)
        }
    }
    
    func fetchEvents() {
        if channelIDs.count < 1 {
            return
        }
        viewModel.fetchEvents(withChannelIDs: channelIDs)
    }
}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return channels.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TIMES.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
        cell.descriptionLabel.text = ""
        cell.bottomRightButton.isHidden = true
        cell.backgroundColor = indexPath.section % 2 != 0 ? UIColor(white: 242/255.0, alpha: 1.0) : UIColor.white
        
        if indexPath.section == 0 {
            cell.titleLabel.text = indexPath.row == 0 ? "On Now" : (indexPath.row % 2 != 0 ? TIMES[indexPath.row - 1] : "")
        } else {
            let channel = self.channels[indexPath.section - 1]
            if indexPath.row == 0 {
                cell.channel = channel
            } else {
                cell.titleLabel.text = ""
                if let currentIndex = channel.events.index(where: {$0.section! == TIMES[indexPath.row - 1]}) {
                    cell.titleLabel.text = channel.events[currentIndex].programmeTitle
                    cell.descriptionLabel.text = channel.events[currentIndex].displayHour
                }
            }
        }
        if indexPath.row - 1 == currentHourIndex {
            cell.backgroundColor = UIColor(white: 200/255.0, alpha: 1.0)
            cell.descriptionLabel.text = indexPath.section == 0 ? "NOW" : cell.descriptionLabel.text
        }
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath = collectionView.indexPathForItem(at: visiblePoint)!
        
        self.numberIndexs = visibleIndexPath.section + 5
        self.setChannelIDs()
        self.fetchEvents()
    }
}
