//
//  AboutController.swift
//  Collegeweb
//
//  Created by Wilhelm Thieme on 11/17/17.
//  Copyright © 2017 Wilhelm Thieme. All rights reserved.
//

import UIKit

class AboutController : UIViewController {
    
    private let blur = UIVisualEffectView()
    private let back = UIButton()
    private let box = UIView()
    private let image = UIImageView()
    private let heading = UILabel()
    private let version = UILabel()
    private let acknowledgement = UILabel()
    private let copyright = UILabel()
    private let close = UIButton()
    
    let copyrightString = "Copyright © 2017 Wilhelm Johan Thieme Jr. All rights reserved."
    let acknowledgementsString = "By using this application you agree to the Terms & Conditions and the Privacy Policy"
    let versionString = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""
    let buildString =  Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? ""
    let appTitleString = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let padding: CGFloat = 17
        
        blur.effect = UIBlurEffect(style: .light)
        blur.frame = UIScreen.main.bounds
        
        back.frame = UIScreen.main.bounds
        back.addTarget(self, action: #selector(exit), for: .touchUpInside)
        
        var h: CGFloat = 300
        var w: CGFloat = 200
        box.frame = CGRect(x: UIScreen.main.bounds.midX-0.5*w, y: UIScreen.main.bounds.midY-0.5*h, width: w, height: h)
        box.layer.cornerRadius = 20
        box.backgroundColor = #colorLiteral(red: 0.862745098, green: 0.862745098, blue: 0.862745098, alpha: 1)
        
        w = 100
        h = 100
        image.image = #imageLiteral(resourceName: "Icon")
        image.layer.cornerRadius = 10
        image.frame = CGRect(x: box.frame.midX-0.5*w, y: box.frame.minY+padding, width: w, height: h)
        
        w = box.frame.width
        h = 25
        heading.text = appTitleString
        heading.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        heading.textAlignment = .center
        heading.frame = CGRect(x: box.frame.midX-0.5*w, y: image.frame.maxY+padding, width: w, height: h)
        
        h = 23
        version.text = "Version: \(versionString) (\(buildString))"
        version.font = UIFont(name: "HelveticaNeue", size: 16)
        version.textAlignment = .center
        version.frame = CGRect(x: box.frame.midX-0.5*w, y: heading.frame.maxY+padding, width: w, height: h)
        
        h = 40
        acknowledgement.text = acknowledgementsString
        acknowledgement.font = UIFont(name: "HelveticaNeue-Light", size: 10)
        acknowledgement.numberOfLines = 0
        acknowledgement.textAlignment = .center
        acknowledgement.frame = CGRect(x: box.frame.midX-0.5*w+5, y: version.frame.maxY+padding, width: w-10, height: h)
        
        h = 50
        copyright.text = copyrightString
        copyright.font = UIFont(name: "HelveticaNeue-Light", size: 8)
        copyright.textAlignment = .center
        copyright.numberOfLines = 0
        copyright.frame = CGRect(x: box.frame.midX-0.5*w+5, y: box.frame.maxY-h, width: w-10, height: h)
        
        w = 24
        h = 24
        close.setImage(#imageLiteral(resourceName: "ic_close"), for: .normal)
        close.addTarget(self, action: #selector(exit), for: .touchUpInside)
        close.frame = CGRect(x: box.frame.minX + 4, y: box.frame.minY + 4, width: w, height: h)
        
        self.view.addSubview(blur)
        self.view.addSubview(back)
        self.view.addSubview(box)
        self.view.addSubview(image)
        self.view.addSubview(heading)
        self.view.addSubview(version)
        self.view.addSubview(acknowledgement)
        self.view.addSubview(copyright)
        self.view.addSubview(close)
    }
    
    @objc func exit() {
        dismiss(animated: true)
    }
    
}

