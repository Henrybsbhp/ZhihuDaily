//
//  SJWebView.swift
//  DailyZhihu
//
//  Created by kakyo on 2018/11/22.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import UIKit
import WebKit

class SJWebView: WKWebView {
    init() {
        // 设置内容自适应
        let js = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wkUserScript = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let config = WKWebViewConfiguration()
        let wkUControl = WKUserContentController()
        wkUControl.addUserScript(wkUserScript)
        config.userContentController = wkUControl
        super.init(frame: CGRect.zero, configuration: config)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
