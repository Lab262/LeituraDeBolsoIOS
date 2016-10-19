//
//  HistoricalReadingMainViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 30/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

let KEY_NOTIFICATION_NEW_FAVORITE = "NEW_READING_FAVORITE"
let KEY_NOTIFICATION_FILTER_ALL_READINGS = "FILTER_ALL_READINGS"
let KEY_NOTIFICATION_FILTER_FAVORITE_READINGS = "FILTER_FAVORITE_READINGS"
let KEY_NOTIFICATION_FILTER_UNREAD_READINGS = "FILTER_UNREAD_READINGS"

protocol SegmentControlButtonDelegate {
    func segmentSelected(_ viewIndex: Int)
}

class HistoricalReadingMainViewController: UIViewController {
    
    
    
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    @IBOutlet weak var favoriteReadingsButton: UIButton!
    
    @IBOutlet weak var unreadReadingsButton: UIButton!
    
    @IBOutlet weak var lineBottomView: UIView!
    
    
    var segmentSelected: Int?
    var viewSearch: UIView?
    var searchController: UISearchController!
    var segmentControlButtonDelegate: SegmentControlButtonDelegate?

    @IBOutlet weak var allReadingsSelectionBarCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var likedReadingsSelectionBarCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var unreadSelectionBarCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var allReadingsButton: UIButton!
    
    var filteredReadings = Array<Reading>()

    var leftButtonItem: UIBarButtonItem?
    var rightButtonItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.segmentSelected = 0
        
        self.leftButtonItem = UIBarButtonItem(image: UIImage(named: "button_read"), style: .done, target: self, action: #selector(popoverView(_:)))
        
        self.rightButtonItem = UIBarButtonItem(image: UIImage(named:"button_search"), style: .done, target: self, action: #selector(searchReading(_:)))
        
        
        self.allReadingsButton.setTitleColor(UIColor.colorWithHexString("EE5F66"), for: .normal)
        
        self.favoriteReadingsButton.setTitleColor(UIColor.colorWithHexString("9B9B9B"), for: .normal)
        
        self.unreadReadingsButton.setTitleColor(UIColor.colorWithHexString("9B9B9B"), for: .normal)
        
        self.segmentSelected = 0
        
        
    //self.allReadingsButton.setTitleColor(UIColor.colorWithHexString("EE5F66"), for: .normal)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureSearchBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        if self.searchController.isActive {
            self.searchController.isActive = false
            self.searchController.searchBar.resignFirstResponder()
        }
    }
    func configureSearchBar () {
        self.searchBarButton.isEnabled = false
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.setImage(UIImage(named: "button_search"), for: .search, state: UIControlState())
        self.searchController.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Buscar"
        self.searchController.searchBar.setValue("Cancelar", forKey: "_cancelButtonText")
        
        self.searchController.searchBar.setBackgroundImage(ViewUtil.imageFromColor(.clear, forSize: self.searchController.searchBar.frame.size, withCornerRadius: 0), for: .any, barMetrics: .default)
      
        
        self.searchController.searchBar.tintColor = UIColor.colorWithHexString("1CDBAD")
        
        searchController.hidesBottomBarWhenPushed = true
        let searchField = self.searchController.searchBar.value(forKey: "searchField") as? UITextField
        
    
        searchField?.backgroundColor = UIColor.colorWithHexString("370653")
        searchField?.textColor = UIColor.readingBlueColor()
        searchField?.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Buscar", comment: ""), attributes: [NSForegroundColorAttributeName: UIColor.colorWithHexString("1CDBAD")])
        searchBarButton.isEnabled = true
        
        
        
        self.viewSearch = UIView(frame: CGRect(x: self.searchController.searchBar.frame.origin.x, y: self.searchController.searchBar.frame.origin.y, width: self.searchController.searchBar.bounds.size.width-15, height: self.searchController.searchBar.bounds.size.height))
        
        
        self.viewSearch?.backgroundColor = UIColor.clear
        
        self.viewSearch?.addSubview(self.searchController.searchBar)
        
    }
    
