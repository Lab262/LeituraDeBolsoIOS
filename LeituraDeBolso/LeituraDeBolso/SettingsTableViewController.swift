//
//  SettingsTableViewController.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 31/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit



class SettingsTableViewController: UITableViewController {

    
    private var showDateVisible = false
    
    private var currentModeReader = false
    private var currentFontSize: CGFloat = 0.0
    private var dictionarySizeText: Dictionary <CGFloat, Float> = [11.0: 1, 12.0: 2, 13.0: 3, 14.0: 4, 15.0: 5,  16.0: 6, 17.0: 7]
    
    @IBOutlet weak var timeTableLabel: UILabel!
    
    @IBOutlet weak var timeTableDatePicker: UIDatePicker!
    
    @IBOutlet weak var modeNightSwitch: UISwitch!
    
    @IBOutlet weak var fontSizeSlider: StepSlider!
    
    @IBOutlet weak var trackView: UIView!
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trackView.layer.zPosition = -1
        self.modeNightSwitch.on = ApplicationState.sharedInstance.modeNight!
        
        self.currentModeReader = self.modeNightSwitch.on
        self.currentFontSize = ApplicationState.sharedInstance.sizeFontSelected!
        self.fontSizeSlider.steps = 7
        self.fontSizeSlider.minValue = 1
        self.fontSizeSlider.maxValue = 7
        self.fontSizeSlider.value = self.dictionarySizeText[ApplicationState.sharedInstance.sizeFontSelected!]!
        self.fontSizeSlider.addTarget(self, action: #selector(changedFontSizeText(_:)), forControlEvents: .AllEvents)

    }
    
    func changedFontSizeText (sender: UIButton) {
        
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
    
    @IBAction func nightModeSelected(sender: AnyObject) {
        
        if self.modeNightSwitch.on {
            
           ApplicationState.sharedInstance.modeNight = true
         
            
        } else {
            
           ApplicationState.sharedInstance.modeNight = false
        }

    }
    
    
    @IBAction func popoverView(sender: AnyObject) {
        
        if self.currentModeReader != ApplicationState.sharedInstance.modeNight || self.currentFontSize != ApplicationState.sharedInstance.sizeFontSelected {
        
            self.presentViewController(ViewUtil.viewControllerFromStoryboardWithIdentifier("Main")!, animated: true, completion: nil)
        } else {
         
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
   
   
    @IBAction func showTimeTable(sender: AnyObject) {
        
        self.showHourChanged()
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
  
    private func toogleDatePicker () {
        
        self.showDateVisible = !self.showDateVisible
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if indexPath.row == 1 {
            self.toogleDatePicker()
            
        }
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if !self.showDateVisible && indexPath.row == 2 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    
    private func showHourChanged () {
        
        self.timeTableLabel.text = NSDateFormatter.localizedStringFromDate(self.timeTableDatePicker.date, dateStyle: .NoStyle, timeStyle: .ShortStyle)
        
    }
 }
