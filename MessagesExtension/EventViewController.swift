//
//  EventViewController.swift
//  TimeShare
//
//  Created by Parankush Bhardwaj on 3/30/17.
//  Copyright © 2017 Parankush Bhardwaj. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBAction func saveSelectedDates(_ sender: Any) {
    }
    
    
    @IBAction func addDate(_ sender: Any) {
        
        //add date to arrays
        dates.append(datePicker.date)
        allVotes.append(0)
        ourVotes.append(1)
        
        //insert the row to table using animation
        let newIndexPath = IndexPath(row: dates.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        
        //scroll new row into the view
        tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        
        //flash the scroll bar for user to know event has been saved
        tableView.flashScrollIndicators()
        
    }
    
    
    var dates = [Date]()
    var allVotes = [Int]()
    var ourVotes = [Int]()
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                ourVotes[indexPath.row] = 0
            } else {
                cell.accessoryType = .checkmark
                ourVotes[indexPath.row] = 1
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        //deque a cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Date", for: indexPath)
        
        
        //pull our dates and format
        let date = dates[indexPath.row]
        cell.textLabel?.text = DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .short)
        
        
        
        //add a checkmark if we voted for this date
        if ourVotes[indexPath.row] == 1 {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        
        
        //add a vote count if others voted for it
        if allVotes[indexPath.row] > 0 {
            cell.detailTextLabel?.text = "Votes: \(allVotes[indexPath.row])"
        } else  {
            cell.detailTextLabel?.text = ""
        }
        
        
        
        return cell
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
