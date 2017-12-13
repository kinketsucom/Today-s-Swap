//
//  PageViewController.swift
//  Todays_Swap
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 sekibotbot. All rights reserved.
//
import UIKit

class PageViewController: UIPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([getFirst()], direction: .forward, animated: true, completion: nil)
        self.dataSource = self //追加
    }
    
    func getFirst() -> ViewController {
        return storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    }
    func getSecond() -> SwapCalendarViewController {
        return storyboard!.instantiateViewController(withIdentifier: "SwapCalendar") as! SwapCalendarViewController
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


extension PageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        if viewController.isKind(of: SwapCalendarViewController.self) {
            // 2 -> 1
            return getFirst()
        }else{
            // 1 -> end of the road
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: ViewController.self) {
            // 1 -> 2
            return getSecond()
        }else{
            // 2 -> end of the road
            return nil
        }
    }
}
