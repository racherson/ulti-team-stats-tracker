//
//  PlayGameViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PlayGamePresenterProtocol where Self: Presenter {
    func fullLine() -> Bool
    func displayConfirmAlert()
    func startPoint()
    func numberOfPlayersInSection(_ section: Int) -> Int
    func getPlayerName(at indexPath: IndexPath) -> String
}

class PlayGameViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: PlayGamePresenterProtocol!
    @IBOutlet weak var collectionView: UICollectionView!
    private let itemsPerRow: CGFloat = 4
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setUpButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    func updateView() {
        collectionView.reloadData()
    }
    
    //MARK: Private methods
    private func setUpButtons() {
        // Add cancel button
        let button = UIBarButtonItem(title: "Start", style: .done, target: self, action: #selector(self.startPointPressed))
        navigationItem.rightBarButtonItem  = button
    }
    
    //MARK: Actions
    @objc func startPointPressed() {
        // Check if the line is full
        if !presenter.fullLine() {
            // Display confirmation alert
            presenter.displayConfirmAlert()
        }
        else {
            presenter.startPoint()
        }
    }
}

//MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension PlayGameViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Gender.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfPlayersInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "PlayerCollectionViewCell"
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            as? PlayerCollectionViewCell else {
                fatalError(Constants.Errors.dequeueError(cellIdentifier))
        }
        
        // Configure the cell
        switch indexPath.section {
        case Gender.women.rawValue:
            cell.backgroundColor = .red
        case Gender.men.rawValue:
            cell.backgroundColor = .blue
        default:
            cell.backgroundColor = .gray
        }
        
        cell.label.text = presenter.getPlayerName(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView( ofKind: kind, withReuseIdentifier: "\(PlayersCollectionHeaderView.self)", for: indexPath) as? PlayersCollectionHeaderView else {
                fatalError("Invalid view type")
            }
            
            headerView.label.text = Gender(rawValue: indexPath.section)?.description
            return headerView
            
        default:
            fatalError("Invalid element type")
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension PlayGameViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView.numberOfItems(inSection: section) == 0 {
            // Remove empty section
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if collectionView.numberOfItems(inSection: section) == 0 {
            // Remove header of empty section
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
