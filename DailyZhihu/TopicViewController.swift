//
//  ViewController.swift
//  DailyZhihu
//
//  Created by St.Jimmy on 2018/11/10.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class TopicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    
    var dataSource = [TopicTableModel]()
    
    var currentOffset: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstSettings()
        
        // Get the latest topic.
        fetchTopicList()
        
    }
    
    // Initial settings
    func firstSettings() {
        self.navigationItem.title = "今日精选"
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshTopicList(_:)), for: .valueChanged)
        
        // Automatic row height settings
        tableView.estimatedRowHeight = 425
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // Pull to refresh event.
    @objc func refreshTopicList(_ sender: Any) {
        fetchTopicList()
    }
    
    func fetchTopicList() {
        DispatchQueue.global().async {
            Alamofire.request("https://news-at.zhihu.com/api/4/stories/latest", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                if response.error == nil {
                    print("Request success.")
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        let stories = JSON["stories"] as! NSArray
                        for element in stories {
                            let topicTableModel = TopicTableModel.parseResponsedObject(from: element as? NSDictionary)
                            self.dataSource.append(topicTableModel!)
                        }
                        
                    }
                } else {
                    print("Request failed.")
                }
                
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
            DispatchQueue.main.async {
                self.refreshControl.beginRefreshing()
            }
        }
    }

    // MARK: UIScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > currentOffset && scrollView.contentOffset.y > 60 {
            UIView.animate(withDuration: 2, animations: {
                
                self.navigationController?.setNavigationBarHidden(true, animated: true)
                
            }) { (isFinished) in
                
            }
        } else {
            UIView.animate(withDuration: 2, animations: {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }) { (isFinished) in
                
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        currentOffset = scrollView.contentOffset.y
    }
    
    
    // MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topicTableModel = self.dataSource[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newsContentVC = storyboard.instantiateViewController(withIdentifier: "NewsContentViewController") as! NewsContentViewController
        newsContentVC.newsID = topicTableModel.id
        self.navigationController?.pushViewController(newsContentVC, animated: true)
    }
    
    // MARK: UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath)
        
        let view = cell.contentView.viewWithTag(100)
        view?.layer.shadowColor = UIColor.gray.cgColor
        view?.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view?.layer.shadowRadius = 12.0
        view?.layer.shadowOpacity = 0.7
        
        let innerView = cell.contentView.viewWithTag(101)
        innerView?.layer.cornerRadius = 20.0
        
        let content = self.dataSource[indexPath.row] as TopicTableModel
        let imageView = cell.contentView.viewWithTag(102) as! UIImageView
        let titleLabel = cell.contentView.viewWithTag(103) as! UILabel
        let url = URL(string: content.imageURL)
        imageView.kf.setImage(with: url)
        titleLabel.text = content.title
        
        return cell
    }
}

