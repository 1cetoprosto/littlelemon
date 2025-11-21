//
//  Home.swift
//  LittleLemonApp
//
//  Created by Leonid Kvit on 19.10.2025.
//

import SwiftUI

struct Home: View {
  let persistenceController = PersistenceController.shared

  var body: some View {
    TabView {
      NavigationStack {
        Menu()
          .environment(\.managedObjectContext, persistenceController.container.viewContext)
      }
      .tag(0)
      .tabItem {
        Label("Menu", systemImage: "list.dash")
      }
      NavigationStack {
        UserProfile()
      }
      .tag(1)
      .tabItem {
        Label("Profile", systemImage: "square.and.pencil")
      }
    }
  }
}

#Preview {
  Home().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
