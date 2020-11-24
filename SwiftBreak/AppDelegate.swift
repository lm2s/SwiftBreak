//
//  AppDelegate.swift
//  SwiftBreak
//
//  Created by Luís Silva on 24/11/2020.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {
        let mainView = MainView(viewModel: MainViewModel())

        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 540, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered, defer: false
        )

        window.center()
        window.setFrameAutosaveName("SwiftBreak")
        window.contentView = NSHostingView(rootView: mainView)
        window.isReleasedWhenClosed = true
        window.makeKeyAndOrderFront(nil)

    }

    @objc
    private func quit(_ sender: Any) {
        NSApplication.shared.terminate(sender)
    }
}
