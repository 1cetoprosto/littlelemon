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
    
    var body: some Scene {
        WindowGroup {
            Onboarding().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
