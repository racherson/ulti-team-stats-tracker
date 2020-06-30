//
//  CallLineViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 5/17/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol CallLinePresenterProtocol where Self: Presenter {
    func startPoint()
    func selectPlayer(at indexPath: IndexPath) -> IndexPath?
    func endGame()
}

class CallLineViewController: UIViewController, Storyboarded {
    
    //MARK: Properties
    var presenter: CallLinePresenterProtocol!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let itemsPerRow: CGFloat = 4
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        setUpButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.onViewWillAppear()
    }
    
    func updateWithViewModel(vm: CallLineCellViewModelProtocol) {
        if collectionView != nil {
            collectionView.dataSource = vm
        }
        updateView()
    }

    func updateView() {
        if collectionView != nil {
            collectionView.reloadData()
        }
    }
    
    //MARK: Private methods
    private func setUpButtons() {
        // Add start button
        let button = UIBarButtonItem(title: "Start", style: .done, target: self, action: #selector(self.startPointPressed))
        navigationItem.rightBarButtonItem  = button
        
        // Add end game button
        let endGameButton = UIBarButtonItem(title: "End Game", style: .done, target: self, action: #selector(self.endGamePressed))
        navigationItem.leftBarButtonItem  = endGameButton
    }
    
    //MARK: Actions
    @objc func startPointPressed() {
        presenter.startPoint()
    }
    
    @objc func endGamePressed() {
        presenter.endGame()
    }
}

//MARK: UICollectionViewDelegate
extension CallLineViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Get location to move item
        if let newIndexPath = presenter.selectPlayer(at: indexPath) {
            collectionView.moveItem(at: indexPath, to: newIndexPath)
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CallLineViewController : UICollectionViewDelegateFlowLayout {
    
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
