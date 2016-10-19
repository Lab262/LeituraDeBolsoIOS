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
    
    var unreadReadings = [Reading]()
    
    var selectedIndexPath: IndexPath?
    
    var isFilterArray: Bool = false
    var textSearch: String?
    var filteredReadings = Array<Reading>()
    
    
    override func viewWillAppear(_ animated: Bool) {
        

    }
    
    func registerNibs () {
        
        self.tableView.register(UINib(nibName: "HistoricalReadingTableViewCell", bundle: nil), forCellReuseIdentifier: HistoricalReadingTableViewCell.identifier)
    }

    func getUnreadReads() {
        
        let allReadings: [Reading] = DBManager.getAll().reversed()
       
        if !allReadings.isEmpty {
            self.unreadReadings = allReadings.filter {
                !ApplicationState.sharedInstance.currentUser!.readingAlreadyRead(id: $0.id!)!

            }
            self.tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUnreadReads()
        self.registerNibs()
        self.configureTableView()
        self.registerObservers()
       
        // Do any additional setup after loading the view.
    }
    
    func registerObservers () {
        
        NotificationCenter.default.addObserver(self, selector: #selector(newFavoriteReading(_:)), name: NSNotification.Name(rawValue: KEY_NOTIFICATION_NEW_FAVORITE), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(filterReading(_:)), name: NSNotification.Name(rawValue: KEY_NOTIFICATION_FILTER_UNREAD_READINGS), object: nil)
    }
    
    func configureTableView () {
        
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.layoutIfNeeded()

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
        
        self.filteredReadings = (self.unreadReadings.filter { reading in
            
            return reading.title!.localizedCaseInsensitiveContains(searchText)
        })
        
        self.tableView.reloadData()
    }
    
    func generateHistoricalCellByArrayReading (readingArray: [Reading], cell: UITableViewCell, indexPath: IndexPath) {
        
        let cell = cell as! HistoricalReadingTableViewCell
        
        cell.reading = readingArray[indexPath.row]
        cell.likeButton.tag = indexPath.row
        
        
        cell.likeButton.isSelected = ApplicationState.sharedInstance.currentUser!.readingIsFavorite(id: unreadReadings[indexPath.row].id!)!
        
//        if !ApplicationState.sharedInstance.favoriteReads.isEmpty {
//            
//            let readingFavorite = ApplicationState.sharedInstance.favoriteReads.filter() {
//                $0.title!.localizedCaseInsensitiveContains(readingArray[indexPath.row].title!)
//            }
//            
//            if !readingFavorite.isEmpty {
//                cell.likeButton.isSelected = true
//            } else {
//                cell.likeButton.isSelected = false
//            }
//            
//        } else {
//            cell.likeButton.isSelected = false
//        }
        
        cell.likeButton.addTarget(self, action: #selector(likeReader(_:)), for: .touchUpInside)
        
        
    }

    
    func likeReader (_ sender: UIButton) {
        
        if sender.isSelected == true {
            
            ApplicationState.sharedInstance.currentUser?.setFavoriteReading(id: self.unreadReadings[sender.tag].id!, isFavorite: true)
            
            UserReadingRequest.updateUserReading(readingId: self.unreadReadings[sender.tag].id!, isFavorite: true, alreadyRead: true, completionHandler: { (success, msg) in
                
                if success {
                    
                    
                    print ("FAVORITOU :\(msg)")
                    
                } else {
                    print ("DEU ERRO NO FAVORITO: \(msg)")
                }
                
            })

        } else {
            
            ApplicationState.sharedInstance.currentUser?.setFavoriteReading(id: self.unreadReadings[sender.tag].id!, isFavorite: false)
            
            UserReadingRequest.updateUserReading(readingId: self.unreadReadings[sender.tag].id!, isFavorite: false, alreadyRead: nil, completionHandler: { (success, msg) in
                
                if success {
                    
                    print ("RETIROU FAVORITO :\(msg)")
                } else {
                    print ("DEU ERRO NO RETIRAR FAVORITAR: \(msg)")
                }
                
            })
            
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: KEY_NOTIFICATION_NEW_FAVORITE), object: nil)
        }
        
    }

    func generateHistoricalReadingCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoricalReadingTableViewCell.identifier, for: indexPath) as! HistoricalReadingTableViewCell
        
        
        if ApplicationState.sharedInstance.currentUser!.isModeNight {
            cell.viewLine.alpha = 0.3
        }
        
        if self.isFilterArray && textSearch != "" {
            
            self.generateHistoricalCellByArrayReading(readingArray: self.filteredReadings, cell: cell, indexPath: indexPath)
            
        } else {
            
            self.generateHistoricalCellByArrayReading(readingArray: self.unreadReadings, cell: cell, indexPath: indexPath)
        }
        
        return cell
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
                
                destinationViewController.readingDay = self.unreadReadings[selectedIndexPath!.row]
                destinationViewController.isReadingDay = false
            }
            
        }
    }
}

extension UnreadHistoricalReadingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return generateHistoricalReadingCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isFilterArray && self.textSearch != "" {
            return self.filteredReadings.count
        } else {
            return self.unreadReadings.count
        }
    }
}

extension UnreadHistoricalReadingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath
        self.performSegue(withIdentifier: "goReadingView", sender: self)
        
    }
}




