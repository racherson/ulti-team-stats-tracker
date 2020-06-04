//
//  PlayGameViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol PlayGamePresenterProtocol where Self: Presenter {
    func startPoint()
    func numberOfPlayersInSection(_ section: Int) -> Int
    func getPlayerName(at indexPath: IndexPath) -> String
    func selectPlayer(at indexPath: IndexPath) -> IndexPath?
    func nextPoint(scored: Bool)
    func endGame()
}

class PlayGameViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: PlayGamePresenterProtocol!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var playPointButton: UIButton!
    
    private let itemsPerRow: CGFloat = 4
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        playPointButton.isHidden = true
        setUpCallLineButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    func updateView() {
        collectionView.reloadData()
    }
    
    func showCallLine() {
        collectionView.isHidden = false
        playPointButton.isHidden = true
        setUpCallLineButtons()
        navigationItem.title = Constants.Titles.callLineTitle
    }
    
    func showPlayPoint() {
        collectionView.isHidden = true
        playPointButton.isHidden = false
        removeBarButtons()
        navigationItem.title = Constants.Titles.pointTitle
    }
    
    //MARK: Private methods
    private func setUpCallLineButtons() {
        // Add start button
        let button = UIBarButtonItem(title: "Start", style: .done, target: self, action: #selector(self.startPointPressed))
        navigationItem.rightBarButtonItem  = button
        
        // Add start button
        let endGameButton = UIBarButtonItem(title: "End Game", style: .done, target: self, action: #selector(self.endGamePressed))
        navigationItem.leftBarButtonItem  = endGameButton
    }
    
    private func removeBarButtons() {
        navigationItem.rightBarButtonItem  = nil
        navigationItem.leftBarButtonItem  = nil
    }
    
    //MARK: Actions
    @objc func startPointPressed() {
        presenter.startPoint()
    }
    
    @objc func endGamePressed() {
        presenter.endGame()
    }
    
    @IBAction func playPointPressed(_ sender: UIButton) {
        // TODO: Get if current point was scored by team or not
        let scored = true
        presenter.nextPoint(scored: scored)
    }
}

//MARK: UICollectionViewDataSource, UICollectionViewDelegate
extension PlayGameViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
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
        case Gender.women.rawValue + 1:
            cell.backgroundColor = .red
        case Gender.men.rawValue + 1:
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
            
            if let gender = Gender(rawValue: indexPath.section - 1)?.description {
                headerView.label.text = gender
            }
            else {
                headerView.label.text = Constants.Titles.lineTitle
            }
            
            return headerView
            
        default:
            fatalError("Invalid element type")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get location to move item
        if let newIndexPath = presenter.selectPlayer(at: indexPath) {
            collectionView.moveItem(at: indexPath, to: newIndexPath)
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
