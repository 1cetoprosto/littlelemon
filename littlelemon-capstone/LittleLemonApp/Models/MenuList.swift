//
//  MenuList.swift
//  LittleLemonApp
//
//  Created by Leonid Kvit on 22.10.2025.
//

import Foundation
import CoreData

struct MenuList: Codable {
    let menu: [MenuItem]
    
    enum CodingKeys: String, CodingKey {
        case menu = "menu"
    }
    
    static func getMenuData(viewContext: NSManagedObjectContext) async {
        PersistenceController.shared.clear()
        guard let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let fullMenu = try JSONDecoder().decode(MenuList.self, from: data)
            for dish in fullMenu.menu {
                let newDish = Dish(context: viewContext)
                newDish.title = dish.title
                newDish.price = dish.price
                newDish.descriptionDish = dish.descriptionDish
                newDish.image = dish.image
                newDish.category = dish.category
            }
            try? viewContext.save()
        } catch {
        }
    }
}
