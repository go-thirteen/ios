//
//  WebController.swift
//  Thirteen
//
//  Created by Wilhelm Thieme on 2/11/18.
//  Copyright © 2018 Wilhelm Thieme. All rights reserved.
//

import UIKit
import WebKit

class WebController: UIViewController, WKNavigationDelegate {
    
    var webView = WKWebView()
    
    var link: String = "" {
        didSet {
            if let url = URL(string: link) {
                webView.load(URLRequest(url: url))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        webView.frame = self.view.frame
        webView.navigationDelegate = self
        self.view.addSubview(webView)
    }

    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated, let urlString = navigationAction.request.url?.absoluteString, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

