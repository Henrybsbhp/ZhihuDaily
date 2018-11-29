//
//  File.swift
//  DailyZhihu
//
//  Created by St.Jimmy on 2018/11/12.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import Foundation

struct TopicTableModel {
    
    var title: String? // 新闻标题
    var imageURL: String? //  图像地址（官方 API 使用数组形式。目前暂未有使用多张图片的情形出现，曾见无 images 属性的情况，请在使用中注意 ）
    var id: String? // url 与 share_url 中最后的数字（应为内容的 id）
    
    static func parseResponsedObject(from dic: NSDictionary?) -> TopicTableModel? {
        if (dic == nil) {
            return nil
        }
        
        var topicModel = TopicTableModel()
        let images = dic?["images"] as! NSArray
        let id = dic?["id"] as! NSInteger
        topicModel.title = dic?["title"] as? String
        topicModel.imageURL = images[0] as? String
        topicModel.id = String(id)
        
        return topicModel
    }
}

struct TopicTopModel {
    
    var title: String?
    var image: String?
    var id: String?
    
    static func parseResponsedObject(from dic: NSDictionary?) -> TopicTopModel? {
        if dic == nil {
            return nil
        }
        
        var topModel = TopicTopModel()
        let id = dic?["id"] as! NSInteger
        topModel.title = dic?["title"] as? String
        topModel.image = dic?["image"] as? String
        topModel.id = String(id)
        
        return topModel
    }
}

struct NewsContentModel {
    
    var title: String? // 新闻标题
    var imageURL: String? //  获得的图片同 最新消息 获得的图片分辨率不同。这里获得的是在文章浏览界面中使用的大图。
    var imageSource: String? //  图片的内容提供方。为了避免被起诉非法使用图片，在显示图片时最好附上其版权信息。
    var body: String? // HTML 格式的新闻
    var css: [String]?// 供手机端的 WebView(UIWebView) 使用
    
    static func parseResponsedObject(from dic: NSDictionary?) -> NewsContentModel? {
        if (dic == nil) {
            return nil
        }
        
        var newsContentModel = NewsContentModel()
        newsContentModel.title = dic?["title"] as? String
        newsContentModel.imageURL = dic?["image"] as? String
        newsContentModel.imageSource = dic?["image_source"] as? String
        newsContentModel.css =  dic?["css"] as? [String]
        newsContentModel.body = dic?["body"] as? String
        
        return newsContentModel
    }
}
