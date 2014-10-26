//
//  PaperViewController.swift
//  MemoryIt
//
//  Created by SpoonRocket on 2014/10/26.
//  Copyright (c) 2014年 one. All rights reserved.
//

import UIKit

class PaperViewController: HAPaperCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var vc: UIViewController = nextViewControllerAtPoint(CGPointZero)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func nextViewControllerAtPoint(point: CGPoint) -> UICollectionViewController {
        var largeLayout: HACollectionViewLargeLayout = HACollectionViewLargeLayout()
        var nextCollectionViewController: HAPaperCollectionViewController = HAPaperCollectionViewController(collectionViewLayout: largeLayout)
        nextCollectionViewController.useLayoutToLayoutNavigationTransitions = true
        return nextCollectionViewController
    }
}
