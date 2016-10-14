//
//  FavoriteHistoricalReadingViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 30/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit


class FavoriteHistoricalReadingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var favoriteReads = [Reading]()
    var selectedIndexPath: IndexPath?
    var isFilterArray: Bool = false
    var textSearch: String?
    var filteredReadings = Array<Reading>()
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    func registerObservers () {
        
        NotificationCenter.default.addObserver(self, selector: #selector(newReading(_:)), name: NSNotification.Name(rawValue: KEY_NOTIFICATION_NEW_FAVORITE), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(filterReading(_:)), name: NSNotification.Name(rawValue:KEY_NOTIFICATION_FILTER_FAVORITE_READINGS), object: nil)
    }
    
    func filterReading (_ notification: Notification) {
        
        let text = notification.object as! String
        self.textSearch = text
        self.isFilterArray = true
        self.filterContentForSearchText(searchText: text)
    }
    
    func filterContentForSearchText (searchText: String, scope: String = "All") {
        
        self.filteredReadings = (self.favoriteReads.filter { reading in
            
            return reading.title!.localizedCaseInsensitiveContains(searchText)
        })
        
        self.tableView.reloadData()
    }
    
    func generateHistoricalCellByArrayReading (readingArray: [Reading], cell: UITableViewCell, indexPath: IndexPath) {
        
        let cell = cell as! HistoricalReadingTableViewCell
        
        cell.reading = readingArray[indexPath.row]
        cell.likeButton.tag = indexPath.row
        
        cell.likeButton.isSelected = true
        
        cell.likeButton.addTarget(self, action: #selector(likeReader(_:)), for: .touchUpInside)
        
        
    }

    
    func registerNibs () {
        
        self.tableView.register(UINib(nibName: "HistoricalReadingTableViewCell", bundle: nil), forCellReuseIdentifier: HistoricalReadingTableViewCell.identifier)
        
    }
    
    func configureTableView () {
        
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.layoutIfNeeded()
        
    }
    
    func getFavoriteReads() {
        
        let allReadings: [Reading] = DBManager.getAll()
        
        if !allReadings.isEmpty {
            self.favoriteReads = allReadings.filter {
                ApplicationState.sharedInstance.currentUser!.readingIsFavorite(id: $0.id!)!
            }
            self.tableView.reloadData()
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getFavoriteReads()
        self.registerNibs()
        self.configureTableView()
        self.registerObservers()
        
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
    
    func newReading (_ notification: Notification) {
        self.getFavoriteReads()
    }
    
    func likeReader (_ sender: UIButton) {
    
        
        ApplicationState.sharedInstance.currentUser?.setFavoriteReading(id: self.favoriteReads[sender.tag].id!, isFavorite: false)
        
        UserReadingRequest.updateUserReading(readingId: self.favoriteReads[sender.tag].id!, isFavorite: false, alreadyRead: nil, completionHandler: { (success, msg) in
            
            if success {
                
                print ("RETIROU FAVORITO :\(msg)")
            } else {
                print ("DEU ERRO NO RETIRAR FAVORITAR: \(msg)")
            }
            
        })
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: KEY_NOTIFICATION_NEW_FAVORITE), object: nil)
        
    }

    
    func generateHistoricalReadingCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoricalReadingTableViewCell.identifier, for: indexPath) as! HistoricalReadingTableViewCell
        
        
        if ApplicationState.sharedInstance.currentUser!.isModeNight {
            cell.viewLine.alpha = 0.3
        }
        
        if self.isFilterArray && textSearch != "" {
            
            self.generateHistoricalCellByArrayReading(readingArray: self.filteredReadings, cell: cell, indexPath: indexPath)
            
        } else {
            
            self.generateHistoricalCellByArrayReading(readingArray: self.favoriteReads, cell: cell, indexPath: indexPath)
        }

        
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
        
        if self.isFilterArray && self.textSearch != "" {
            return self.filteredReadings.count
        } else {
            return self.favoriteReads.count
        }
    }
}

extension FavoriteHistoricalReadingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "goReadingView", sender: self)
        
    }
}

