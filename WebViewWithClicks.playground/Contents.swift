import UIKit

//
//  WKWebViewController.swift
//  Yocket
//
//  Created by Sujit Amin on 22/07/20.
//  Copyright © 2020 Avocation Educational Services. All rights reserved.
//

import UIKit
import WebKit
import MBProgressHUD

class WKWebViewController: UIViewController {
    var urls : String?
    var webView: WKWebView!
    //var activityIndicator: UIActivityIndicatorView!
    var progress : MBProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("WKWebViewController is loaded")
        
        //print("Number is \(url)")
        // Do any additional setup after loading the view.
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view = webView
        
        //loading view
        self.progress = MBProgressHUD.showAdded(to:self.view, animated: true)
        loading(show: true, message: "Loading", rootViewController: self, progress: progress)
        
        if urls != nil {
            let url = URL(string: urls!)!
            var urlRequest = URLRequest(url: url)
            if ( Network().getAuthorizationValue() != nil && Network().getAuthorizationKey() != nil ) {
                urlRequest.setValue(Network().getAuthorizationValue()! , forHTTPHeaderField: Network().getAuthorizationKey()!)
            }
            webView.load(urlRequest)
            webView.allowsBackForwardNavigationGestures = true
        }
        
    }
    
}
extension WKWebViewController : WKNavigationDelegate, WKUIDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loading(show: false, message: "Loading", rootViewController: self, progress: progress)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loading(show: false, message: "Loading", rootViewController: self, progress: progress)
    }
    
    // this handles target=_blank links by opening them in the same view
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}

