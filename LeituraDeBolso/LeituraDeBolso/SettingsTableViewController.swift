//
//  SettingsTableViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 31/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import Realm
import RealmSwift
import UserNotifications


class SettingsTableViewController: UITableViewController {

    
    fileprivate var showDateVisible = false
    fileprivate var showNotificationHour = false
    
    @IBOutlet weak var firstLineView: UIView!
    
    @IBOutlet weak var secondLineView: UIView!
    
    @IBOutlet weak var thirdLineView: UIView!
    
    @IBOutlet weak var fourthLineView: UIView!
    
    @IBOutlet weak var fifthLineView: UIView!
    
   
    fileprivate var dictionarySizeText: Dictionary <CGFloat, Float> = [11.0: 1, 12.0: 2, 13.0: 3, 14.0: 4, 15.0: 5,  16.0: 6, 17.0: 7]
    
    @IBOutlet weak var timeTableLabel: UILabel!
    
    @IBOutlet weak var timeTableDatePicker: UIDatePicker!
    
    @IBOutlet weak var modeNightSwitch: UISwitch!
    
    @IBOutlet weak var fontSizeSlider: StepSlider!
    
    @IBOutlet weak var trackView: UIView!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var receiveLabel: UILabel!
    
    
    @IBOutlet weak var nightModeLabel: UILabel!
    
    
    @IBOutlet weak var informationNightLabel: UILabel!
    
    
    @IBOutlet weak var textSizeLabel: UILabel!
    
    @IBOutlet weak var smallerSizeLabel: UILabel!
    
    
    @IBOutlet weak var largerSizeLabel: UILabel!
    
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.trackView.layer.zPosition = -1
        self.modeNightSwitch.isOn = ApplicationState.sharedInstance.currentUser!.isModeNight
        self.notificationSwitch.isOn = ApplicationState.sharedInstance.currentUser!.isNotification
        self.showNotificationHour = self.notificationSwitch.isOn
        self.timeTableDatePicker.date = ApplicationState.sharedInstance.currentUser!.notificationHour
        self.fontSizeSlider.steps = 7
        self.fontSizeSlider.minValue = 1
        self.fontSizeSlider.maxValue = 7
        self.fontSizeSlider.value = self.dictionarySizeText[ApplicationState.sharedInstance.currentUser!.sizeFont]!
        self.fontSizeSlider.addTarget(self, action: #selector(changedFontSizeText(_:)), for: .allEvents)
        self.timeTableLabel.text = DateFormatter.localizedString(from: self.timeTableDatePicker.date, dateStyle: .none, timeStyle: .short)

    }
    
    override func viewWillLayoutSubviews() {
        
        if ApplicationState.sharedInstance.currentUser!.isModeNight {
            self.setNightMode()
        } else {
            self.setNormalMode()
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.trackView.layer.zPosition = -1
//        self.modeNightSwitch.isOn = ApplicationState.sharedInstance.currentUser!.isModeNight
//        self.notificationSwitch.isOn = ApplicationState.sharedInstance.currentUser!.isNotification
//        
//        self.timeTableDatePicker.date = ApplicationState.sharedInstance.currentUser!.notificationHour
//        self.fontSizeSlider.steps = 7
//        self.fontSizeSlider.minValue = 1
//        self.fontSizeSlider.maxValue = 7
//        self.fontSizeSlider.value = self.dictionarySizeText[ApplicationState.sharedInstance.currentUser!.sizeFont]!
//        self.fontSizeSlider.addTarget(self, action: #selector(changedFontSizeText(_:)), for: .allEvents)
//        self.timeTableLabel.text = DateFormatter.localizedString(from: self.timeTableDatePicker.date, dateStyle: .none, timeStyle: .short)
    }
    
    func changedFontSizeText (_ sender: UIButton) {
        
        if self.fontSizeSlider.value == 1 {
            
            try! Realm().write(){
                ApplicationState.sharedInstance.currentUser?.sizeFont = 11
            }
        
        } else if self.fontSizeSlider.value == 2 {
            try! Realm().write(){
                ApplicationState.sharedInstance.currentUser?.sizeFont = 12
            }
        } else if self.fontSizeSlider.value == 3 {
            try! Realm().write(){
                ApplicationState.sharedInstance.currentUser?.sizeFont = 13
            }
        } else if self.fontSizeSlider.value == 4 {
            try! Realm().write(){
                ApplicationState.sharedInstance.currentUser?.sizeFont = 14
            }
        } else if self.fontSizeSlider.value == 5 {
            try! Realm().write(){
                ApplicationState.sharedInstance.currentUser?.sizeFont = 15
            }
        } else if self.fontSizeSlider.value == 6 {
            try! Realm().write(){
                ApplicationState.sharedInstance.currentUser?.sizeFont = 16
            }
        } else {
            try! Realm().write(){
                ApplicationState.sharedInstance.currentUser?.sizeFont = 17
            }
        }
        DBManager.update(ApplicationState.sharedInstance.currentUser!)
        
    }
    
    
    @IBAction func notificationSelected(_ sender: AnyObject) {
        
        
        if self.notificationSwitch.isOn {
            
            try! Realm().write(){
                ApplicationState.sharedInstance.currentUser?.isNotification = true
            }
            
            if #available(iOS 10.0, *) {
                
                let content = UNMutableNotificationContent()
                content.title = "Leitura nova disponível!"
                content.body = "Leitura do dia está disponível :)"
                content.categoryIdentifier = "message"
                
                let currentDateTime = ApplicationState.sharedInstance.currentUser!.notificationHour
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
                
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
            self.showNotificationHour = true
            tableView.beginUpdates()
            tableView.endUpdates()
            
        } else {
            
            try! Realm().write(){
                ApplicationState.sharedInstance.currentUser?.isNotification = false
            }
            
            DBManager.update(ApplicationState.sharedInstance.currentUser!)
            if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            } else {
                // Fallback on earlier versions
            }
            
            self.showNotificationHour = false
            tableView.beginUpdates()
            tableView.endUpdates()

        }

        
    }
    
