//
//  PennyBankApp.swift
//  PennyBank
//
//  Created by Jake Woodall on 12/27/25.
//

import SwiftUI

@main
struct PennyBankApp: App {
    @StateObject private var appEnvironment = AppEnvironment.live

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appEnvironment)
        }
    }
}
