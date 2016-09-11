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
    private var currentFontSize = false
    
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
        
       self.fontSizeSlider.steps = 7
        
        //self.currentFontSize = self.switch

    }
    
    @IBAction func nightModeSelected(sender: AnyObject) {
        
        
        
        if self.modeNightSwitch.on {
            
           ApplicationState.sharedInstance.modeNight = true
         
            
        } else {
            
           ApplicationState.sharedInstance.modeNight = false
        }

    }
    
    
    @IBAction func popoverView(sender: AnyObject) {
        
        if self.currentModeReader != ApplicationState.sharedInstance.modeNight {
        
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
