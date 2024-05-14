//
//  ViewController.swift
//  Combine Example
//
//  Created by Anh Dinh on 5/14/24.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var allowMessagesSwitch: UISwitch!
    @IBOutlet weak var sendButon: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    // Use @Published to create a publisher
    // it's like SwiftUI
    @Published var canSendMessages: Bool = false
    
    private var switchSubscriber: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProcessingChain()
    }
    
    func setupProcessingChain() {
        // Connect subscriber to publisher
        switchSubscriber = $canSendMessages
            .receive(
                on: DispatchQueue.main
            )
        // When canSendMessage changes value,
        // subscriber listes to the change, and assign it to
        // .isEnabled of sendButton
            .assign(
                to: \.isEnabled,
                on: sendButon
            )
    }

    @IBAction func didSwitch(_ sender: Any) {
        // Value of candSendMessage equals switch .isOn
        canSendMessages = (sender as AnyObject).isOn
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
    }
}

