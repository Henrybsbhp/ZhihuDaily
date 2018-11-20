//
//  File.swift
//  DailyZhihu
//
//  Created by St.Jimmy on 2018/11/12.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import Foundation

struct TopicTableModel {
    
    var title = String() // 新闻标题
    var imageURL = String() //  图像地址（官方 API 使用数组形式。目前暂未有使用多张图片的情形出现，曾见无 images 属性的情况，请在使用中注意 ）
    var id = String() // url 与 share_url 中最后的数字（应为内容的 id）
    
    static func parseResponsedObject(from dic: NSDictionary?) -> TopicTableModel? {
        if (dic == nil) {
            return nil
        }
        
        var topicModel = TopicTableModel()
        let images = dic!["images"] as! NSArray
        let id = dic!["id"] as! NSInteger
        topicModel.title = dic!["title"] as! String
        topicModel.imageURL = images[0] as! String
        topicModel.id = String(id)
        
        return topicModel
    }
}
