//
//  SettingsController.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 2/11/18.
//  Copyright © 2018 Wilhelm Thieme. All rights reserved.
//

import UIKit
import StoreKit
import AcknowList

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    var tableView: UITableView!
    var spinner: UIActivityIndicatorView!
    
    struct Content {
        let title: String?
        let cells: [String]
        let type: ContentType
        
        init(title: String?, cells: [String], type: ContentType) {
            self.title = title
            self.cells = cells
            self.type = type
        }
        
        enum ContentType {
            case button
            case toggle
            case logo
        }
    }
    
    let sounds = "Sounds"
    let haptics = "Haptic Feedback"
    
    let removeAds = "Remove Ads"
    let restore = "Restore Purchases"
    
    let rateUs = "Rate Us"
    let about = "About"

    let privacyPolicy = "Privacy Policy"
    let terms = "Terms & Conditions"
    let licenses = "Open Source Attributions"
    
    var data: [Content] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = Colors.tint
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(closeModal))
        
        data = [
            Content(title: nil, cells: [sounds, haptics], type: .toggle),
            Content(title: nil, cells: [removeAds, restore], type: .button),
            Content(title: nil, cells: [rateUs, about], type: .button),
            Content(title: "Legal", cells: [privacyPolicy, terms, licenses], type: .button),
            Content(title: nil, cells: [""], type: .logo),
        ]
        
        tableView = UITableView(frame: self.view.frame, style: .grouped)
        tableView.separatorStyle = .none
        tableView.bounces = true
        tableView.backgroundColor = Colors.grayBack
        tableView.showsVerticalScrollIndicator = true
        tableView.delegate = self
        tableView.dataSource = self
        
        spinner = UIActivityIndicatorView(frame: self.view.frame)
        spinner.hidesWhenStopped = true
        spinner.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        spinner.activityIndicatorViewStyle = .gray
        
        self.view.addSubview(tableView)
        self.view.addSubview(spinner)
        
        self.title = "Settings"
        
        Purchases.shared().purchaseHandler = {[weak self] (type) in
            guard let strongSelf = self else {
                return
            }
            switch type {
            case .purchased, .restored:
                let alertView = UIAlertController(title: "Thank You!", message: type.message(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertView.addAction(action)
                strongSelf.present(alertView, animated: true, completion: nil)
            case .failed(let error):
                let alertView = UIAlertController(title: "Purchase Failed", message: error?.localizedDescription ?? "", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertView.addAction(action)
                strongSelf.present(alertView, animated: true, completion: nil)
            default:
                return
            }
            
            strongSelf.stopSpinner()
            
            strongSelf.tableView.reloadData()
        }
        
        Purchases.shared().productFetchedHandler = { [weak self] (product) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.tableView.reloadData()
        }
        
    }
    
    func startSpinner() {
        navigationItem.leftBarButtonItem?.isEnabled = false
        spinner.startAnimating()
    }
    
    func stopSpinner() {
        navigationItem.leftBarButtonItem?.isEnabled = true
        spinner.stopAnimating()
    }
    
    func parseProduct(_ product: SKProduct?) -> String? {
        guard let product = product else {
            return nil
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.formatterBehavior = .behavior10_4
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        return numberFormatter.string(from: product.price)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        if data[section].title != nil {
            return CGFloat(44)
        }
        return CGFloat(11)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return data[section].title
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        let cont = data[indexPath.section]
        
        if cont.type == .button {
            if cont.cells[indexPath.row] == restore {
                cell.textLabel?.frame.size = CGSize(width: self.view.frame.width, height: CGFloat(44))
                cell.textLabel?.textAlignment = .center
            } else if cont.cells[indexPath.row] == removeAds {
                cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                
                if let price = parseProduct(Purchases.shared().product) {
                    cell.detailTextLabel?.text = price
                } else {
                    Purchases.shared().fetchAvailableProducts()
                }
                
                if UserDefaults.standard.bool(forKey: Keys.adsDisabled) {
                    cell.textLabel?.text = "Already Purchased"
                }
            } else {
                cell.accessoryType = .disclosureIndicator
            }
        } else if cont.type == .toggle {
            let toggle = UISwitch()
            toggle.onTintColor = Colors.tint
            toggle.addTarget(self, action: #selector(toggleFlipped), for: .valueChanged)
            toggle.accessibilityLabel = cont.cells[indexPath.row]
            toggle.isOn = shouldBeOn(toggle)
            cell.accessoryView = toggle
        } else {
            cell.backgroundColor = Colors.grayBack
            let imgView = UIImageView(image: #imageLiteral(resourceName: "Icon"))
            imgView.frame.size = CGSize(width: CGFloat(44), height: CGFloat(44))
            imgView.center = CGPoint(x: self.view.frame.width*0.5, y: self.view.frame.width*0.02)
            let textView = UILabel()
            textView.text = "Version: \(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? "")"
            
            textView.font = UIFont.systemFont(ofSize: 16)
            textView.textColor = Colors.disabled
            textView.sizeToFit()
            textView.center = CGPoint(x: self.view.frame.width*0.5, y: imgView.frame.height*0.5+self.view.frame.width*0.05)
            cell.addSubview(textView)
            cell.addSubview(imgView)
        }
        
        cell.selectionStyle = .none
        cell.textLabel?.text = cont.cells[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard data[indexPath.section].type == .button else {
            return
        }
        
        let id = data[indexPath.section].cells[indexPath.row]
        
        switch id {
        case removeAds:
            if !UserDefaults.standard.bool(forKey: Keys.adsDisabled) {
                startSpinner()
                Purchases.shared().purchaseProduct()
            }
        case restore:
            if !UserDefaults.standard.bool(forKey: Keys.adsDisabled) {
                startSpinner()
                Purchases.shared().restorePurchase()
            }
        case rateUs:
            SKStoreReviewController.requestReview()
        case about:
            openAbout()
        case privacyPolicy:
            openPrivacyPolicy()
        case terms:
            openTerms()
        case licenses:
            openLicenses()
        default:
            fatalError("This should not be happening")
        }
    }
    
    func shouldBeOn(_ sender: UISwitch) -> Bool {
        if sender.accessibilityLabel == sounds {
            return !UserDefaults.standard.bool(forKey: Keys.muted)
        } else if sender.accessibilityLabel == haptics {
            return !UserDefaults.standard.bool(forKey: Keys.hapticDisabled)
        }
        return false
    }
    
    @objc func toggleFlipped(sender: UISwitch) {
        if sender.accessibilityLabel == sounds {
            UserDefaults.standard.set(!sender.isOn, forKey: Keys.muted)
        } else if sender.accessibilityLabel == haptics {
            UserDefaults.standard.set(!sender.isOn, forKey: Keys.hapticDisabled)
        }
    }
    
    func openAbout() {
        let about = AboutController()
        about.modalTransitionStyle = .crossDissolve
        about.modalPresentationStyle = .overCurrentContext
        self.present(about, animated: true, completion: nil)
    }
    
    func openPrivacyPolicy() {
        if let navi = self.navigationController {
            let privacy = WebController()
            privacy.title = "Privacy Policy"
            privacy.link = "http://wjthieme.com/thirteen/privacy"
            navi.pushViewController(privacy, animated: true)
        }
    }
    
    func openTerms() {
        if let navi = self.navigationController {
            let privacy = WebController()
            privacy.title = "Terms & Conditions"
            privacy.link = "http://wjthieme.com/thirteen/terms"
            navi.pushViewController(privacy, animated: true)
        }
    }
    
    func openLicenses() {
        if let navi = self.navigationController {
            let path = Bundle.main.path(forResource: "Pods-Thirteen-acknowledgements", ofType: "plist")
            let license = AcknowListViewController(acknowledgementsPlistPath: path)
            license.title = "Licenses"
            license.headerText = license.footerText
            license.footerText = "Copyright © 2017 Wilhelm Johan Thieme Jr. All rights reserved."
            license.acknowledgements?.append(Acknow(title: "Material.io", text: "Copyright 2017 Google", license: "Apache"))
            navi.pushViewController(license, animated: true)
        }
    }
    
    @objc func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

