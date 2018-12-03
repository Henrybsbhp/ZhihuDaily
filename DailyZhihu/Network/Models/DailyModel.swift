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
    
    init(title: String, imageURL: String, id: String) {
        self.title = title
        self.imageURL = imageURL
        self.id = id
    }
    
    init?(dictionary: [String: AnyObject]) {
        let images = dictionary["images"] as! NSArray
        let imageURL = images[0] as! String
        let title = dictionary["title"] as! String
        let idInt = dictionary["id"] as! NSInteger
        let id = String(idInt)
        
        self.init(title: title, imageURL: imageURL, id: id)
    }
    
    static func allTopicTableModels(from array: Array<Any>?) -> [TopicTableModel]? {
        
        guard let dicArray = array else {
            return nil
        }
        
        var models = [TopicTableModel]()
        for item in dicArray {
            if let model = TopicTableModel(dictionary: item as! [String : AnyObject]) {
                models.append(model)
            }
        }
        
        return models
    }
}

struct TopicTopModel {
    
    var title: String?
    var imageURL: String?
    var id: String?
    
    init(title: String, imageURL: String, id: String) {
        self.title = title
        self.imageURL = imageURL
        self.id = id
    }
    
    init?(dictionary: [String: AnyObject]) {
        let title = dictionary["title"] as! String
        let imageURL = dictionary["image"] as! String
        let idInt = dictionary["id"] as! NSInteger
        let id = String(idInt)
        
        self.init(title: title, imageURL: imageURL, id: id)
    }
    
    static func allTopicTopModels(from array: Array<Any>?) -> [TopicTopModel]? {
        guard let dicArray = array else {
            return nil
        }
        
        var models = [TopicTopModel]()
        for item in dicArray {
            if let model = TopicTopModel(dictionary: item as! [String: AnyObject]) {
                models.append(model)
            }
        }
        
        return models
    }
}

struct NewsContentModel {
    
    var title: String? // 新闻标题
    var imageURL: String? //  获得的图片同 最新消息 获得的图片分辨率不同。这里获得的是在文章浏览界面中使用的大图。
    var imageSource: String? //  图片的内容提供方。为了避免被起诉非法使用图片，在显示图片时最好附上其版权信息。
    var body: String? // HTML 格式的新闻
    var css: [String]?// 供手机端的 WebView(UIWebView) 使用
    
    init(title: String, imageURL: String, imageSource: String, body: String, css: [String]) {
        self.title = title
        self.imageURL = imageURL
        self.imageSource = imageSource
        self.body = body
        self.css = css
    }
    
    init() {
        self.init(title: "", imageURL: "", imageSource: "", body: "", css: [""])
    }
    
    init?(dictionary: [String: AnyObject]) {
        guard let title = dictionary["title"], let imageURL = dictionary["image"], let imageSource = dictionary["image_source"], let css = dictionary["css"], let body = dictionary["body"] else {
            return nil
        }
        
        self.init(title: title as! String, imageURL: imageURL as! String, imageSource: imageSource as! String, body: body as! String, css: css as! [String])
    }
}
