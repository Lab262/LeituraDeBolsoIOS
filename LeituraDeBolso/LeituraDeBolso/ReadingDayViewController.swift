//
//  ReadingDayViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 29/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit

class ReadingDayViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var readingDay: Reading? = Reading()
    var arrayImages = Array<String>()
    
    
    override func viewWillLayoutSubviews() {
        
    
              
    }
    
    
    func configureTableView () {
        
        self.tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.layoutIfNeeded()
        
    }
    func setNightMode () {
        
        self.tableView.backgroundColor = UIColor.readingModeNightBackground()
        self.view.backgroundColor = UIColor.readingModeNightBackground()

        self.view.layoutIfNeeded()
        self.tableView.layoutIfNeeded()
    }
    
    func setNormalMode () {
        
        self.view.backgroundColor = UIColor.white
        self.tableView.backgroundColor = UIColor.white
        self.view.layoutIfNeeded()
        self.tableView.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if ApplicationState.sharedInstance.modeNight! {
            self.setNightMode()
        } else {
            self.setNormalMode()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.readingDay?.title == nil || self.readingDay?.title == "" {
            self.readingDay = ApplicationState.sharedInstance.allReadings[2]
            
            tableView.reloadData()
        }
        
        self.configureTableView()
        
        // Do any additional setup after loading the view.
    }
    
    func shareReading (_ sender: UIButton) {
        
        
    }
    
    func generateHeadingCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HeadingTableViewCell.identifier, for: indexPath) as! HeadingTableViewCell
        
        cell.reading = self.readingDay
        
        return cell
    }
    
    func generateContentCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as! ContentTableViewCell
        
        cell.reading = self.readingDay
        
        return cell
    }
    
    func generateButtonsCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ButtonsTableViewCell.identifier, for: indexPath) as! ButtonsTableViewCell
        
        cell.shareButton.addTarget(self, action: #selector(shareReading(_:)), for: .touchUpInside)
        
        cell.likeButton.addTarget(self, action: #selector(likeReader(_:)), for: .touchUpInside)
        
        if !ApplicationState.sharedInstance.favoriteReads.isEmpty {
            
            let readingFavorite = ApplicationState.sharedInstance.favoriteReads.filter() {
                $0.title!.localizedCaseInsensitiveContains(self.readingDay!.title!)
            }
            
            if !readingFavorite.isEmpty {
                cell.likeButton.isSelected = true
            } else {
                cell.likeButton.isSelected = false
            }
            
        } else {
            cell.likeButton.isSelected = false
        }
        
        return cell
    }
    
    func likeReader (_ sender: UIButton) {
     
        if sender.isSelected == true {
            ApplicationState.sharedInstance.favoriteReads.append(self.readingDay!)
        } else {
           
           ApplicationState.sharedInstance.favoriteReads = ApplicationState.sharedInstance.favoriteReads.filter() {$0.title != self.readingDay!.title}
        }
        
    }
}


extension ReadingDayViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (indexPath as NSIndexPath).row {
        case 0:
            return generateHeadingCell(tableView, indexPath: indexPath)
        case 1:
            return generateContentCell(tableView, indexPath: indexPath)
        case 2:
            return generateButtonsCell(tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.readingDay?.title == "" || self.readingDay?.title == nil {
            return 0
        } else {
            return 3
        }
      
    }
}