    func filterContentForSearchText (searchText: String, scope: String = "All") {
        
        //  self.filteredReadings = filter() {$0.title != self.readingDay!.title}
        
        //self.filteredReadings = (self.filteredReadings.filter { reading in
            
          //  return ($.name?.localizedCaseInsensitiveContainsString(searchText))!
            
          //  })!
        
        //self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let segmentVC = segue.destination as? HistoricalReadingSegmentViewController {
            self.segmentControlButtonDelegate = segmentVC
            segmentVC.segmentControlPageDelegate = self
        }

    }
    
    @IBAction func popoverView(_ sender: AnyObject) {
        
       _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func showSearchBar() {
        
        self.searchController.isActive = true
        self.searchController.searchBar.alpha = 0
       
        
        let leftNavBarButton = UIBarButtonItem(customView: self.viewSearch!)
        navigationItem.setLeftBarButton(leftNavBarButton, animated: true)
    
        navigationItem.setRightBarButton(nil, animated: true)
        UIView.animate(withDuration: 0.2, animations: {
            self.searchController.searchBar.alpha = 1
            }, completion: { finished in
                self.searchController.searchBar.becomeFirstResponder()
        })
    }
    
    func hideSearchBar() {
        //navigationItem.setLeftBarButton(searchBarButton, animated: true)
  //      logoImageView.alpha = 0
        //UIView.animate(withDuration: 0.3, animations: {
           // self.navigationItem.titleView = self.logoImageView
            //self.logoImageView.alpha = 1
            //}, completion: { finished in
                
        //})
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillLayoutSubviews() {
        
        if ApplicationState.sharedInstance.currentUser!.isModeNight {
            self.setNightMode()
        }
        
    }
    
    @IBAction func searchReading(_ sender: AnyObject) {
        
        self.showSearchBar()
        //self.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0)
    //    let leftNavBarButton = UIBarButtonItem(customView: self.searchController.searchBar)
        
        //leftNavBarButton.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        
      //  self.navigationItem.leftBarButtonItem = leftNavBarButton
        //self.navigationItem.rightBarButtonItem = nil
        
       // self.searchController.isActive = true
        
        
    }
    
    func setNightMode () {
        
        self.lineBottomView.alpha = 0.3
        self.view.backgroundColor = UIColor.readingModeNightBackground()
        self.allReadingsButton.backgroundColor = UIColor.readingModeNightBackground()
        self.favoriteReadingsButton.backgroundColor = UIColor.readingModeNightBackground()
        self.unreadReadingsButton.backgroundColor = UIColor.readingModeNightBackground()
    }
    
    func setNormalMode (){
        
        self.lineBottomView.alpha = 1.0
        self.view.backgroundColor = UIColor.white
        
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
            
        self.allReadingsButton.setTitleColor(UIColor.colorWithHexString("EE5F66"), for: .normal)
            
            self.favoriteReadingsButton.setTitleColor(UIColor.colorWithHexString("9B9B9B"), for: .normal)
            
            self.unreadReadingsButton.setTitleColor(UIColor.colorWithHexString("9B9B9B"), for: .normal)
            self.segmentSelected = 0
//            self.allReadingsButton.isSelected = true
//            self.favoriteReadingsButton.isSelected = false
//            self.unreadReadingsButton.isSelected = false
            
            break
        case 1:
            showFavoriteHistorical()
            self.segmentSelected = 1
        
//            self.allReadingsButton.isSelected = false
//            self.favoriteReadingsButton.isSelected = true
//            self.unreadReadingsButton.isSelected = false
        self.allReadingsButton.setTitleColor(UIColor.colorWithHexString("9B9B9B"), for: .normal)
            
            self.favoriteReadingsButton.setTitleColor(UIColor.colorWithHexString("EE5F66"), for: .normal)
            
            self.unreadReadingsButton.setTitleColor(UIColor.colorWithHexString("9B9B9B"), for: .normal)
            break
        case 2:
            showUnreadHistorical()
            self.segmentSelected = 2
//            self.allReadingsButton.isSelected = false
//            self.favoriteReadingsButton.isSelected = false
//            self.unreadReadingsButton.isSelected = true
        self.allReadingsButton.setTitleColor(UIColor.colorWithHexString("9B9B9B"), for: .normal)
            
            self.favoriteReadingsButton.setTitleColor(UIColor.colorWithHexString("9B9B9B"), for: .normal)
           
            self.unreadReadingsButton.setTitleColor(UIColor.colorWithHexString("EE5F66"), for: .normal)
            
            break
            
        default: break
            
        }
    }
    
}

extension HistoricalReadingMainViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
    
        if segmentSelected == 0 {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: KEY_NOTIFICATION_FILTER_ALL_READINGS), object: searchController.searchBar.text, userInfo: nil)
            
        } else if segmentSelected == 1 {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: KEY_NOTIFICATION_FILTER_FAVORITE_READINGS), object: searchController.searchBar.text, userInfo: nil)
            
        } else {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: KEY_NOTIFICATION_FILTER_UNREAD_READINGS), object: searchController.searchBar.text, userInfo: nil)
        }
      
        
    }
    
    
    func presentSearchController(_ searchController: UISearchController) {
        self.searchController.searchBar.becomeFirstResponder()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.navigationItem.leftBarButtonItem = self.leftButtonItem
        self.navigationItem.rightBarButtonItem = self.rightButtonItem
        
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.searchController.searchBar.resignFirstResponder()
        
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.navigationItem.leftBarButtonItem = self.leftButtonItem
        self.navigationItem.rightBarButtonItem = self.rightButtonItem
    }
}

