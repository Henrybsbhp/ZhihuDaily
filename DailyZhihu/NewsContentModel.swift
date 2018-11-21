//
//  NewsContentModel.swift
//  DailyZhihu
//
//  Created by kakyo on 2018/11/21.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import Foundation

struct NewsContentModel {
    
    var title = String() // 新闻标题
    var imageURL = String() //  获得的图片同 最新消息 获得的图片分辨率不同。这里获得的是在文章浏览界面中使用的大图。
    var imageSource = String() //  图片的内容提供方。为了避免被起诉非法使用图片，在显示图片时最好附上其版权信息。
    var body = String() // HTML 格式的新闻
    
    static func parseResponsedObject(from dic: NSDictionary?) -> NewsContentModel? {
        if (dic == nil) {
            return nil
        }
        
        var newsContentModel = NewsContentModel()
        newsContentModel.title = dic!["title"] as! String
        newsContentModel.imageURL = dic!["image"] as! String
        newsContentModel.imageSource = dic!["image_source"] as! String
        newsContentModel.body = dic!["body"] as! String
        
        return newsContentModel
    }
}
