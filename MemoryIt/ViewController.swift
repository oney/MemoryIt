//
//  ViewController.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/10.
//  Copyright (c) 2014年 one. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, WordCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var datas: NSMutableArray = ["yoo", "kkk", "yoo", "kkk", "yoo", "kkk", "yoo", "kkk", "yoo", "kkk", "yoo", "kkk", "yoo", "kkk", "yoo", "kkk", "yoo", "kkk", "yoo", "kkk", "yoo", "kkk", "yoo", "kkk", "yoo", "kkk", "yoo", "kkk", "yoo", "kkk", "yoo", "kkk", ]
    var wordSelectedArray: WordSelectedArray = WordSelectedArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerNib(UINib(nibName: "WordCell", bundle: nil), forCellWithReuseIdentifier: "WordCell")
        collectionView.reloadData()
        NSLog("paperFoldView:%@", NSStringFromCGRect(self.view.frame))
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: WordCell = collectionView.dequeueReusableCellWithReuseIdentifier("WordCell", forIndexPath: indexPath) as WordCell
        cell.delegate = self
        cell.word.text = datas[indexPath.row] as NSString
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if wordSelectedArray.isSelected(indexPath.row) {
            return CGSizeMake(375, 100)
        }
        return CGSizeMake(375, 40)
    }
    
    func wordCellTap(cell: WordCell) {
        NSLog("paperFoldView:%@", NSStringFromCGRect(cell.paperFoldView.frame))
        NSLog("container:%@", NSStringFromCGRect(cell.container.frame))
//        collectionView.collectionViewLayout.invalidateLayout()
        var indexPath: NSIndexPath = collectionView.indexPathForCell(cell)!
        wordSelectedArray.toggleSelect(indexPath.row)
        collectionView.performBatchUpdates({}, completion: { (Bool) in
            cell.paperFoldView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40)
        })
//        weak var weakCell: WordCell? = cell
//        UIView.transitionWithView(weakCell!, duration: 0.8, options: UIViewAnimationOptions.CurveLinear, animations: {
//            var newFrame: CGRect = weakCell!.frame
//            newFrame.size = CGSizeMake(newFrame.size.width, 100)
//            weakCell!.frame = newFrame
//            }, completion: nil)
    }
}

