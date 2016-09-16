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
    var selectedIndexPath: IndexPath?
    var isFilterArray: Bool = false
    var textSearch: String?
    var filteredReadings = Array<Reading>()
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.registerNibs()
        
        let readingDay = Reading()
            
        readingDay.duration = "5 min"
        readingDay.title = "Harry Potter"
        
        readingDay.text = "The majestic Rocky Mountains are a major tourist location in the western United States. Visitors can participate in a quantity of activities, including hiking, skiing, snowboarding, mountain biking, & plenty of more. The Rockies are home to several campgrounds, ghost towns, gold prospecting sites, & national parks. a quantity of the biggest tourist attractions in the Rockies are Pike’s Peak & Royal Gorge. There are several world famous national parks in the Rockies, including Yellowstone, Rocky Mountain, Grand Teton, & Glacier.\n \nThe legendary Rocky Mountains stretch from old Mexico up through the United States & into Canada. The Rocky Mountains are over 3000 miles long, spanning parts of california, Colorado, Idaho, Montana, & Wyoming before continuing into Canada. Stories of early adventurers like Lewis & Clark exploring the Rocky Mountains are legendary."
        
        readingDay.author = "André Santana Tito Alves Augusto Morais"
        
        readingDay.emojis = ["\u{1F603}", "\u{1F603}", "\u{1F603}"]
        
        
        self.allReadings.append(readingDay)

        let readingDay2 = Reading()
        
        readingDay2.duration = "5 min"
        readingDay2.title = "Naruto"
        
        readingDay2.text = "NIIINJA"
        
        readingDay2.author = "KISHIMOTO"
        
        readingDay2.emojis = ["\u{1F603}", "\u{1F603}", "\u{1F603}"]

        
        self.allReadings.append(readingDay2)
        
        let readingDay3 = Reading()
        
        readingDay3.duration = "5 min"
        readingDay3.title = "Bleach"
        
        readingDay3.text = "SHINIGAMIS"
        
        readingDay3.author = "TITE KUBO"
        
        readingDay3.emojis = ["\u{1F603}", "\u{1F603}", "\u{1F603}"]
        
        
        self.allReadings.append(readingDay3)

        
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


