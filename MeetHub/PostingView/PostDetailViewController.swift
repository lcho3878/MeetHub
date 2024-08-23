//
//  PostDetailViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/23/24.
//

import UIKit

final class PostDetailViewController: BaseViewController {
    
    var post: Post?
    
    private let postDetailView = PostDetailView()
    
    override func loadView() {
        view = postDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let post {
            postDetailView.configureData(post)
        }
    }
}
