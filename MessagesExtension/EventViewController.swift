//
//  EventViewController.swift
//  TimeShare
//
//  Created by Parankush Bhardwaj on 3/30/17.
//  Copyright © 2017 Parankush Bhardwaj. All rights reserved.
//

import UIKit
import Messages

class EventViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    var dates = [Date]()
    var allVotes = [Int]()
    var ourVotes = [Int]()
    weak var delegate: MessagesViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
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
    
    
    
    
    @IBAction func saveSelectedDates(_ sender: AnyObject) {
        var finalVotes = [Int]()
        
        for (index, votes) in allVotes.enumerated() {
            finalVotes.append(votes + ourVotes[index])
        }
        
        delegate.createMessage(with: dates, votes: finalVotes)
    }
    
    
    @IBAction func addDate(_ sender: AnyObject) {
        
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
    
    
    
    
    func load(from message: MSMessage?) {
        
        guard let message = message else { return }
        guard let messageURL = message.url else {return }
        guard let urlComponents = URLComponents(url: messageURL, resolvingAgainstBaseURL: false)
            else { return }
        guard let queryItems = urlComponents.queryItems else { return }
        
        for item in queryItems {
            if item.name.hasPrefix("date-") {
                dates.append(date(from: item.value ?? ""))
            }
            else if item.name.hasPrefix("vote-") {
                let voteCount = Int(item.value ?? "") ?? 0
                allVotes.append(voteCount)
                ourVotes.append(0)
            }
        }
    }
    
    
    func date(from string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
        
        return dateFormatter.date(from: string) ?? Date()
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
