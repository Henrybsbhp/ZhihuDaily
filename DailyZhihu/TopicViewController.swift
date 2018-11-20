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

class TopicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var dataSource = [TopicTableModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 425
        tableView.rowHeight = UITableView.automaticDimension
        
        DispatchQueue.global().async {
            Alamofire.request("https://news-at.zhihu.com/api/3/stories/latest", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
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
                
                self.tableView.reloadData()
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
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

