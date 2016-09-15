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
    
    var selectedIndexPath: IndexPath?
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    func registerObserver () {
        
        NotificationCenter.default.addObserver(self, selector: #selector(newReading(_:)), name: NSNotification.Name(rawValue: KEY_NOTIFICATION_NEW_FAVORITE), object: nil)
    }
    
    func registerNibs () {
        
        self.tableView.register(UINib(nibName: "HistoricalReadingTableViewCell", bundle: nil), forCellReuseIdentifier: HistoricalReadingTableViewCell.identifier)
        
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

    
    func newReading (_ notification: Notification) {
        self.favoriteReads = ApplicationState.sharedInstance.favoriteReads
        tableView.reloadData()
    
    }
    
    func likeReader (_ sender: UIButton) {
    
        ApplicationState.sharedInstance.favoriteReads = ApplicationState.sharedInstance.favoriteReads.filter() {$0.title != self.favoriteReads[sender.tag].title}
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: KEY_NOTIFICATION_NEW_FAVORITE), object: nil)
        
    }

    
    func generateHistoricalReadingCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoricalReadingTableViewCell.identifier, for: indexPath) as! HistoricalReadingTableViewCell
        
        cell.reading = self.favoriteReads[(indexPath as NSIndexPath).row]
        cell.likeButton.tag = (indexPath as NSIndexPath).row
        cell.emojiOneLabel.text = self.favoriteReads[(indexPath as NSIndexPath).row].emojis![0]
        cell.emojiTwoLabel.text = self.favoriteReads[(indexPath as NSIndexPath).row].emojis![1]
        cell.emojiThreeLabel.text = self.favoriteReads[(indexPath as NSIndexPath).row].emojis![2]
        cell.likeButton.isSelected = true
        cell.likeButton.addTarget(self, action: #selector(likeReader(_:)), for: .touchUpInside)
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goReadingView" {
            
            if let destinationViewController = segue.destination as? ReadingDayViewController {
                
                destinationViewController.readingDay = self.favoriteReads[(selectedIndexPath! as NSIndexPath).row]
                
            }
            
        }
        
    }
}


extension FavoriteHistoricalReadingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return generateHistoricalReadingCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.favoriteReads.isEmpty {
            return 0
        }
        return self.favoriteReads.count
    }
}

extension FavoriteHistoricalReadingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "goReadingView", sender: self)
        
    }
}

