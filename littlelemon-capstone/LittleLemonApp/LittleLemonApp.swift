//
//  LittleLemonAppApp.swift
//  LittleLemonApp
//
//  Created by Leonid Kvit on 16.10.2025.
//

import SwiftUI

@main
struct LittleLemonApp: App {
    let persistenceController = PersistenceController.shared
    @AppStorage(kIsLoggedIn) private var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                Home().environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                Onboarding().environment(
                    \.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
