//
//  MessagesViewController.swift
//  MessagesExtension
//
//  Created by Parankush Bhardwaj on 3/30/17.
//  Copyright © 2017 Parankush Bhardwaj. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createNewEvent(_ sender: AnyObject) {
        
        requestPresentationStyle(.expanded)
    }
    
    func displayEventController(conversation: MSConversation?, identifier: String) {
        
        //check if convo exists
        guard let conversation = conversation else { return }
        
        //create a child view
        guard let vc = storyboard?.instantiateViewController(withIdentifier: identifier) as? EventViewController else { return }
        
        vc.load(from: conversation.selectedMessage)
        
        vc.delegate =  self
        
        //add child view to parent
        addChildViewController(vc)
        
        
        //show child view to user
        vc.view.frame = view.bounds
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vc.view)
        
        
        
        //add constraints to child view for clean UI
        vc.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        vc.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        vc.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //tell child its under the parent
        vc.didMove(toParentViewController: self)
    }
    
    func createMessage(with dates: [Date], votes: [Int]) {
        
        //go back to compact view
        requestPresentationStyle(.compact)
        
        
        //check if convo exists
        guard let conversation = activeConversation else { return }
        
        //convert dates and votes into URLQueryItem objects
        
        var components = URLComponents()
        var items = [URLQueryItem]()
        
        for (index, date) in dates.enumerated() {
            let dateItem = URLQueryItem(name: "date-\(index)", value: string(from: date))
            items.append(dateItem)
            
            let voteItem = URLQueryItem(name: "vote-\(index)", value: String(votes[index]))
            items.append(voteItem)
        }
        
        components.queryItems = items
        
        //use the exiting session or create a new one
        let session = conversation.selectedMessage?.session ?? MSSession()
        
        
        
        //create a new message from the session and assign it the URL we created from our dates and votes
        let message = MSMessage(session: session)
        message.url = components.url
        
        
        
        //create a blank default message layout
        
        let layout = MSMessageTemplateLayout()
        layout.image = render(dates: dates)
        layout.caption = "I voted"
        message.layout = layout
        
        //insert it into the conversation
        conversation.insert(message) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func string(from date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm"
        
        return dateFormatter.string(from: date)
    }
    
    func render(dates: [Date]) -> UIImage {
        
        //20-point padding for clarity
        let inset: CGFloat = 20
        
        
        // create the attributes for drawing using Dynamic Type so that we respect the user's font choices
        let attributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .body), NSForegroundColorAttributeName: UIColor.darkGray]
        
        // make a single string out of all the dates
        var stringToRender = ""
        
        dates.forEach {
            stringToRender += DateFormatter.localizedString(from: $0, dateStyle: .long, timeStyle: .short) + "\n"
        }
        
        // trim the last line break, then create an attributed string by merging the date string and the attributes
        let trimmed = stringToRender.trimmingCharacters(in: .whitespacesAndNewlines)
        let attributedString = NSAttributedString(string: trimmed, attributes: attributes)
        
        // calculate the size required to draw the attributed string, then add the inset to all edges
        var imageSize = attributedString.size()
        imageSize.width += inset * 2
        imageSize.height += inset * 2
        
        // create an image format that uses @3x scale on an opaque background
        let format = UIGraphicsImageRendererFormat()
        format.opaque = true
        format.scale = 3
        
        // create a renderer at the correct size, using the above format
        let renderer = UIGraphicsImageRenderer(size: imageSize, format: format)
        
        // render a series of instructions to `image`
        let image = renderer.image { ctx in
            // draw a solid white background
            UIColor.white.set()
            ctx.fill(CGRect(origin: CGPoint.zero, size: imageSize))
            
            // now render our text on top, using the insets we created
            attributedString.draw(at: CGPoint(x: inset, y: inset))
        }
        
        // send the resulting image back
        return image
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Conversation Handling
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        // Use this method to configure the extension and restore previously stored state.
        
        if presentationStyle == .expanded {
            displayEventController(conversation: conversation, identifier: "SelectDates")
        }
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
    
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
        
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        
        for child in childViewControllers {
            child.willMove(toParentViewController: nil)
            child.view.removeFromSuperview()
            child.removeFromParentViewController()
        }
        
        if presentationStyle == .expanded {
            displayEventController(conversation: activeConversation, identifier: "CreateEvent")
        }
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
        
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }
}
