//
//  TopStoriesCell.swift
//  DailyZhihu
//
//  Created by kakyo on 2018/11/26.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import UIKit

class TopStoriesCell: UITableViewCell {
    
    var dataSource = [TopicTopModel]()
    
    var navigationController: UINavigationController!
    
    var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView = self.contentView.viewWithTag(99) as? UICollectionView
    }
}

extension TopStoriesCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let topicTableModel = self.dataSource[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newsContentVC = storyboard.instantiateViewController(withIdentifier: "NewsContentViewController") as! NewsContentViewController
        newsContentVC.newsID = topicTableModel.id!
        navigationController?.pushViewController(newsContentVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoriesCell", for: indexPath)
        
        let containerView = cell.contentView.viewWithTag(100)
        containerView?.layer.shadowColor = UIColor.gray.cgColor
        containerView?.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        containerView?.layer.shadowRadius = 4.0
        containerView?.layer.shadowOpacity = 0.5
        
        let innerView = cell.contentView.viewWithTag(101)
        innerView?.layer.cornerRadius = 10.0
        
        let content = self.dataSource[indexPath.row] as TopicTopModel
        let imageView = cell.contentView.viewWithTag(102) as! UIImageView
        let titleLabel = cell.contentView.viewWithTag(103) as! UILabel
        imageView.kf.setImage(with: URL(string: content.image!))
        titleLabel.text = content.title
        
        return cell
    }
}

extension TopStoriesCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 319, height: 210)
    }
}
