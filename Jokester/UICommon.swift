//
//  UICommon.swift
//  LOL
//
//  Created by Taufiq Husain on 12/11/15.
//  Copyright © 2015 Polar Hills. All rights reserved.
//

import Foundation
import UIKit

func show_activity_indicator(view: UIView) -> UIActivityIndicatorView {
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    activityIndicator.center = view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
    view.addSubview(activityIndicator)
    activityIndicator.startAnimating()
    return activityIndicator
}

func show_light_activity_indicator(view: UIView) -> UIActivityIndicatorView {
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    activityIndicator.center = view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
    view.addSubview(activityIndicator)
    activityIndicator.startAnimating()
    return activityIndicator
}

func hide_activity_indicator(activityIndicator: UIActivityIndicatorView) {
    activityIndicator.stopAnimating();
}