//
//  FavoriteHistoricalReadingViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 30/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

let KEY_NOTIFICATION_NEW_FAVORITE = "NEW_READING_FAVORITE"

class FavoriteHistoricalReadingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var favoriteReads: [Reading] = ApplicationState.sharedInstance.favoriteReads
    
    var selectedIndexPath: NSIndexPath?
    
    
    override func viewWillAppear(animated: Bool) {
        
        
    }
    
    func registerObserver () {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(newReading(_:)), name: KEY_NOTIFICATION_NEW_FAVORITE, object: nil)
    }
    
    func registerNibs () {
        
        self.tableView.registerNib(UINib(nibName: "HistoricalReadingTableViewCell", bundle: nil), forCellReuseIdentifier: HistoricalReadingTableViewCell.identifier)
        
    }
    
    func configureTableView () {
        
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.layoutIfNeeded()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibs()
        self.configureTableView()
        self.registerObserver()
        
    }

    
    func newReading (notification: NSNotification) {
        self.favoriteReads = ApplicationState.sharedInstance.favoriteReads
        tableView.reloadData()    }
    
//    func reloadFavoriteReads () {
//        self.favoriteReads = ApplicationState.sharedInstance.favoriteReads
//        tableView.reloadData()
//    }
    
    func likeReader (sender: UIButton) {
    
        ApplicationState.sharedInstance.favoriteReads = ApplicationState.sharedInstance.favoriteReads.filter() {$0.title != self.favoriteReads[sender.tag].title}
        
        NSNotificationCenter.defaultCenter().postNotificationName(KEY_NOTIFICATION_NEW_FAVORITE, object: nil)
        
    }

    
    func generateHistoricalReadingCell (tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(HistoricalReadingTableViewCell.identifier, forIndexPath: indexPath) as! HistoricalReadingTableViewCell
        
        cell.reading = self.favoriteReads[indexPath.row]
        cell.tag = indexPath.row
        cell.likeButton.selected = true
        cell.likeButton.addTarget(self, action: #selector(likeReader(_:)), forControlEvents: .TouchUpInside)
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goReadingView" {
            
            if let destinationViewController = segue.destinationViewController as? ReadingDayViewController {
                
                destinationViewController.readingDay = self.favoriteReads[selectedIndexPath!.row]
                
            }
            
        }
        
    }
}


extension FavoriteHistoricalReadingViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return generateHistoricalReadingCell(tableView, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.favoriteReads.isEmpty {
            return 0
        }
        return self.favoriteReads.count
    }
}

extension FavoriteHistoricalReadingViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedIndexPath = indexPath
        self.performSegueWithIdentifier("goReadingView", sender: self)
        
    }
}

