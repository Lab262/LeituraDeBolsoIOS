//
//  HistoricalReadingSegmentViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 30/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

protocol SegmentControlPageDelegate {
    func segmentScrolled(viewIndex: Int)
}

class HistoricalReadingSegmentViewController: UIViewController {
    
    
    var previousPage: Int = 0
    var segmentControlPageDelegate : SegmentControlPageDelegate?

    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLayoutSubviews() {
        self.scrollView.delegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupPage(){
        
        let pageWidth: CGFloat = scrollView.frame.size.width
        let fractionalPage: CGFloat = scrollView.contentOffset.x / pageWidth
        let page: Int = lround(Double(fractionalPage))
        if previousPage != page {
            segmentControlPageDelegate?.segmentScrolled(page)
            previousPage = page
        }
    }

    
}


extension HistoricalReadingSegmentViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
}
