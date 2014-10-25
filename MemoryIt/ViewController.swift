//
//  ViewController.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/10.
//  Copyright (c) 2014年 one. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, WordCellDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var datas: [WordCellEntity] = [WordCellEntity(),WordCellEntity(),WordCellEntity(),WordCellEntity(),WordCellEntity(),WordCellEntity(),WordCellEntity(),WordCellEntity(),WordCellEntity(),WordCellEntity(),WordCellEntity(),WordCellEntity(),WordCellEntity(),WordCellEntity(),WordCellEntity(),WordCellEntity(),WordCellEntity(),WordCellEntity(),WordCellEntity(),WordCellEntity()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.layer.shadowColor = UIColor.blackColor().CGColor
//        collectionView.layer.shadowOpacity = 0.5
//        collectionView.layer.shadowOffset = CGSizeMake(0, 0)
//        collectionView.layer.shouldRasterize = true
//        collectionView.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 28/255.0, green: 43/255.0, blue: 62/255.0, alpha: 1.0)
        collectionView.contentInset = UIEdgeInsetsMake(72, 0, 10, 0)
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
        cell.wordCellEntity = datas[indexPath.row]
//        cell.word.text = datas[indexPath.row] as NSString
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if datas[indexPath.row].bottomOpen {
            return CGSizeMake(collectionView.frame.size.width, 100)
        }
        return CGSizeMake(collectionView.frame.size.width, 40)
    }
    
    func wordCellTap(cell: WordCell) {
        NSLog("paperFoldView:%@", NSStringFromCGRect(cell.paperFoldView.frame))
        NSLog("container:%@", NSStringFromCGRect(cell.container.frame))
//        collectionView.collectionViewLayout.invalidateLayout()
//        var indexPath: NSIndexPath = collectionView.indexPathForCell(cell)!
//        wordSelectedArray.toggleSelect(indexPath.row)
        collectionView.performBatchUpdates({}, completion: { (Bool) in
//            cell.paperFoldView.frame = CGRectMake(0, 0, self.view.frame.size.width, 40)
        })
//        weak var weakCell: WordCell? = cell
//        UIView.transitionWithView(weakCell!, duration: 0.8, options: UIViewAnimationOptions.CurveLinear, animations: {
//            var newFrame: CGRect = weakCell!.frame
//            newFrame.size = CGSizeMake(newFrame.size.width, 100)
//            weakCell!.frame = newFrame
//            }, completion: nil)
    }
    
    func wordCellPaperPan(cell: WordCell, panGestureRecognizer: UIPanGestureRecognizer) {
        NSLog("wordCellPaperPan:%@", panGestureRecognizer)
        var isDragging = panGestureRecognizer.state == UIGestureRecognizerState.Ended || panGestureRecognizer.state == UIGestureRecognizerState.Cancelled
        println("isDragging:\(isDragging)")
        isDragging = !isDragging
        collectionView.scrollEnabled = !isDragging
    }
}

