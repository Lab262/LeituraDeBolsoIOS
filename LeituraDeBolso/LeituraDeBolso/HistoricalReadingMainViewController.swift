//
//  HistoricalReadingMainViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 30/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit


protocol SegmentControlButtonDelegate {
    func segmentSelected(viewIndex: Int)
}

class HistoricalReadingMainViewController: UIViewController {
    
    
    
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    
    var searchController: UISearchController!
    var segmentControlButtonDelegate: SegmentControlButtonDelegate?

    @IBOutlet weak var allReadingsSelectionBarCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var likedReadingsSelectionBarCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var unreadSelectionBarCenterConstraint: NSLayoutConstraint!

    var leftButtonItem: UIBarButtonItem?
    var rightButtonItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.delegate = self
        searchController.definesPresentationContext = true
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.definesPresentationContext = true
        self.searchController.searchBar.placeholder = "Buscar"
        self.searchController.searchBar.setValue("Cancelar", forKey: "_cancelButtonText")
        
        self.leftButtonItem = UIBarButtonItem(image: UIImage(named: "button_read"), style: .Done, target: self, action: #selector(popoverView(_:)))
        
        self.rightButtonItem = UIBarButtonItem(image: UIImage(named:"button_search"), style: .Done, target: self, action: #selector(searchReading(_:)))
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let segmentVC = segue.destinationViewController as? HistoricalReadingSegmentViewController {
            self.segmentControlButtonDelegate = segmentVC
            segmentVC.segmentControlPageDelegate = self
        }

    }
    
    @IBAction func popoverView(sender: AnyObject) {
        
       self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    
    @IBAction func searchReading(sender: AnyObject) {
        
        let leftNavBarButton = UIBarButtonItem(customView: self.searchController.searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.navigationItem.rightBarButtonItem = nil
        self.searchController.active = true
        
        
    }
    

    @IBAction func showAllHistorical(sender: AnyObject? = nil) {
        setSelectionIndication(true, center: false, trailing: false)
        segmentControlButtonDelegate?.segmentSelected(0)
    }
    
    @IBAction func showFavoriteHistorical(sender: AnyObject? = nil) {
        setSelectionIndication(false, center: true, trailing: false)
        segmentControlButtonDelegate?.segmentSelected(1)
    }
    
    
    @IBAction func showUnreadHistorical(sender: AnyObject? = nil) {
        setSelectionIndication(false, center: false, trailing: true)
        segmentControlButtonDelegate?.segmentSelected(2)
    }
    
    func setSelectionIndication(leading: Bool, center:Bool, trailing: Bool) {
        self.allReadingsSelectionBarCenterConstraint.active = false
        self.likedReadingsSelectionBarCenterConstraint.active = false
        self.unreadSelectionBarCenterConstraint.active = false
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: {
            self.allReadingsSelectionBarCenterConstraint.active = leading
            self.likedReadingsSelectionBarCenterConstraint.active = center
            self.unreadSelectionBarCenterConstraint.active = trailing
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }

    
}


extension HistoricalReadingMainViewController: SegmentControlPageDelegate {
    
    func segmentScrolled(viewIndex: Int) {
        switch viewIndex {
        case 0:
            showAllHistorical()
            break
        case 1:
            showFavoriteHistorical()
            break
        case 2:
            showUnreadHistorical()
            break
            
        default: break
        }
    }
    
}

extension HistoricalReadingMainViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        
    }
    
    func presentSearchController(searchController: UISearchController) {
        self.searchController.searchBar.becomeFirstResponder()
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        print ("Cancelou")
        
        self.navigationItem.leftBarButtonItem = self.leftButtonItem
        self.navigationItem.rightBarButtonItem = self.rightButtonItem
        
        self.viewDidAppear(true)
    }
}

