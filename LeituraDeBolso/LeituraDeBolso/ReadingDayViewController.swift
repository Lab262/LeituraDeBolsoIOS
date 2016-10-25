//
//  ReadingDayViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 29/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import UserNotifications
import Realm
import RealmSwift

class ReadingDayViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var readingDay: Reading? = Reading()
    var arrayImages = Array<String>()
    var allReadings = [Reading]()
    var isGrantedNotificationAccess: Bool?
    var isReadingDay = true
    
    @IBOutlet weak var historicalIcon: UIBarButtonItem!
    
    func configureTableView () {
        
        self.tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.layoutIfNeeded()
        
    }
    
    func setAlreadyRead() {
        
        ApplicationState.sharedInstance.currentUser?.setAlreadyRead(id: (self.readingDay?.id)!)
        
        UserReadingRequest.updateUserReading(readingId: self.readingDay!.id!, isFavorite: nil, alreadyRead: true, completionHandler: { (success, msg) in
            
            if success {
                print ("LEU LEITURA: \(msg)")
                let readingsUnreadCount = self.getReadingsUnreadCount()
                self.updateBadgeNumber(badgeCount: readingsUnreadCount)
                self.updateIconHistorical(unreadsCount: readingsUnreadCount)
                
            } else {
                print ("DEU ERRO NA READING LEITURA: \(msg)")
            }
        })
    }
    
    func updateIconHistorical (unreadsCount: Int) {
        
        if unreadsCount > 0 {
            self.historicalIcon.image = UIImage(named:"button_historicNotified")
        } else {
            self.historicalIcon.image = UIImage(named: "button_historic")
        }
    }
    
    func updateBadgeNumber(badgeCount: Int) {
        
        UIApplication.shared.applicationIconBadgeNumber = badgeCount
    }
    
    
    func getReadingsUnreadCount () -> Int {
        
        let allReadings: [Reading] = DBManager.getAll()
        var readingsUnread = [Reading]()
        
        if !allReadings.isEmpty {
            readingsUnread = allReadings.filter {
                !ApplicationState.sharedInstance.currentUser!.readingAlreadyRead(id: $0.id!)!
            }
        }
        
        
        return readingsUnread.count
    }
    
    func setupBadgeNumberPermissions() {
        
        let notificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(types: .badge, categories: nil)
        
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
    }
    
    func setNightMode() {
        
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
    
    func saveCurrentSessionInTimeInterval (user: User) {
        
        try! Realm().write {
            user.lastSessionTimeInterval = NSDate().timeIntervalSince1970
        }
        
        DBManager.update(ApplicationState.sharedInstance.currentUser!)
        
    }
    
    func getDifferenceDays (user: User) -> Int {
        
        
        if ApplicationState.sharedInstance.currentUser?.lastSessionTimeInterval != 0 {
            
            let lastSessionDate = Date(timeIntervalSince1970: (user.lastSessionTimeInterval))
            
            let currentDate = Date()
            let calendar = Calendar.current
            
            let currentDay = calendar.ordinality(of: .day, in: .year, for: currentDate)
            let dayUser = calendar.ordinality(of: .day, in: .year, for: lastSessionDate)
            
            var differenceDays = currentDay! - dayUser!
            
            if differenceDays < 0 {
                var numberDays = 365
                let yearUser = calendar.component(.year, from: lastSessionDate)
                
                if Date().isLeapYear(year: yearUser) {
                    numberDays = 366
                }
                
                differenceDays = (dayUser!+numberDays)-currentDay!
            }
            
            return differenceDays
        } else {
            
            return 1
        }
       
    }
    
    func getReadingsIdUser (user: User) -> [String] {
        
        let allReadingsIdUser = user.getAllUserReadingIdProperty(propertyName: "idReading")
        
        let allReadings: [Reading] = DBManager.getAll()
        
        let allReadingsDataBaseId = allReadings.map { (object) -> Any in
            
            return object.value(forKey: "idReading")
        }
        
        let allReadingsId = allReadingsIdUser as! [String]
        let allDataBaseId = allReadingsDataBaseId as! [String]
        
        let answer = allReadingsId.filter{
            item in !allDataBaseId.contains(item)
        }
        
        return answer
    }

    
    func getReadingsIdUser (user: User, completionHandler: @escaping (_ success: Bool, _ msg: String, _ readingDay: [String]?) -> Void) {
        
        
        UserReadingRequest.getAllUserReading(user: user) { (success, msg, userReadings) in
            
            if success {
                
                try! Realm().write {
                    try! Realm().delete(user.userReadings)
                    
                }
                
                DBManager.update(user)
                
                try! Realm().write {
                    for userReading in userReadings! {
                        user.userReadings.append(userReading)
                    }
                }
            
                DBManager.update(user)
                
    
                let allReadingsIdUser = user.getAllUserReadingIdProperty(propertyName: "idReading")
                
                let allReadings: [Reading] = DBManager.getAll()
                
                let allReadingsDataBaseId = allReadings.map { (object) -> Any in
                    
                    return object.value(forKey: "id")
                }
                
                let allReadingsId = allReadingsIdUser as! [String]
                let allDataBaseId = allReadingsDataBaseId as! [String]
                
                let readingsId = allReadingsId.filter{
                    item in !allDataBaseId.contains(item)
                }
                
                completionHandler(true, "Get Readings Id User Success", readingsId)
                
            } else {
                
                completionHandler(false, msg, nil)

            }
            
        }
    }
    
    func getReadings (readingsIds: [String], user: User, completionHandler: @escaping (_ success: Bool, _ msg: String) -> Void) {
        

        ReadingRequest.getAllReadings(readingsAmount: readingsIds.count, readingsIds: readingsIds, isReadingIdsToDownload: true) { (success, msg, readings) in
                
            if success {
                self.view.unload()
                if readings!.count > 0 {
                        
                    for reading in readings! {
                        DBManager.addObjc(reading)
                    }
                        
                    completionHandler(true, "Get Readings sucesso")
                    
                } else {
                        
                    completionHandler(true, "Sem user readings pra baixar")
                        
                        
                }
                    
            } else {
  
                    completionHandler(true, "Erro de conexão")
                    
            }
        }
    }

    
    func getReadingOfTheDay (user: User, completionHandler: @escaping (_ success: Bool, _ msg: String, _ readingDay: Reading?) -> Void) {
        
        let days = self.getDifferenceDays(user: ApplicationState.sharedInstance.currentUser!)
        
        ReadingRequest.getReadingsOfTheDay(readingsAmount: days) { (success, msg, readings) in
                if success {
                    
                    if readings!.count > 0 {
                        
                        for reading in readings! {
                            
                            self.createUserReading(user: user, idReading: reading.id!)
                            
                            self.createUserReadingInDataBase(user: user, idReading: reading.id!)
                            
                            DBManager.addObjc(reading)
                        }
                        
                        
                        self.saveCurrentSessionInTimeInterval(user: ApplicationState.sharedInstance.currentUser!)
                        
                        let readings: [Reading] = DBManager.getAll()
                        
                        completionHandler(true, "Leituras salvas", readings.last)
                        
                    } else {
                        
                        print ("Sem leituras para baixar.")
                        
                        let readings : [Reading] = DBManager.getAll()
                        
                        self.saveCurrentSessionInTimeInterval(user: ApplicationState.sharedInstance.currentUser!)
                        
                        completionHandler(true, "Sem Leituras", readings.last)
                    }
                    
                } else {
                    
                    print ("SEM SUCESSO")
                    let readings : [Reading] = DBManager.getAll()
                    
                    completionHandler(true, "MSG ERROR: \(msg)", readings.last)
                }
            }
            
        }
    

    func createUserReadingInDataBase (user: User, idReading: String) {
        
        let userReading = UserReading()
        userReading.idReading = idReading
        userReading.isShared = false
        userReading.isFavorite = false
        userReading.alreadyRead = false
        
        
        // Updating book with id = 1
        
        
        try! Realm().write {
            user.userReadings.append(userReading)
        }
        
        DBManager.addObjc(user)
    }
    
    func getLastReadingInDataBase() {
        let readings : [Reading] = DBManager.getAll()
        self.readingDay = readings.last
    }
    
    func createUserReading (user: User, idReading: String) {
        
        UserReadingRequest.createUserReading(readingId: idReading, isFavorite: false, alreadyRead: false) { (success, msg) in
            
            if success {
               
                print ("USER READING CRIADO: \(msg)")
            } else {
                
                print ("USER READING NÃO CRIADO: \(msg)")
                
            }
        }
    }

    func saveUserReadings(readingsIds: [String]) {
        
        for readingId in readingsIds {
            self.createUserReading(user: ApplicationState.sharedInstance.currentUser!, idReading: readingId)
            self.createUserReadingInDataBase(user: ApplicationState.sharedInstance.currentUser!, idReading: readingId)
        }
        
    }
    
    func getReadingOfTheDayByDaysCount(user: User, days: Int, completionHandler: @escaping (_ success: Bool, _ msg: String, _ readingDay: Reading?) -> Void)  {
        
        ReadingRequest.getReadingsOfTheDay(readingsAmount: days) { (success, msg, readings) in
            if success {
                if readings!.count > 0 {
                    for reading in readings! {
                        self.createUserReading(user: user, idReading: reading.id!)
                        self.createUserReadingInDataBase(user: user, idReading: reading.id!)
                        DBManager.addObjc(reading)
                    }
                    
                    let readings: [Reading] = DBManager.getAll()
                    
                    self.saveCurrentSessionInTimeInterval(user: ApplicationState.sharedInstance.currentUser!)
                    
                    completionHandler(true, "Leituras salvas", readings.last)
                    
                } else {
                    
                    print ("Sem leituras para baixar.")
                    
                    let readings : [Reading] = DBManager.getAll()
                    
                    self.saveCurrentSessionInTimeInterval(user: ApplicationState.sharedInstance.currentUser!)
                    
                    completionHandler(true, "Sem Leituras", readings.last)
                }
                
            } else {
                
                print ("SEM SUCESSO")
                let readings : [Reading] = DBManager.getAll()
                
                completionHandler(true, "MSG ERROR: \(msg)", readings.last)
            }
        }
    }
    
    func updateBadgesAndIcon() {
        let readingsUnreadCount = self.getReadingsUnreadCount()
        self.updateBadgeNumber(badgeCount: readingsUnreadCount)
        self.updateIconHistorical(unreadsCount: readingsUnreadCount)
    }
    
    func getReadingDay() {
        
        let days = self.getDifferenceDays(user: ApplicationState.sharedInstance.currentUser!)
        
        if days != 0 {
            self.getReadingOfTheDayByDaysCount(user: ApplicationState.sharedInstance.currentUser!, days: days, completionHandler: { (success, msg, readingDay) in
                
                if success {
                    
                    if self.isReadingDay {
                        self.view.unload()
                            if self.readingDay != nil {
                                self.readingDay = readingDay!
                        
                                if !(ApplicationState.sharedInstance.currentUser?.readingAlreadyRead(id: readingDay!.id!))! {
                            
                                    self.setAlreadyRead()
                                }
                                self.tableView.reloadData()
                            } else {
                                self.tableView.reloadData()
                            }
                        
                        }
                    }
                })
            } else {
                if self.isReadingDay {
                    self.view.unload()
                    self.getLastReadingInDataBase()
                    self.tableView.reloadData()
                }
            }
        
        }
    
    func getReading() {
        
        if Reachability().isInternetAvailable() {
            if isReadingDay {
                self.view.loadAnimation()
            }
            self.getReadingsIdUser(user: ApplicationState.sharedInstance.currentUser!, completionHandler: { (success, msg, readingsId) in
                
                if success {
                    
                    if readingsId!.count > 0 {
                        
                        self.getReadings(readingsIds: readingsId!, user: ApplicationState.sharedInstance.currentUser!, completionHandler: { (success, msg) in
                            
                            if success {
                               self.getReadingDay()
                            }
                            
                        })
                    } else {
                        self.getReadingDay()
                    }
                } else {
                    if self.isReadingDay {
                        self.view.unload()
                        self.getLastReadingInDataBase()
                        self.tableView.reloadData()
                    }
                }
            })
        } else {
            self.getLastReadingInDataBase()
            self.tableView.reloadData()
        }
  
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.updateBadgesAndIcon()
        self.getReading()
        
        if ApplicationState.sharedInstance.currentUser!.isModeNight {
            self.setNightMode()
        } else {
            self.setNormalMode()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNotification()
       // self.setupBadgeNumberPermissions()
        
        if self.readingDay?.id != nil {
            if !ApplicationState.sharedInstance.currentUser!.readingAlreadyRead(id: self.readingDay!.id!)! {
                self.setAlreadyRead()
            }
        }
        
        self.configureTableView()
       
    }
    
    func sendNotification() {
        
        if isGrantedNotificationAccess! {
            if #available(iOS 10.0, *) {
                
                DispatchQueue.main.sync {
                    let realm = try! Realm()
                    realm.beginWrite()
                    if ApplicationState.sharedInstance.currentUser!.acceptsNotification == false {
                        let content = UNMutableNotificationContent()
                        content.title = "Leitura nova disponível!"
                        content.body = "Leitura do dia está disponível :)"
                        content.categoryIdentifier = "message"
                
                        let currentDateTime = Date()
                        let userCalendar = Calendar.current
                        let requestedComponents: Set<Calendar.Component> = [
                            .hour,
                            .minute]
                
                        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)
       
                        let hour = dateTimeComponents.hour
                        let minute = dateTimeComponents.minute
        
                        var dateComponents = DateComponents()
                        dateComponents.hour = hour
                        dateComponents.minute = minute
                
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                        let request = UNNotificationRequest(
                            identifier: "message",
                            content: content,
                            trigger: trigger
                        )
                        
                        UNUserNotificationCenter.current().add(request, withCompletionHandler:nil)
                
                    
                            ApplicationState.sharedInstance.currentUser?.isNotification = true
                            ApplicationState.sharedInstance.currentUser?.acceptsNotification = true
                            ApplicationState.sharedInstance.currentUser?.notificationHour = currentDateTime
                    
                            try! Realm().add(ApplicationState.sharedInstance.currentUser!, update: true)
                
                                do {
                                    try realm.commitWrite()
                        
                                }
                                catch (_){
                        
                            }
                    } else {
                        realm.cancelWrite()
                    }
                }
        
                }
            

        } else {
            
                // Fallback on earlier versions
        }
    }
    
    
    func setNotification() {
        
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
                
                self.isGrantedNotificationAccess = granted
                
                self.sendNotification()

            }
            
        } else {
            
        }
        
    }
    
    
    func shareReading(_ sender: UIButton) {
        
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
        
        cell.likeButton.isSelected = ApplicationState.sharedInstance.currentUser!.readingIsFavorite(id: self.readingDay!.id!)!
    
        
        return cell
    }
    
    func likeReader (_ sender: UIButton) {
     
        if sender.isSelected {
            
            ApplicationState.sharedInstance.favoriteReads.append(self.readingDay!)
            
            ApplicationState.sharedInstance.currentUser?.setFavoriteReading(id: self.readingDay!.id!, isFavorite: true)
            
            UserReadingRequest.updateUserReading(readingId: self.readingDay!.id!, isFavorite: true, alreadyRead: true, completionHandler: { (success, msg) in
                
                if success {
                    print ("FAVORITOU :\(msg)")
                    
                } else {
                    print ("DEU ERRO NO FAVORITO: \(msg)")
                }
                
            })
            
        } else {
           
           ApplicationState.sharedInstance.favoriteReads = ApplicationState.sharedInstance.favoriteReads.filter() {
                $0.id != self.readingDay!.id
            }
            
            ApplicationState.sharedInstance.currentUser?.setFavoriteReading(id: self.readingDay!.id!, isFavorite: false)
            
            UserReadingRequest.updateUserReading(readingId: self.readingDay!.id!, isFavorite: false, alreadyRead: true, completionHandler: { (success, msg) in
                
                if success {
                    
                    print ("RETIROU FAVORITO :\(msg)")
                } else {
                    print ("DEU ERRO NO RETIRAR FAVORITAR: \(msg)")
                }
                
            })
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
