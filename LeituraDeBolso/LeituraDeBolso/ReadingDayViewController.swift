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
    var allReadings = [Reading]()
    
    
    
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
    
    func getReadingsIdUser (user: User) -> [String] {
        
        let allReadingsIdUser = user.getAllUserReadingIdProperty(propertyName: "idReading")
        
        return allReadingsIdUser as! [String]
    }
    
    
    func getReadings (readingsIds: [String], user: User, completionHandler: @escaping (_ success: Bool, _ msg: String, _ readingDay: Reading?) -> Void) {
        
        ReadingRequest.getAllReadings(readingsAmount: 5, readingsIds: readingsIds, isReadingIdsToDownload: false) { (success, msg, readings) in
            
            if success {
                
                if readings!.count > 0 {
                    
                    for reading in readings! {
                        self.createUserReading(user: user, reading: reading)
                        DBManager.addObjc(reading)
                    }
                    //57f4674e6d79cc0300305b51
                    let reading = readings!.first
                    
                    completionHandler(true, "Leituras salvas", reading)
                    
                } else {
                    print ("Sem leituras para baixar.")
                    
                    let reading:Reading = DBManager.getAll().first! as! Reading
                    
                    completionHandler(true, "Sem Leituras", reading)
                }
                
            } else {
                
                let reading:Reading = DBManager.getAll().first! as! Reading
                
                completionHandler(true, "MSG ERROR: \(msg)", reading)

                
            }
        }
    }
    
    func createUserReading (user: User, reading: Reading) {
        
        UserReadingRequest.createUserReading(readingId: reading.id!, isFavorite: false, alreadyRead: false) { (success, msg) in
            
            if success {
                print ("USER READING CRIADO: \(msg)")
            } else {
                print ("USER READING NÃO CRIADO: \(msg)")
                
            }
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        self.getReadings(readingsIds: self.getReadingsIdUser(user: ApplicationState.sharedInstance.currentUser!), user: ApplicationState.sharedInstance.currentUser!) { (success, msg, reading) in
            
            if success {
                self.readingDay = reading!
                self.tableView.reloadData()
            } else {
                print ("MENSAGEM ERRO: \(msg)")
            }
            
        }
        
        if ApplicationState.sharedInstance.modeNight! {
            self.setNightMode()
        } else {
            self.setNormalMode()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.readingDay?.title == nil {
            self.readingDay = DBManager.getAll().first
            
            self.tableView.reloadData()
        }
        
        self.configureTableView()
       
    }
    
    
    func shareReading (_ sender: UIButton) {
        
    
        let activity = UIActivityViewController(activityItems: ["\(self.readingDay!.title!) \(self.readingDay!.content!)"], applicationActivities: nil)
        
        
        let excludeActivities = [UIActivityType.postToFacebook, UIActivityType.postToTwitter, UIActivityType.message, UIActivityType.mail]
        
        activity.excludedActivityTypes = excludeActivities
        
        self.present(activity, animated: true, completion: nil)
        
    }
    
    func generateHeadingCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: HeadingTableViewCell.identifier, for: indexPath) as! HeadingTableViewCell
        
        cell.reading = self.readingDay
        
        return cell
    }
    
    func generateContentCell (_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as! ContentTableViewCell
    
        cell.reading = self.readingDay
        cell.layoutIfNeeded()
        cell.layoutSubviews()
        
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


extension ReadingDayViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.readingDay?.title == "" || self.readingDay?.title == nil {
            return 0
        } else {
            return 3
        }
      
    }
    
}


//
//            if let userReadings = ApplicationState.sharedInstance.currentUser?.readings {
//
//                var userReadingsIds = [String]()
//
//                for reading in userReadings {
//                    userReadingsIds.append(reading.id!)
//                }
//
//                ReadingRequest.getAllReadings(readingsAmount: 10, readingsToIgnore: userReadingsIds, completionHandler: { (success, msg, readings) in
//
//                    self.allReadings = readings
//                    self.readingDay = self.allReadings.last
//                    self.tableView.reloadData()
//                })
//
//            }
//
//
//        }
