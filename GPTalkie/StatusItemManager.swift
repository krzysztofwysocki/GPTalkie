//
//  StatusItemManager.swift
//  GPTalkie
//
//  Created by kwysocki on 15/03/2023.
//

import Foundation
import SwiftUI
import AppKit

class StatusItemManager: ObservableObject {
    private var statusItem: NSStatusItem?



    func setupStatusItem() {
            statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
            
            if let button = statusItem?.button {
                button.title = "YourTitle"
                // Configure other button properties as needed
            }
            
            // Add any necessary menu items, target, and action
        }
}
