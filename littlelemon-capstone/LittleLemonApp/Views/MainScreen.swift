//
//  MainScreen.swift
//  LittleLemonApp
//
//  Created by Leonid Kvit on 21.10.2025.
//

import SwiftUI

struct MainScreen: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationStack {
            VStack {
                Header()
                Menu()
            }
        }
    }
}

#Preview {
    MainScreen().environment(
        \.managedObjectContext, PersistenceController.shared.container.viewContext)
}
