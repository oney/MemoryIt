//
//  WordCell.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/12.
//  Copyright (c) 2014年 one. All rights reserved.
//

import UIKit

protocol WordCellDelegate : NSObjectProtocol {
    func wordCellTap(cell: WordCell)
    func wordCellPaperPan(cell: WordCell, panGestureRecognizer: UIPanGestureRecognizer)
}

class WordCell: UICollectionViewCell, PaperFoldViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var container: UIView!
    var paperFoldView: PaperFoldView!
    var delegate: WordCellDelegate?
    var wordCellEntity: WordCellEntity = WordCellEntity()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
        
    }
    
    func configureView() {
        paperFoldView = PaperFoldView(frame: CGRectMake(0, 0, bounds.size.width, 40))
        paperFoldView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        addSubview(paperFoldView)
        paperFoldView.delegate = self
        container.frame = CGRectMake(0, 0, bounds.size.width, 40)
        paperFoldView.setCenterContentView(container)

//        paperFoldView.addConstraint(NSLayoutConstraint(item: container, attribute: .Left, relatedBy: .Equal, toItem: paperFoldView, attribute: .Left, multiplier: 1.0, constant: 0.0))
//        paperFoldView.addConstraint(NSLayoutConstraint(item: container, attribute: .Right, relatedBy: .Equal, toItem: paperFoldView, attribute: .Right, multiplier: 1.0, constant: 0.0))
        
        var t: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tap:"))
        t.delegate = self
        t.numberOfTapsRequired = 1
        container.addGestureRecognizer(t)
        
        var wordFolds = NSBundle.mainBundle().loadNibNamed("WordFolds", owner: nil, options: nil)
        var leftFold: UIView = wordFolds[0] as UIView
        var rightFold: UIView = wordFolds[1] as UIView
        var bottomFold: UIView = wordFolds[2] as UIView
        var topFold: UIView = wordFolds[3] as UIView
        
        paperFoldView.setLeftFoldContentView(leftFold, foldCount: 1, pullFactor: 1.0)
        paperFoldView.setRightFoldContentView(rightFold, foldCount: 1, pullFactor: 1.0)
        paperFoldView.enableHorizontalEdgeDragging = true
        
        bottomFold.frame = CGRectMake(0, 40, bounds.size.width, 60)
        addSubview(bottomFold)
    }
    
    func paperFoldView(paperFoldView: AnyObject!, didFoldAutomatically automated: Bool, toState paperFoldState: PaperFoldState) {
//        NSLog("didFoldAutomatically:%@", NSStringFromCGRect(paperFoldView.frame))
    }
    
    func paperFoldView(paperFoldView: AnyObject!, viewDidOffset offset: CGPoint) {
//        NSLog("viewDidOffset:%@", NSStringFromCGPoint(offset))
    }
    
    func paperFoldView(paperFoldView: AnyObject!, panGestureRecognizer: UIPanGestureRecognizer!) {
//        NSLog("panGestureRecognizer:%@", panGestureRecognizer)
        delegate?.wordCellPaperPan(self, panGestureRecognizer: panGestureRecognizer)
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        var contentViewIsAutoresized: Bool = CGSizeEqualToSize(self.frame.size, self.contentView.frame.size)
//        if !contentViewIsAutoresized {
//            var contentViewFrame: CGRect = self.contentView.frame
//            contentViewFrame.size = self.frame.size;
//            self.contentView.frame = contentViewFrame;
//        }
//    }
    
    func tap(sender: AnyObject!) {
        if paperFoldView.state != PaperFoldState.Default {
            return
        }
        wordCellEntity.bottomOpen = !wordCellEntity.bottomOpen
        self.delegate?.wordCellTap(self)
    }
}
