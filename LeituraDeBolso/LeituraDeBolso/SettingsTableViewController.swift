//
//  SettingsTableViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 31/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit



class SettingsTableViewController: UITableViewController {

    
    fileprivate var showDateVisible = false
    
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    override func viewWillLayoutSubviews() {
        
        if ApplicationState.sharedInstance.modeNight! {
            self.setNightMode()
        } else {
            self.setNormalMode()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trackView.layer.zPosition = -1
        self.modeNightSwitch.isOn = ApplicationState.sharedInstance.modeNight!
            
        self.fontSizeSlider.steps = 7
        self.fontSizeSlider.minValue = 1
        self.fontSizeSlider.maxValue = 7
        self.fontSizeSlider.value = self.dictionarySizeText[ApplicationState.sharedInstance.sizeFontSelected!]!
        self.fontSizeSlider.addTarget(self, action: #selector(changedFontSizeText(_:)), for: .allEvents)

    }
    
    func changedFontSizeText (_ sender: UIButton) {
        
        if self.fontSizeSlider.value == 1 {
            ApplicationState.sharedInstance.sizeFontSelected = 11
        } else if self.fontSizeSlider.value == 2 {
            ApplicationState.sharedInstance.sizeFontSelected = 12
        } else if self.fontSizeSlider.value == 3 {
            ApplicationState.sharedInstance.sizeFontSelected = 13
        } else if self.fontSizeSlider.value == 4 {
            ApplicationState.sharedInstance.sizeFontSelected = 14
        } else if self.fontSizeSlider.value == 5 {
            ApplicationState.sharedInstance.sizeFontSelected = 15
        } else if self.fontSizeSlider.value == 6 {
            ApplicationState.sharedInstance.sizeFontSelected = 16
        } else {
            ApplicationState.sharedInstance.sizeFontSelected = 17
        }
        
    }
    
    @IBAction func nightModeSelected(_ sender: AnyObject) {
        
        if self.modeNightSwitch.isOn {
            
           ApplicationState.sharedInstance.modeNight = true
           self.setNightMode()
            
        } else {
            
           ApplicationState.sharedInstance.modeNight = false
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if (indexPath as NSIndexPath).row == 1 {
            self.toogleDatePicker()
            
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if !self.showDateVisible && (indexPath as NSIndexPath).row == 2 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    
    fileprivate func showHourChanged () {
        
        self.timeTableLabel.text = DateFormatter.localizedString(from: self.timeTableDatePicker.date, dateStyle: .none, timeStyle: .short)
        
    }
 }
