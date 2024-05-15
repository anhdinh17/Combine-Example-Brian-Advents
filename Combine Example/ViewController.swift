//
//  ViewController.swift
//  Combine Example
//
//  Created by Anh Dinh on 5/14/24.
//

import UIKit
import Combine

struct Message {
    let content: String
    let author: String
}

class ViewController: UIViewController {

    @IBOutlet weak var allowMessagesSwitch: UISwitch!
    @IBOutlet weak var sendButon: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    // Use @Published to create a publisher
    // it's like SwiftUI
    @Published var canSendMessages: Bool = false
    
    // Create subscriber
    private var switchSubscriber: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.numberOfLines = 0
        allowMessagesSwitch.isOn = false
        
        setupProcessingChain()
    }
    
    func setupProcessingChain() {
        // Connect subscriber to publisher
        switchSubscriber = $canSendMessages
            .receive(
                on: DispatchQueue.main
            )
        // When canSendMessage changes value,
        // subscriber listens to the change, and assign it to
        // .isEnabled of sendButton
            .assign(
                to: \.isEnabled,
                on: sendButon
            )
        
        //MARK: - Another way to create publisher and subscriber
        // This time we use NotificationCenter as example
        
        // Create a publisher
        let messagePublisher = NotificationCenter.Publisher(center: .default, name: .newMessage)
            .map{ notification -> String? in
                // Use .map Operator to make sure that the output of publisher (String)
                // and input of subscriber (String) are the same
                //
                // Understand like this, publisher will publish a notification.
                // We will map that notification to String
                return (notification.object as? Message)?.content ?? ""
            }
        
        // Create subscriber
        // We don't use AnyCancellable this time
        // Like in Switch example, subscriber listens to the change
        // and assign value to messageLabel.text
        let messageSubscriber = Subscribers.Assign(object: messageLabel,
                                                   keyPath: \.text)
        // Connect publisher and subscriber
        messagePublisher.subscribe(messageSubscriber)
    }

    @IBAction func didSwitch(_ sender: Any) {
        // Value of candSendMessage equals switch .isOn
        // This is where canSendMessages changes and broadcasts its value
        canSendMessages = (sender as AnyObject).isOn
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let message = Message(content: "This is a message at \(Date())", author: "JD")
        // Publish the value
        // in this case, we publish the Message object
        NotificationCenter.default.post(name: .newMessage, object: message)
    }
}

extension Notification.Name {
    static let newMessage = Notification.Name("newMessage")
}
