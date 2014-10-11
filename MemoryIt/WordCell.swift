//
//  WordCell.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/12.
//  Copyright (c) 2014年 one. All rights reserved.
//

import UIKit

class WordCell: UICollectionViewCell {

    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var container: UIView!
    var paperFoldView: PaperFoldView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        paperFoldView = PaperFoldView(frame: bounds)
        paperFoldView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        addSubview(paperFoldView)
        paperFoldView.setCenterContentView(container)

        
        var wordFolds = NSBundle.mainBundle().loadNibNamed("WordFolds", owner: nil, options: nil)
        var leftFold: UIView = wordFolds[0] as UIView
        var rightFold: UIView = wordFolds[1] as UIView
        paperFoldView.setLeftFoldContentView(leftFold, foldCount: 1, pullFactor: 1.0)
        paperFoldView.setRightFoldContentView(rightFold, foldCount: 1, pullFactor: 1.0)
        
    }
//    override func layoutSubviews() {
//        contentView.frame = bounds
//        super.layoutSubviews()
//    }

}
