//
//  AllHistoricalReadingViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 30/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class AllHistoricalReadingViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var allReadings = Array<Reading>()
    var leftButtonItem: UIBarButtonItem?
    var rightButtonItem: UIBarButtonItem?
    var selectedIndexPath: IndexPath?
    var searchController: UISearchController!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.registerNibs()
        
        let readingDay = Reading()
            
        readingDay.duration = "5 min"
        readingDay.title = "Harry Potter"
        
        readingDay.text = "The majestic Rocky Mountains are a major tourist location in the western United States. Visitors can participate in a quantity of activities, including hiking, skiing, snowboarding, mountain biking, & plenty of more. The Rockies are home to several campgrounds, ghost towns, gold prospecting sites, & national parks. a quantity of the biggest tourist attractions in the Rockies are Pike’s Peak & Royal Gorge. There are several world famous national parks in the Rockies, including Yellowstone, Rocky Mountain, Grand Teton, & Glacier.\n \nThe legendary Rocky Mountains stretch from old Mexico up through the United States & into Canada. The Rocky Mountains are over 3000 miles long, spanning parts of california, Colorado, Idaho, Montana, & Wyoming before continuing into Canada. Stories of early adventurers like Lewis & Clark exploring the Rocky Mountains are legendary."
        
        readingDay.author = "André Santana Tito Alves Augusto Morais"
        
        readingDay.emojis = ["\u{1F603}", "\u{1F603}", "\u{1F603}"]
        
        self.allReadings.append(readingDay)
        
    }
    
    
    func configureTableView () {
        
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.layoutIfNeeded()

        
    }
    
    func registerNibs () {
        
        self.tableView.register(UINib(nibName: "HistoricalReadingTableViewCell", bundle: nil), forCellReuseIdentifier: HistoricalReadingTableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        self.registerObserver()

        // Do any additional setup after loading the view.
    }
    
    func registerObserver () {
        
        NotificationCenter.default.addObserver(self, selector: #selector(newFavoriteReading(_:)), name: NSNotification.Name(rawValue: KEY_NOTIFICATION_NEW_FAVORITE), object: nil)
    }
    
    func newFavoriteReading (_ notification: Notification) {
         self.tableView.reloadData()
    }
    
    
    func generateHistoricalReadingCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoricalReadingTableViewCell.identifier, for: indexPath) as! HistoricalReadingTableViewCell
        
        cell.emojiOneLabel.text = self.allReadings[(indexPath as NSIndexPath).row].emojis![0]
        cell.emojiTwoLabel.text = self.allReadings[(indexPath as NSIndexPath).row].emojis![1]
        cell.emojiThreeLabel.text = self.allReadings[(indexPath as NSIndexPath).row].emojis![2]
        cell.reading = self.allReadings[(indexPath as NSIndexPath).row]
        cell.likeButton.tag = (indexPath as NSIndexPath).row
     
        if !ApplicationState.sharedInstance.favoriteReads.isEmpty {
            
            let readingFavorite = ApplicationState.sharedInstance.favoriteReads.filter() {
                
                $0.title!.localizedCaseInsensitiveContains(self.allReadings[indexPath.row].title!)
                
            }
           
            
            
            if !readingFavorite.isEmpty {
                cell.likeButton.isSelected = true
            } else {
                cell.likeButton.isSelected = false
            }
        
        } else {
            cell.likeButton.isSelected = false
        }

        cell.likeButton.addTarget(self, action: #selector(likeReader(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func showSearchBar() {
        
        self.searchController.searchBar.alpha = 0
        
        let leftNavBarButton = UIBarButtonItem(customView: self.searchController.searchBar)
        navigationItem.setLeftBarButton(leftNavBarButton, animated: true)
        navigationItem.setRightBarButton(nil, animated: true)
        UIView.animate(withDuration: 0.5, animations: {
            self.searchController.searchBar.alpha = 1
            }, completion: { finished in
                self.searchController.searchBar.becomeFirstResponder()
        })
    }
    
    func configureSearchBar () {
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.setImage(UIImage(named: "button_search"), for: .search, state: UIControlState())
        self.searchController.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        
        self.searchController.searchBar.placeholder = "Buscar"
        self.searchController.searchBar.setValue("Cancelarr", forKey: "_cancelButtonText")
        
        self.searchController.searchBar.tintColor = UIColor.colorWithHexString("1CDBAD")
        
        // self.searchController.searchBar.searchBarStyle = .minimal
        //   self.searchController.displaysSearchBarInNavigationBa‌​r = YES
        
        
        let searchField = self.searchController.searchBar.value(forKey: "searchField") as? UITextField
        
        
        searchField?.backgroundColor = UIColor.colorWithHexString("370653")
        searchField?.textColor = UIColor.readingBlueColor()
        searchField?.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Buscar", comment: ""), attributes: [NSForegroundColorAttributeName: UIColor.colorWithHexString("1CDBAD")])
        
        
    }

    
    func likeReader (_ sender: UIButton) {
        
        if sender.isSelected == true {
            
            ApplicationState.sharedInstance.favoriteReads.append(self.allReadings[sender.tag])
        } else {
           
            ApplicationState.sharedInstance.favoriteReads = ApplicationState.sharedInstance.favoriteReads.filter() {$0.title != self.allReadings[sender.tag].title}
            
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: KEY_NOTIFICATION_NEW_FAVORITE), object: nil)
        
    }


    override func viewDidLayoutSubviews() {
        
        if ApplicationState.sharedInstance.modeNight! {
            self.setNightMode()
        }
    }
    
    func setNightMode () {
        
        self.view.backgroundColor = UIColor.readingModeNightBackground()
        self.tableView.backgroundColor = UIColor.readingModeNightBackground()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goReadingView" {
            
            if let destinationViewController = segue.destination as? ReadingDayViewController {
                
                destinationViewController.readingDay = self.allReadings[(selectedIndexPath! as NSIndexPath).row]
                
            }
            
        }
        
    }

}

extension AllHistoricalReadingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return generateHistoricalReadingCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.allReadings.count
    }
}

extension AllHistoricalReadingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "goReadingView", sender: self)
        
    }
}

extension AllHistoricalReadingViewController: UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    
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


