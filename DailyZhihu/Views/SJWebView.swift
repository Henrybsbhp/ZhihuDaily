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
    
    var contentModel = NewsContentModel()
    
    // MARK: - Views on webView
    var topImageView: UIImageView!
    var titleLabel: UILabel!
    var maskImageView: UIImageView!
    var imgSourceLabel: UILabel!
    
    init() {
        // 设置内容自适应
        let js = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let wkUserScript = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let config = WKWebViewConfiguration()
        let wkUControl = WKUserContentController()
        wkUControl.addUserScript(wkUserScript)
        config.userContentController = wkUControl
        super.init(frame: CGRect.zero, configuration: config)
        self.navigationDelegate = self
    }
    
    func setupUI() {
        topImageView = UIImageView()
        topImageView.contentMode = .scaleAspectFill
        topImageView.clipsToBounds = true
        topImageView.frame = CGRect.init(x: 0, y: -100, width: screenW, height: 300)
        maskImageView = UIImageView()
        maskImageView.image = UIImage(named: "Image_Mask")
        maskImageView.frame = CGRect(x: 0, y: 100, width: screenW, height: 100)
        titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = UIColor.white
        titleLabel.frame = CGRect.init(x: 15, y: 120, width: screenW - 30, height: 56)
        imgSourceLabel = UILabel()
        imgSourceLabel.font = UIFont.systemFont(ofSize: 10)
        imgSourceLabel.textAlignment = .right
        imgSourceLabel.textColor = UIColor.white
        imgSourceLabel.frame = CGRect.init(x: 15, y: 180, width: screenW - 30, height: 16)
        
        scrollView.addSubview(topImageView)
        scrollView.addSubview(maskImageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(imgSourceLabel)
    }
    
    func load() {
        guard let css = contentModel.css, let body = contentModel.body else {
            return
        }
        var html = "<html>"
        html += "<head>"
        css.forEach { html += "<link rel=\"stylesheet\" href=\($0)>" }
        html += "<style>img{max-width:320px !important;}</style>"
        html += "<body>"
        html += body
        html += "</body>"
        html += "</head>"
        html += "</html>"
        setupUI()
        topImageView.kf.setImage(with: URL(string: contentModel.imageURL!))
        titleLabel.text = contentModel.title
        imgSourceLabel.text = "图片：\(contentModel.imageSource!)"
        self.loadHTMLString(html, baseURL: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.startActivityAnimation(scrollView.center)
    }
}

extension SJWebView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        scrollView.startActivityAnimation(scrollView.center)
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        scrollView.stopActivityAnimation()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        scrollView.stopActivityAnimation()
    }
    

}
