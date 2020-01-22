//
//  SXPolicyController.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/16.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import WebKit

class SXPolicyController: UIViewController {
    private var webView : WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView.init(frame: self.view.bounds)
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(-SXBottomSafeAreaHeight)
        }
        webView.load(URLRequest(url: URL(string: "http://www.yutuwood.com/file/private.html")!))
    }
}
