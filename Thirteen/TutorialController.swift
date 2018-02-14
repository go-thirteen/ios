//
//  TutorialController.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 2/10/18.
//  Copyright © 2018 Wilhelm Thieme. All rights reserved.
//

import UIKit
import FLAnimatedImage

class TutorialController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    private let one = detailController()
    private let two = detailController()
    private let three = detailController()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    let pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
        one.num = 1
        two.num = 2
        three.num = 3
        
        self.title = "Thirteen!"
        
        self.navigationController?.navigationBar.tintColor = Colors.tint
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(gotIt))
        
        pageControl.frame = CGRect(x: 0, y: view.frame.height*0.9, width: view.frame.width, height: view.frame.height*0.1)
        pageControl.numberOfPages = 3
        
        self.view.addSubview(pageControl)

        self.delegate = self
        self.dataSource = self
        
        self.setViewControllers([one], direction: .forward, animated: true, completion: nil)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == one {
            return two
        } else if viewController == two {
            return three
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == two {
            return one
        } else if viewController == three {
            return two
        }
        return nil
    }
    
    var oneOpened = true
    var twoOpened = false
    var threeOpened = false
    var switched = false
    
    func updateBarButton() {
        if !switched {
            if oneOpened && twoOpened && threeOpened {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(gotIt))
                switched = true
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let first = pendingViewControllers.first {
            moveTo(page: first)
        }
    }
    
    func moveTo(page: UIViewController) {
        if page == one {
            pageControl.currentPage = 0
            oneOpened = true
        } else if page == two {
            pageControl.currentPage = 1
            twoOpened = true
        } else if page == three {
            pageControl.currentPage = 2
            threeOpened = true
        }
        updateBarButton()
    }
    
    @objc func gotIt() {
        UserDefaults.standard.set(true, forKey: Keys.openedBefore)
        self.dismiss(animated: true, completion: nil)
    }
    
    func prev() {
        if let thisViewController = self.viewControllers?.first, let viewController = pageViewController(self, viewControllerBefore: thisViewController) {
            moveTo(page: viewController)
            self.setViewControllers([viewController], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    func next() {
        if let thisViewController = self.viewControllers?.first, let viewController = pageViewController(self, viewControllerAfter: thisViewController) {
            moveTo(page: viewController)
            self.setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private class detailController: UIViewController {
        
        var num = 0 {
            didSet {
                loadDetails()
            }
        }
        
        var detailsLoaded = false
        func loadDetails() {
            guard !detailsLoaded else {
                return
            }
            
            if num == 1 {
                loadMov(num: 1)
                textLabel.text = "Combinethe balls and get to thirteen."
                addRight()
            } else if num == 2 {
                loadMov(num: 2)
                textLabel.text = "Balls grow in size each time you combine them."
                addRight()
                addLeft()
            } else if num == 3 {
                loadMov(num: 3)
                textLabel.text = "Don't let the screen fill up or you'll lose."
                addLeft()
            }
            let size = textLabel.sizeThatFits(CGSize(width: view.frame.width*0.8, height: .greatestFiniteMagnitude))
            textLabel.frame.size = size
            let barHeight = self.navigationController?.navigationBar.frame.maxY ?? 44
            let square = frameImage.frame.minY - barHeight
            textLabel.center = CGPoint(x: view.frame.width*0.5, y: square*0.5 + barHeight)
            
            detailsLoaded = true
        }
        
        func loadMov(num: Int) {
            if let path = Bundle.main.path(forResource: "\(num)", ofType:"gif") {
                let url = URL(fileURLWithPath: path)
                let data = try? Data(contentsOf: url)
                movView.animatedImage = FLAnimatedImage(animatedGIFData: data)
            }
        }
        
        func addLeft() {
            self.view.addSubview(left)
        }
        
        func addRight() {
            self.view.addSubview(right)
        }
        
        let frameImage = UIImageView()
        let movView = FLAnimatedImageView()
        let left = UIButton()
        let right = UIButton()
        let textLabel = UILabel()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let buttonSize = #imageLiteral(resourceName: "ic_chevron_left").size
            let yBut = view.frame.height*0.7 - buttonSize.height
            
            left.setImage(#imageLiteral(resourceName: "ic_chevron_left").withRenderingMode(.alwaysTemplate), for: .normal)
            left.tintColor = Colors.tint
            left.frame = CGRect(origin: CGPoint(x: 0, y: yBut), size: buttonSize)
            left.addTarget(self, action: #selector(prevTab), for: .touchUpInside)
            
            right.setImage(#imageLiteral(resourceName: "ic_chevron_right").withRenderingMode(.alwaysTemplate), for: .normal)
            right.tintColor = Colors.tint
            right.frame = CGRect(origin: CGPoint(x: view.frame.width-buttonSize.width, y: yBut), size: buttonSize)
            right.addTarget(self, action: #selector(nextTab), for: .touchUpInside)
            
            guard let im = UIImage(named: "frame.png"), let otherim = UIImage(named: "1.gif") else {
                return
            }
            
            frameImage.image = im
            let aspect = im.size.height / im.size.width
            let newHeight = view.frame.height*0.8
            let newWidth = newHeight / aspect
            frameImage.frame.size = CGSize(width: newWidth, height: newHeight)
            frameImage.center = CGPoint(x: view.frame.width*0.5, y: view.frame.height*0.7)
            
            
            let movAspect = otherim.size.width / otherim.size.height
            let scaleRatio = im.size.width / 363
            let movWidth = newWidth / scaleRatio
            let movHeight = movWidth / movAspect
            let movX = (newWidth - movWidth) * 0.5
            let movY = (newHeight - movHeight) * 0.5
            movView.frame = CGRect(x: frameImage.frame.minX + movX, y: frameImage.frame.minY + movY, width: movWidth, height: movHeight)
            
            textLabel.numberOfLines = 0
            textLabel.font = UIFont.systemFont(ofSize: 24)
            textLabel.textAlignment = .center
            
            
            self.view.addSubview(textLabel)
            self.view.addSubview(movView)
            self.view.addSubview(frameImage)
            
        }
        
        @objc func prevTab() {
            if let par = self.parent as? TutorialController {
                par.prev()
            }
        }
        
        @objc func nextTab() {
            if let par = self.parent as? TutorialController {
                par.next()
            }
        }
    }
}
