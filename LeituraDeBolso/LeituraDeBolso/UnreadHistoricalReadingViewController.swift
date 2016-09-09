//
//  UnreadHistoricalReadingViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 30/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class UnreadHistoricalReadingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var allReadings = Array<Reading>()
    
    var selectedIndexPath: NSIndexPath?
    
    
    override func viewWillAppear(animated: Bool) {
        let readingDay = Reading()
        
        
        self.tableView.registerNib(UINib(nibName: "HistoricalReadingTableViewCell", bundle: nil), forCellReuseIdentifier: HistoricalReadingTableViewCell.identifier)
        
        readingDay.duration = "21 min"
        readingDay.title = "As Cronicas de Gelo e Fogo, A Fúria dos Reis, A Tormenta de Espadas"
        
        readingDay.text = "The majestic Rocky Mountains are a major tourist location in the western United States. Visitors can participate in a quantity of activities, including hiking, skiing, snowboarding, mountain biking, & plenty of more. The Rockies are home to several campgrounds, ghost towns, gold prospecting sites, & national parks. a quantity of the biggest tourist attractions in the Rockies are Pike’s Peak & Royal Gorge. There are several world famous national parks in the Rockies, including Yellowstone, Rocky Mountain, Grand Teton, & Glacier.\n \nThe legendary Rocky Mountains stretch from old Mexico up through the United States & into Canada. The Rocky Mountains are over 3000 miles long, spanning parts of california, Colorado, Idaho, Montana, & Wyoming before continuing into Canada. Stories of early adventurers like Lewis & Clark exploring the Rocky Mountains are legendary."
        
        readingDay.author = "DULCINO DE MORAIS VIEIRA COSTA SMADI"
        
        self.allReadings.append(readingDay)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.layoutIfNeeded()

        // Do any additional setup after loading the view.
    }

    func generateHistoricalReadingCell (tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(HistoricalReadingTableViewCell.identifier, forIndexPath: indexPath) as! HistoricalReadingTableViewCell
        
        cell.reading = self.allReadings[indexPath.row]
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goReadingView" {
            
            if let destinationViewController = segue.destinationViewController as? ReadingDayViewController {
                
                destinationViewController.readingDay = self.allReadings[selectedIndexPath!.row]
                
            }
            
        }
    }
}

extension UnreadHistoricalReadingViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return generateHistoricalReadingCell(tableView, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.allReadings.count
    }
}

extension UnreadHistoricalReadingViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedIndexPath = indexPath
        self.performSegueWithIdentifier("goReadingView", sender: self)
        
    }
}




