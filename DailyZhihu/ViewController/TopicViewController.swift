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

class TopicViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var topTitleButtonItem: UIBarButtonItem!
    
    var dataSource = [Any]()
    
    var topStoriesDataSource = [TopicTopModel]()
    
//    var currentOffset: CGFloat = 0.0
    
    var dateString: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstSettings()
        
        // Get the latest topic.
        fetchTopicList()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.setStatusBarStyle(.default, animated: true)
        UIView.animate(withDuration: 2, animations: {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // Initial settings
    func firstSettings() {
        
        tableView.refreshControl = UIRefreshControl()
        
        tableView.refreshControl?.addTarget(self, action: #selector(refreshTopicList(_:)), for: .valueChanged)
        
        // Automatic row height settings
        view.startActivityAnimation(view.center)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        dateString = formatter.string(from: Date.yesterday)
        
    }
    
    // Pull to refresh event.
    @objc func refreshTopicList(_ sender: Any) {
        fetchTopicList()
    }
    
    func fetchTopicList() {
            
        NetworkManager.shared.request(NetworkManager.shared.baseURL + "4/stories/latest", success: { (JSON) in
            let stories = JSON["stories"] as! NSArray
            let topStories = JSON["top_stories"] as! NSArray
            var sectionDataArray = [Any]()
            
            var tempStoriesArray = [TopicTopModel]()
            for element in topStories {
                let topModel = TopicTopModel.parseResponsedObject(from: element as? NSDictionary)
                tempStoriesArray.append(topModel!)
            }
            
            sectionDataArray.append(tempStoriesArray)
            
            var tempDataArray = [TopicTableModel]()
            for element in stories {
                let topicTableModel = TopicTableModel.parseResponsedObject(from: element as? NSDictionary)
                tempDataArray.append(topicTableModel!)
            }
            
            sectionDataArray.append(tempDataArray)
            self.dataSource = sectionDataArray
            
            self.topStoriesDataSource = tempStoriesArray
            self.tableView.refreshControl?.endRefreshing()
            self.view.stopActivityAnimation()
            self.tableView.reloadData()
        }, failure: { (error) in
            print("Request failed.")
            self.tableView.refreshControl?.endRefreshing()
            self.view.stopActivityAnimation()
            self.tableView.reloadData()
        })
        
        
        DispatchQueue.main.async {
            // self.refreshControl.beginRefreshing()
        }
        
    }
    
    func loadMoreData() {
        NetworkManager.shared.request(NetworkManager.shared.baseURL + "4/news/before/" + dateString!, success: { (JSON) in
            
            let stories = JSON["stories"] as! NSArray
            self.dateString = JSON["date"] as? String
            var tempDataArray = [TopicTableModel]()
            for element in stories {
                let topicTableModel = TopicTableModel.parseResponsedObject(from: element as? NSDictionary)
                tempDataArray.append(topicTableModel!)
            }
            self.dataSource.append(tempDataArray)
            
            self.tableView.tableFooterView?.isHidden = true
            self.tableView.reloadData()
            
        }, failure: { (error) in
            
            print("Request failed.")
            self.tableView.tableFooterView?.isHidden = true
            self.tableView.reloadData()
            
        })
    }
    
    func setupTopicCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicCell", for: indexPath)
        
        let view = cell.contentView.viewWithTag(100)
        view?.layer.shadowColor = UIColor.gray.cgColor
        view?.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view?.layer.shadowRadius = 8.0
        view?.layer.shadowOpacity = 0.7
        
        let innerView = cell.contentView.viewWithTag(101)
        innerView?.layer.cornerRadius = 10.0
        
        var data = [TopicTableModel]()
        data = self.dataSource[indexPath.section] as! [TopicTableModel]
        let content = data[indexPath.row] as TopicTableModel
        let imageView = cell.contentView.viewWithTag(102) as! UIImageView
        let titleLabel = cell.contentView.viewWithTag(103) as! UILabel
        let url = URL(string: content.imageURL!)
        imageView.kf.setImage(with: url)
        titleLabel.text = content.title
        
        return cell
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource extension
extension TopicViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var data = [TopicTableModel]()
        data = self.dataSource[indexPath.section] as! [TopicTableModel]
        let topicTableModel = data[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newsContentVC = storyboard.instantiateViewController(withIdentifier: "NewsContentViewController") as! NewsContentViewController
        newsContentVC.newsID = topicTableModel.id!
        self.navigationController?.pushViewController(newsContentVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 250
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 滚动到最后一个section的第一个元素时，加载更多数据
        if self.dataSource.count > 0 {
//            let lastSectionData: [TopicTableModel] = self.dataSource[indexPath.section] as! [TopicTableModel]
            if indexPath.section == self.dataSource.count && indexPath.row == 0 {
                let spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: 0, y: 0, width: screenW, height: 44)
                
                self.tableView.tableFooterView = spinner
                self.tableView.tableFooterView?.isHidden = false
                loadMoreData()
            }
        }
    }
    
    // MARK: UITableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return self.dataSource.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let topStoriesCell = tableView.dequeueReusableCell(withIdentifier: "TopStoriesCell") as! TopStoriesCell
            
            self.topStoriesDataSource = self.dataSource[0] as! [TopicTopModel]
            topStoriesCell.dataSource = topStoriesDataSource
            topStoriesCell.navigationController = self.navigationController
            
            topStoriesCell.collectionView.reloadData()
            
            return topStoriesCell
        }
        
        let topicCell = setupTopicCell(tableView, cellForRowAt: indexPath)
        
        return topicCell
    }
}

// MARK: UIScrollViewDelegate extension
//extension TopicViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > currentOffset && scrollView.contentOffset.y > 60 {
//            UIView.animate(withDuration: 2, animations: {
//
//                self.navigationController?.setNavigationBarHidden(true, animated: true)
//
//            }) { (isFinished) in
//
//            }
//        } else {
//            UIView.animate(withDuration: 2, animations: {
//                self.navigationController?.setNavigationBarHidden(false, animated: true)
//            }) { (isFinished) in
//
//            }
//        }
//    }
//
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        currentOffset = scrollView.contentOffset.y
//    }
//}

