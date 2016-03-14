//
//  OverlayView.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import Foundation
import UIKit

enum GGOverlayViewMode {
    case GGOverlayViewModeLeft
    case GGOverlayViewModeRight
}

class OverlayView: UIView{
    var _mode: GGOverlayViewMode! = GGOverlayViewMode.GGOverlayViewModeLeft
    var imageView: UIImageView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView(image: UIImage(named: "dislikeButtonActive"))
        self.addSubview(imageView)
    }

    func setMode(mode: GGOverlayViewMode) -> Void {
        if _mode == mode {
            return
        }
        _mode = mode

        if _mode == GGOverlayViewMode.GGOverlayViewModeLeft {
            imageView.image = UIImage(named: "dislikeButtonActive")
        } else {
            imageView.image = UIImage(named: "likeButtonActive")
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}