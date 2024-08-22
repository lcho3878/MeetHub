//
//  PostingViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/21/24.
//

import UIKit
import CoreLocation

final class PostingViewController: BaseViewController {
    
    private let postingView = PostingView()
    
    override func loadView() {
        view = postingView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PostingVC Load")
        postingView.collectionView.delegate = self
        postingView.collectionView.dataSource = self
        CLLocationManager().requestWhenInUseAuthorization()
    }
}

extension PostingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostingCollectionViewCell.id, for: indexPath) as? PostingCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
    
}