    @IBAction func nightModeSelected(_ sender: AnyObject) {
        
        if self.modeNightSwitch.isOn {
            
            try! Realm().write(){
                 ApplicationState.sharedInstance.currentUser?.isModeNight = true
            }
            DBManager.update(ApplicationState.sharedInstance.currentUser!)
        
           self.setNightMode()
            
        } else {
            
            try! Realm().write(){
                ApplicationState.sharedInstance.currentUser?.isModeNight = false
            }
            DBManager.update(ApplicationState.sharedInstance.currentUser!)
            
            self.setNormalMode()
        }

    }
    
    func setNightMode () {
        
        self.firstLineView.alpha = 0.3
        self.secondLineView.alpha = 0.3
        self.thirdLineView.alpha = 0.3
        self.fourthLineView.alpha = 0.3
        self.fifthLineView.alpha = 0.3
        self.logoutButton.setTitleColor(UIColor.white, for: .normal)
        self.view.backgroundColor = UIColor.readingModeNightBackground()
        self.tableView.backgroundColor = UIColor.readingModeNightBackground()
        
        for (_, cell) in self.tableView.visibleCells.enumerated() {
            cell.backgroundColor = UIColor.readingModeNightBackground()
        }
        
        
        for i in 1..<7 {
            
            if let label = self.view.viewWithTag(i) as? UILabel {
            label.textColor = UIColor.white
                
            }
        }
        
        self.timeTableDatePicker.setValue(UIColor.white, forKey: "textColor")

        
    }
    
    
    
    func setNormalMode () {
        
        self.firstLineView.alpha = 1.0
        self.secondLineView.alpha = 1.0
        self.thirdLineView.alpha = 1.0
        self.fourthLineView.alpha = 1.0
        self.fifthLineView.alpha = 1.0
        
        self.logoutButton.setTitleColor(UIColor.black, for: .normal)
        
        self.view.backgroundColor = UIColor.white
        self.tableView.backgroundColor = UIColor.white
        
        
        for (_, cell) in self.tableView.visibleCells.enumerated() {
            cell.backgroundColor = UIColor.white
        }
        
        
        for i in 1..<7 {
            
            if let label = self.view.viewWithTag(i) as? UILabel {
                label.textColor = UIColor.black
                
            }
        }
        
        self.timeTableDatePicker.setValue(UIColor.black, forKey: "textColor")

       
    }
    
    
    @IBAction func logout(_ sender: AnyObject) {
        

        
        try! Realm().write(){
             ApplicationState.sharedInstance.currentUser?.token = nil
        }
        DBManager.update(ApplicationState.sharedInstance.currentUser!)
        
        
        
        self.present(ViewUtil.viewControllerFromStoryboardWithIdentifier("Login")!, animated: true, completion: nil)
    }
    
    @IBAction func popoverView(_ sender: AnyObject) {

        _ = self.navigationController?.popViewController(animated: true)
      
    }
    
   
   
    @IBAction func showTimeTable(_ sender: AnyObject) {
        
        self.showHourChanged()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
    }
    
  
    fileprivate func toogleDatePicker () {
        
        self.showDateVisible = !self.showDateVisible
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    fileprivate func toogleNotificationHour () {
        
        self.showDateVisible = !self.showDateVisible
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 1 {
            self.toogleDatePicker()
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if !self.showNotificationHour && indexPath.row == 1 {
            return 0
        } else if !self.showDateVisible && indexPath.row == 2 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    
    fileprivate func showHourChanged () {
        
        self.timeTableLabel.text = DateFormatter.localizedString(from: self.timeTableDatePicker.date, dateStyle: .none, timeStyle: .short)
        
       self.setLocalNotificationHour(date: self.timeTableDatePicker.date)
        
    }
    
    func setLocalNotificationHour(date: Date) {
        
        if #available(iOS 10.0, *) {
            
            let content = UNMutableNotificationContent()
            content.title = "Leitura nova disponível!"
            content.subtitle = "Leitura de Bolso"
            content.body = "Leitura do dia está disponível :)"
            content.categoryIdentifier = "message"
            
            let currentDateTime = date
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
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            try! Realm().write(){
                ApplicationState.sharedInstance.currentUser?.notificationHour = date
            }
            DBManager.update(ApplicationState.sharedInstance.currentUser!)
        }
        

    }
 }
