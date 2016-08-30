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
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.readingDay?.duration = "21 min"
        self.readingDay?.title = "As Cronicas de Gelo e Fogo, A Fúria dos Reis, A Tormenta de Espadas"
        
        self.readingDay?.text = "O que eu não entendo é tipo, quando a gente aponta um monte de retrocesso e ações neo liberais que vieram no governo dela, quando a gente cita que direitos das minorias foram negociados com bancada evangélica, que vidas indígenas foram negociadas com ruralistas, essas paradas aí - essas coisas que todo mundo sabe e tal - as pessoas chegam com uns - Ah, mas negociar faz parte do jogo político. Ah, mas é isso mesmo, se ela não resolvesse ceder e manter os esquemas com as elites ela nunca se manteria no poder. Ah, mas é isso mesmo, tem que dizer uma coisa pra um grupo e outra pro outro - cede e tira - política é isso. - Ah, mas negociar faz parte do jogo político. Ah, mas é isso mesmo, se ela não resolvesse ceder e manter os esquemas com as elites ela nunca se manteria no poder. Ah, mas é isso mesmo, tem que dizer uma coisa pra um grupo e outra pro outro - cede e tira - política é isso."
        
        self.readingDay?.author = "DULCINO DE MORAIS VIEIRA COSTA SMADI"
        
        self.tableView.reloadData()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.estimatedRowHeight = 210
        
        self.tableView.estimatedRowHeight = 300
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.setNeedsLayout()
        self.tableView.layoutIfNeeded()

        // Do any additional setup after loading the view.
    }
    
    func shareReading (sender: UIButton) {
        
        
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
