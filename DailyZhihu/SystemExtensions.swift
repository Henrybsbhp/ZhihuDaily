//
//  SystemExtension.swift
//  DailyZhihu
//
//  Created by St.Jimmy on 2018/11/27.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import UIKit

let screenW: CGFloat = UIScreen.main.bounds.width
let screenH: CGFloat = UIScreen.main.bounds.height

extension Date {
    static var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date().noon)!
    }
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date().noon)!
    }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}

struct AssociatedKeys {
    static var loadingViewKey: String = "SJloadingViewKey"
}

extension UIView {
    
    // UIView extension, use it to present indicator animation for loading data.
    fileprivate var loadingView: SJLoadingView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.loadingViewKey) as? SJLoadingView
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.loadingViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Start UIView animation by using this function
    public func startActivityAnimation(_ position: CGPoint) {
        if let loadingView = self.loadingView {
            loadingView.removeFromSuperview()
        }
        
        self.loadingView = SJLoadingView()
        self.loadingView?.spinner.startAnimating()
        self.loadingView?.center = position
        addSubview(self.loadingView!)
        bringSubviewToFront(self.loadingView!)
    }
    
    /// Stop UIView animation by using this function
    public func stopActivityAnimation() {
        if let loadingView = self.loadingView {
            loadingView.spinner.stopAnimating()
            loadingView.isHidden = true
        }
    }
}

// Custom loading view.
class SJLoadingView: UIView {
    
    var spinner: UIActivityIndicatorView!
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        backgroundColor = .white
        
        spinner = UIActivityIndicatorView(style: .gray)
        spinner.center = center
        addSubview(spinner)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
