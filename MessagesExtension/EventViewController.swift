//
//  EventViewController.swift
//  TimeShare
//
//  Created by Parankush Bhardwaj on 3/30/17.
//  Copyright © 2017 Parankush Bhardwaj. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBAction func saveSelectedDates(_ sender: Any) {
    }
    
    
    @IBAction func addDate(_ sender: Any) {
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
