//
//  NewsContentViewController.swift
//  DailyZhihu
//
//  Created by kakyo on 2018/11/21.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import WebKit

class NewsContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WKNavigationDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var newsID = String()
    
    var newsModel: NewsContentModel!
    
    var webViewHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = UITableView.automaticDimension
        
        fetchNewsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func fetchNewsList() {
        DispatchQueue.global().async {
            Alamofire.request("https://news-at.zhihu.com/api/4/news/" + self.newsID, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                if response.error == nil {
                    print("Request success.")
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        self.newsModel = NewsContentModel.parseResponsedObject(from: JSON)
                    }
                    
                } else {
                    print("Request failed.")
                    
                }
                
                self.tableView.reloadData()
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    fileprivate func loadHTML(model: NewsContentModel) -> String? {
        guard let css = model.css, let body = model.body else {
            return nil
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
        return html
    }

    
    // MARK: Settings of cells.
    func newsTitleTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
        let imageView = cell.contentView.viewWithTag(100) as! UIImageView
        let imageSourceLabel = cell.contentView.viewWithTag(101) as! UILabel
        let titleLabel = cell.contentView.viewWithTag(102) as! UILabel
        
        if let model = newsModel {
            let url = URL(string: model.imageURL)
            imageView.kf.setImage(with: url)
            titleLabel.text = model.title
            imageSourceLabel.text = "图片：" + model.imageSource
        }
        
        return cell
    }
    
    func newsContentTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath)
        let webView = SJWebView()
        cell.contentView.addSubview(webView)
        webView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: webViewHeight)
        webView.scrollView.isScrollEnabled = false
        webView.navigationDelegate = self as WKNavigationDelegate
        
        if let model = newsModel {
            webView.loadHTMLString(self.loadHTML(model: model)!, baseURL: nil)
        }
        
        return cell
    }
    
    // MARK: UITableView delegate.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 350
        }
        
        return webViewHeight
    }
    
    // MARK: UITableView dataSource.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let newsTitleCell = newsTitleTableViewCell(tableView, cellForRowAt: indexPath)
            
            return newsTitleCell
        }
        
        let newsContentCell = newsContentTableViewCell(tableView, cellForRowAt: indexPath)
        
        return newsContentCell
    }
    
    // MARK: The WKWebView's navigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if webView.isLoading == false {
            
            webView.evaluateJavaScript("document.body.scrollHeight") { (result, error) in
                if let height = result as? CGFloat {
                    self.webViewHeight = height
                    
                    self.tableView.reloadData()
                }
            }
            
        }
    }
}
