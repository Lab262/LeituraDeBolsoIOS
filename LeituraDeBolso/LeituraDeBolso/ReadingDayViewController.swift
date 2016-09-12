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
    
    override func viewWillAppear(animated: Bool) {
        
        if ApplicationState.sharedInstance.modeNight == true {
            self.setNightMode()
        } else {
            self.setNormalMode()
        }
        
    }
    
    func configureTableView () {
        
        self.tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.layoutIfNeeded()
        
    }
    func setNightMode () {
        
        self.view.backgroundColor = UIColor.colorWithHexString("190126")
        self.tableView.backgroundColor = UIColor.colorWithHexString("190126")
    }
    
    func setNormalMode () {
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.tableView.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        
        self.readingDay?.duration = "21 min"
        self.readingDay?.title = "As Cronicas de Gelo e Fogo, A Fúria dos Reis, A Tormenta de Espadas"
        
        self.arrayImages.append("\u{1F603}")
        self.arrayImages.append("\u{1F603}")
        self.arrayImages.append("\u{1F603}")
        
        self.readingDay?.emojis = self.arrayImages
        self.readingDay?.text = " <3   The majestic Rocky Mountains are a major tourist location in the western United States. Visitors can participate in a quantity of activities, including hiking, skiing, snowboarding, mountain biking, & plenty of more. The Rockies are home to several campgrounds, ghost towns, gold prospecting sites, & national parks. a quantity of the biggest tourist attractions in the Rockies are Pike’s Peak & Royal Gorge. There are several world famous national parks in the Rockies, including Yellowstone, Rocky Mountain, Grand Teton, & Glacier.\n \nThe legendary Rocky Mountains stretch from old Mexico up through the United States & into Canada. The Rocky Mountains are over 3000 miles long, spanning parts of california, Colorado, Idaho, Montana, & Wyoming before continuing into Canada. Stories of early adventurers like Lewis & Clark exploring the Rocky Mountains are legendary."
        
        self.readingDay?.author = "DULCINO DE MORAIS VIEIRA COSTA SMADI"
        
        self.tableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    func shareReading (sender: UIButton) {
        
        sender.selectedButtonWithImage()
        
        
        
        
    }
    
    func generateHeadingCell (tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(HeadingTableViewCell.identifier, forIndexPath: indexPath) as! HeadingTableViewCell
        
        cell.reading = self.readingDay
        
        return cell
    }
    
    func generateContentCell (tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ContentTableViewCell.identifier, forIndexPath: indexPath) as! ContentTableViewCell
        
        cell.reading = self.readingDay
        
        return cell
    }
    
    func generateButtonsCell (tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ButtonsTableViewCell.identifier, forIndexPath: indexPath) as! ButtonsTableViewCell
        
        cell.shareButton.addTarget(self, action: #selector(shareReading(_:)), forControlEvents: .TouchUpInside)
        
        cell.likeButton.addTarget(self, action: #selector(likeReader(_:)), forControlEvents: .TouchUpInside)
        
        
        
        return cell
    }
    
    func likeReader (sender: UIButton) {
     
        if sender.selected == true {
            ApplicationState.sharedInstance.favoriteReads.append(self.readingDay!)
        } else {
           
           ApplicationState.sharedInstance.favoriteReads = ApplicationState.sharedInstance.favoriteReads.filter() {$0.title != self.readingDay!.title}
        }
        
    }
}


extension ReadingDayViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
}
