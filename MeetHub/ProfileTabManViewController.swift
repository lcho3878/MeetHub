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
    private var viewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = HomeViewController()
        vc1.viewType = .myPost
        let vc2 = UIViewController()
        let vc3 = UIViewController()
        vc2.view.backgroundColor = .yellow
        vc3.view.backgroundColor = .blue
        
        viewControllers.append(vc1)
        viewControllers.append(vc2)
        viewControllers.append(vc3)
        
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        addBar(bar, dataSource: self, at: .top)
    }
}

extension ProfileTabManViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        viewControllers.count
    }
    
    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: any Tabman.TMBar, at index: Int) -> any Tabman.TMBarItemable {
        let item = TMBarItem(title: "아이템 \(index)")
        return item
    }
    
    
}
