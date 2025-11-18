//
//  littlelemon_capstoneApp.swift
//  littlelemon-capstone
//
//  Created by Леонід Квіт on 18.11.2025.
//

import SwiftUI

@main
struct littlelemon_capstoneApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
