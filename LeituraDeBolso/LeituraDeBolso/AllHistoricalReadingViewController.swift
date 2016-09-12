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
    
    var selectedIndexPath: NSIndexPath?
    
    override func viewWillAppear(animated: Bool) {
        
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
        
        self.tableView.registerNib(UINib(nibName: "HistoricalReadingTableViewCell", bundle: nil), forCellReuseIdentifier: HistoricalReadingTableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        self.registerObserver()

        // Do any additional setup after loading the view.
    }
    
    func registerObserver () {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(newFavoriteReading(_:)), name: KEY_NOTIFICATION_NEW_FAVORITE, object: nil)
    }
    
    func newFavoriteReading (notification: NSNotification) {
         self.tableView.reloadData()
    }
    
    
    func generateHistoricalReadingCell (tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(HistoricalReadingTableViewCell.identifier, forIndexPath: indexPath) as! HistoricalReadingTableViewCell
        
        cell.emojiOneLabel.text = self.allReadings[indexPath.row].emojis![0]
        cell.emojiTwoLabel.text = self.allReadings[indexPath.row].emojis![1]
        cell.emojiThreeLabel.text = self.allReadings[indexPath.row].emojis![2]
        cell.reading = self.allReadings[indexPath.row]
        cell.likeButton.tag = indexPath.row
        cell.likeButton.selected = false
        
        if !ApplicationState.sharedInstance.favoriteReads.isEmpty {
            let readingFavorite = self.allReadings.filter {
                ($0.title?.localizedCaseInsensitiveContainsString(ApplicationState.sharedInstance.favoriteReads[indexPath.row].title!))!
            }
            
            if !readingFavorite.isEmpty {
                cell.likeButton.selected = true
            }
        }

        cell.likeButton.addTarget(self, action: #selector(likeReader(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    func likeReader (sender: UIButton) {
        
        if sender.selected == true {
            
            ApplicationState.sharedInstance.favoriteReads.append(self.allReadings[sender.tag])
        } else {
            
            ApplicationState.sharedInstance.favoriteReads = ApplicationState.sharedInstance.favoriteReads.filter() {$0.title != self.allReadings[sender.tag]}
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(KEY_NOTIFICATION_NEW_FAVORITE, object: nil)
        
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goReadingView" {
            
            if let destinationViewController = segue.destinationViewController as? ReadingDayViewController {
                
                destinationViewController.readingDay = self.allReadings[selectedIndexPath!.row]
                
            }
            
        }
        
    }

}

extension AllHistoricalReadingViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return generateHistoricalReadingCell(tableView, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.allReadings.count
    }
}

extension AllHistoricalReadingViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedIndexPath = indexPath
        self.performSegueWithIdentifier("goReadingView", sender: self)
        
    }
}
