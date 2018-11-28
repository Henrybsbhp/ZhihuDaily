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

class NewsContentViewController: UIViewController, UIScrollViewDelegate {
    
    var backButton: UIButton!
    
    var newsID = String()
    
    var newsModel: NewsContentModel!
    
    var webView: SJWebView!
    
    var safeView: UIView!
    
    var currentOffset: CGFloat = 0.0
    
    var offset: CGFloat = 0.0
    
    
    deinit {
        print("NewsContentViewController is deinited.")
        webView.scrollView.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        webView = SJWebView()
        webView.frame = CGRect.init(x: 0, y: 0, width: screenW, height: screenH + 0)
        webView.scrollView.delegate = self
        
        view.addSubview(webView)
        
        setupSafeView()
        
        setupBackButton()
        
        fetchNewsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        
    }
    
    @objc func backButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupBackButton() {
        backButton = UIButton()
        backButton.frame = CGRect(x: 25, y: screenH - 80, width: 40, height: 40)
        backButton.backgroundColor = .white
        backButton.setImage(UIImage(named: "Image_Back"), for: .normal)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        backButton.layer.cornerRadius = 20
        backButton.layer.shadowColor = UIColor.gray.cgColor
        backButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        backButton.layer.shadowRadius = 8.0
        backButton.layer.shadowOpacity = 0.7
        backButton.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(backButton)
    }
    
    func setupSafeView() {
        safeView = UIView()
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                print("iPhone X, XS")
                safeView.frame = CGRect(x: 0, y: 0, width: screenW, height: 44)
            case 2688:
                print("iPhone XS Max")
                safeView.frame = CGRect(x: 0, y: 0, width: screenW, height: 44)
            case 1792:
                print("iPhone XR")
                safeView.frame = CGRect(x: 0, y: 0, width: screenW, height: 44)
            default:
                print("iPhone with no notch")
                safeView.frame = CGRect(x: 0, y: 0, width: screenW, height: 20)
            }
        }
        
        safeView.backgroundColor = .white
        
        view.addSubview(safeView)
    }
    
    func fetchNewsList() {
        
        NetworkManager.shared.request(NetworkManager.shared.baseURL + "4/news/" + self.newsID, success: { (JSON) in
            self.newsModel = NewsContentModel.parseResponsedObject(from: JSON)
            self.webView.contentModel = self.newsModel
            self.webView.load()
        }, failure: { (error) in
            print("Request failed.")
        })
        
    }
    
    // MARK: UIScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        self.offset = offset
        
        if let scaleView = webView.topImageView {
            if offset > -88 {
//                scaleView.top = -offset
                self.backButton.isHidden = false
            } else {
                let newHeight = abs(offset + 88) + 288
                scaleView.frame = CGRect(x: 0, y: offset, width: screenW, height: newHeight)
            }
        }
        
        if offset >= 200 {
            safeView.isHidden = false
            UIApplication.shared.setStatusBarStyle(.default, animated: true)
        } else {
            safeView.isHidden = true
            UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        }
        
        if offset < currentOffset || offset < 0 {
            self.backButton.isHidden = false
        } else {
            self.backButton.isHidden = true
        }
        
        // Detect whether the wenView reaches to the bottom
        webView.evaluateJavaScript("document.body.scrollHeight") { (result, error) in
            if let height = result as? CGFloat {
                if offset >= (height - scrollView.frame.size.height) {
                    self.backButton.isHidden = false
                }
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        currentOffset = scrollView.contentOffset.y
    }
    
}

extension NewsContentViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
