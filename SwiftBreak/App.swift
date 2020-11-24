//
//  App.swift
//  SwiftBreak
//
//  Created by Luís Silva on 23/11/2020.
//

import SwiftUI

@main
struct SwiftBreakApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel())
                .frame(width: 540, height: 300, alignment: .center)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
