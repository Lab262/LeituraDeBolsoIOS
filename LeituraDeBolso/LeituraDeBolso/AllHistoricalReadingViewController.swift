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
    
    var allReadings: [Reading] = DBManager.getAll()
    var selectedIndexPath: IndexPath?
    var isFilterArray: Bool = false
    var textSearch: String?
    var filteredReadings = Array<Reading>()
    
    override func viewWillAppear(_ animated: Bool) {
        
   
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
        
        self.registerNibs()
        self.configureTableView()
        self.registerObservers()

        // Do any additional setup after loading the view.
    }
    
    func registerObservers () {
        
        NotificationCenter.default.addObserver(self, selector: #selector(newFavoriteReading(_:)), name: NSNotification.Name(rawValue: KEY_NOTIFICATION_NEW_FAVORITE), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(filterReading(_:)), name: NSNotification.Name(rawValue: KEY_NOTIFICATION_FILTER_ALL_READINGS), object: nil)
    }
    
    
    
    func newFavoriteReading (_ notification: Notification) {
         self.tableView.reloadData()
    }
    
    func filterReading (_ notification: Notification) {
        
        let text = notification.object as! String
        self.textSearch = text
        self.isFilterArray = true
        self.filterContentForSearchText(searchText: text)
    }
    
    func filterContentForSearchText (searchText: String, scope: String = "All") {
        
        self.filteredReadings = (self.allReadings.filter { reading in
            
            return reading.title!.localizedCaseInsensitiveContains(searchText)
        })
        
        self.tableView.reloadData()
    }
    
    func generateHistoricalCellByArrayReading (readingArray: [Reading], cell: UITableViewCell, indexPath: IndexPath) {
        
        let cell = cell as! HistoricalReadingTableViewCell
        
        cell.reading = readingArray[indexPath.row]
        cell.likeButton.tag = indexPath.row
        
        if !ApplicationState.sharedInstance.favoriteReads.isEmpty {
            
            let readingFavorite = ApplicationState.sharedInstance.favoriteReads.filter() {
                $0.title!.localizedCaseInsensitiveContains(readingArray[indexPath.row].title!)
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
    }
    
    func generateHistoricalReadingCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoricalReadingTableViewCell.identifier, for: indexPath) as! HistoricalReadingTableViewCell
        
        if ApplicationState.sharedInstance.currentUser!.isModeNight {
            cell.viewLine.alpha = 0.3
        }
        
        if self.isFilterArray && textSearch != "" {
        
            self.generateHistoricalCellByArrayReading(readingArray: self.filteredReadings, cell: cell, indexPath: indexPath)
            
        } else {
            
            self.generateHistoricalCellByArrayReading(readingArray: self.allReadings, cell: cell, indexPath: indexPath)
        }

        return cell
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
        
        if ApplicationState.sharedInstance.currentUser!.isModeNight {
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
        
        if self.isFilterArray && self.textSearch != "" {
            return self.filteredReadings.count
        } else {
           return self.allReadings.count
        }
        
    }
}

extension AllHistoricalReadingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "goReadingView", sender: self)
        
    }
}


