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
        
        let myStr = "\u{1F603}"
     //   let str = String(Character(UnicodeScalar(Int(myStr, radix: 16)!)))
        
        
        if readingDay?.title == nil {
            
            self.readingDay?.duration = "21 min"
            self.readingDay?.title = "As Cronicas de Gelo e Fogo, A Fúria dos Reis, A Tormenta de Espadas"
            
            self.arrayImages.append("\u{1F603}")
            self.arrayImages.append("\u{1F603}")
            self.arrayImages.append("\u{1F603}")
            
            
            
            self.readingDay?.emojis = self.arrayImages
            self.readingDay?.text = " <3   The majestic Rocky Mountains are a major tourist location in the western United States. Visitors can participate in a quantity of activities, including hiking, skiing, snowboarding, mountain biking, & plenty of more. The Rockies are home to several campgrounds, ghost towns, gold prospecting sites, & national parks. a quantity of the biggest tourist attractions in the Rockies are Pike’s Peak & Royal Gorge. There are several world famous national parks in the Rockies, including Yellowstone, Rocky Mountain, Grand Teton, & Glacier.\n \nThe legendary Rocky Mountains stretch from old Mexico up through the United States & into Canada. The Rocky Mountains are over 3000 miles long, spanning parts of california, Colorado, Idaho, Montana, & Wyoming before continuing into Canada. Stories of early adventurers like Lewis & Clark exploring the Rocky Mountains are legendary."
            
            self.readingDay?.author = "DULCINO DE MORAIS VIEIRA COSTA SMADI"
            
            
        }
        
        
    }
    
    
    
    func indicator () {
        
        let statusImage = UIImage(named: "")
        
        let activityImageView = UIImageView(image: statusImage)
        
        
        
       // activityImageView.animationImages?.append(<#T##newElement: Element##Element#>)
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
//        UIImage *statusImage = [UIImage imageNamed:@"status1.png"];
//        UIImageView *activityImageView = [[UIImageView alloc]
//        initWithImage:statusImage];
//        
//        
//        //Add more images which will be used for the animation
//        activityImageView.animationImages = [NSArray arrayWithObjects:
//        [UIImage imageNamed:@"status1.png"],
//        [UIImage imageNamed:@"status2.png"],
//        [UIImage imageNamed:@"status3.png"],
//        [UIImage imageNamed:@"status4.png"],
//        [UIImage imageNamed:@"status5.png"],
//        [UIImage imageNamed:@"status6.png"],
//        [UIImage imageNamed:@"status7.png"],
//        [UIImage imageNamed:@"status8.png"],
//        nil];
//        
//        
//        //Set the duration of the animation (play with it
//        //until it looks nice for you)
//        activityImageView.animationDuration = 0.8;
//        
//        
//        //Position the activity image view somewhere in
//        //the middle of your current view
//        activityImageView.frame = CGRectMake(
//        self.view.frame.size.width/2
//        -statusImage.size.width/2,
//        self.view.frame.size.height/2
//        -statusImage.size.height/2,
//        statusImage.size.width,
//        statusImage.size.height);
//        
//        //Start the animation
//        [activityImageView startAnimating];
//        
//        
//        //Add your custom activity indicator to your current view
//        [self.view addSubview:activityImageView];

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedRowHeight = 210
        
        self.tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.layoutIfNeeded()

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
        
        
        
        return cell
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
