//
//  ProfileTabManViewController.swift
//  MeetHub
//
//  Created by 이찬호 on 8/30/24.
//

import UIKit
import Tabman
import Pageboy

final class ProfileTabManViewController: TabmanViewController {
    private enum Section: CaseIterable {
        case myPost
        case likedPost
        case recommendPost
        
        var sectionTitle: String {
            switch self {
            case .myPost:
                return "내가 쓴 게시글"
            case .likedPost:
                return "좋아요 한 게시글"
            case .recommendPost:
                return "추천한 게시글"
            }
        }
        
        var viewController: UIViewController {
            switch self {
            case .myPost:
                let vc = HomeViewController()
                vc.viewType = .myPost
                return vc
            case .likedPost:
                let vc = UIViewController()
                vc.view.backgroundColor = .red
                return vc
            case .recommendPost:
                let vc = UIViewController()
                vc.view.backgroundColor = .yellow
                return vc
            }
        }
    }
    
    private var sections = Section.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        addBar(bar, dataSource: self, at: .top)
    }
}

extension ProfileTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        sections.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return sections[index].viewController
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: any Tabman.TMBar, at index: Int) -> any Tabman.TMBarItemable {
        let item = TMBarItem(title: sections[index].sectionTitle)
        return item
    }
    
    
}
