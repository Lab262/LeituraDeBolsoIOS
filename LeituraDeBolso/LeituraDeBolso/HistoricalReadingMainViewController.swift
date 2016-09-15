//
//  HistoricalReadingMainViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 30/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit


protocol SegmentControlButtonDelegate {
    func segmentSelected(_ viewIndex: Int)
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
        
     //   self.configureNavitionBar()
        
        self.leftButtonItem = UIBarButtonItem(image: UIImage(named: "button_read"), style: .done, target: self, action: #selector(popoverView(_:)))
        
        self.rightButtonItem = UIBarButtonItem(image: UIImage(named:"button_search"), style: .done, target: self, action: #selector(searchReading(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureNavitionBar()
    }
    
    func configureNavitionBar () {
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.setImage(UIImage(named: "button_search"), for: .search, state: UIControlState())
        self.searchController.view.frame = CGRect(x: 0, y: 0, width: 10, height: 44)
        self.searchController.delegate = self
        searchController.definesPresentationContext = true
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.definesPresentationContext = true
        self.searchController.searchBar.placeholder = "Buscar"
        self.searchController.searchBar.setValue("Cancelarr", forKey: "_cancelButtonText")
        
        self.searchController.searchBar.tintColor = UIColor.colorWithHexString("1CDBAD")
        let searchField = self.searchController.searchBar.value(forKey: "searchField") as? UITextField
        
        searchField?.backgroundColor = UIColor.colorWithHexString("370653")
        searchField?.textColor = UIColor.readingBlueColor()
        searchField?.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Buscar", comment: ""), attributes: [NSForegroundColorAttributeName: UIColor.colorWithHexString("1CDBAD")])
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segmentVC = segue.destination as? HistoricalReadingSegmentViewController {
            self.segmentControlButtonDelegate = segmentVC
            segmentVC.segmentControlPageDelegate = self
        }

    }
    
    @IBAction func popoverView(_ sender: AnyObject) {
        
       self.navigationController?.popViewController(animated: true)
        
    }
    
    
    override func viewWillLayoutSubviews() {
        
        
    }
    
    @IBAction func searchReading(_ sender: AnyObject) {
        
        //self.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        let leftNavBarButton = UIBarButtonItem(customView: self.searchController.searchBar)
        
        //leftNavBarButton.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.navigationItem.rightBarButtonItem = nil
        
        self.searchController.isActive = true
        
        
    }
    

    @IBAction func showAllHistorical(_ sender: AnyObject? = nil) {
        setSelectionIndication(true, center: false, trailing: false)
        segmentControlButtonDelegate?.segmentSelected(0)
    }
    
    @IBAction func showFavoriteHistorical(_ sender: AnyObject? = nil) {
        setSelectionIndication(false, center: true, trailing: false)
        segmentControlButtonDelegate?.segmentSelected(1)
    }
    
    
    @IBAction func showUnreadHistorical(_ sender: AnyObject? = nil) {
        setSelectionIndication(false, center: false, trailing: true)
        segmentControlButtonDelegate?.segmentSelected(2)
    }
    
    func setSelectionIndication(_ leading: Bool, center:Bool, trailing: Bool) {
        self.allReadingsSelectionBarCenterConstraint.isActive = false
        self.likedReadingsSelectionBarCenterConstraint.isActive = false
        self.unreadSelectionBarCenterConstraint.isActive = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions(), animations: {
            self.allReadingsSelectionBarCenterConstraint.isActive = leading
            self.likedReadingsSelectionBarCenterConstraint.isActive = center
            self.unreadSelectionBarCenterConstraint.isActive = trailing
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }

}



extension HistoricalReadingMainViewController: SegmentControlPageDelegate {
    
    func segmentScrolled(_ viewIndex: Int) {
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
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        
    }
    
    
    func presentSearchController(_ searchController: UISearchController) {
        self.searchController.searchBar.becomeFirstResponder()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.navigationItem.leftBarButtonItem = self.leftButtonItem
        self.navigationItem.rightBarButtonItem = self.rightButtonItem
        
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        
        
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.navigationItem.leftBarButtonItem = self.leftButtonItem
        self.navigationItem.rightBarButtonItem = self.rightButtonItem
    }
}

