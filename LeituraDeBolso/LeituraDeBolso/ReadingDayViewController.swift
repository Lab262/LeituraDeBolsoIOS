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
        
        if ApplicationState.sharedInstance.modeNight! {
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
        
        self.view.backgroundColor = UIColor.readingModeNightBackground()
        self.tableView.backgroundColor = UIColor.readingModeNightBackground()
    }
    
    func setNormalMode () {
        
        self.view.backgroundColor = UIColor.white
        self.tableView.backgroundColor = UIColor.white
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
        self.readingDay?.text = "The majestic Rocky Mountains are a major tourist location in the western United States. Visitors can participate in a quantity of activities, including hiking, skiing, snowboarding, mountain biking, & plenty of more. The Rockies are home to several campgrounds, ghost towns, gold prospecting sites, & national parks. a quantity of the biggest tourist attractions in the Rockies are Pike’s Peak & Royal Gorge. There are several world famous national parks in the Rockies, including Yellowstone, Rocky Mountain, Grand Teton, & Glacier.\n \nThe legendary Rocky Mountains stretch from old Mexico up through the United States & into Canada. The Rocky Mountains are over 3000 miles long, spanning parts of california, Colorado, Idaho, Montana, & Wyoming before continuing into Canada. Stories of early adventurers like Lewis & Clark exploring the Rocky Mountains are legendary."
        
        self.readingDay?.author = "DULCINO DE MORAIS VIEIRA COSTA SMADI"
        
        self.tableView.reloadData()

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
        
        return 3
    }
}
