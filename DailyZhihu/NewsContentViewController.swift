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

class NewsContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var newsID = String()
    
    var newsModel: NewsContentModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        tableView.estimatedRowHeight = 350
        tableView.rowHeight = UITableView.automaticDimension
        
        fetchNewsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        if #available(11.0, *) {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
}
