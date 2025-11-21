//
//  HeaderBar.swift
//  LittleLemonApp
//
//  Created by Leonid Kvit on 19.10.2025.
//

import SwiftUI

struct Header: View {
    @AppStorage(kIsLoggedIn) private var isLoggedIn = false
    
    var body: some View {
        VStack {
            ZStack {
                Image("logo")
                HStack {
                    Spacer()
                    if isLoggedIn {
                        NavigationLink(destination: UserProfile()) {
                            Image("profile-image-placeholder")
                                .resizable()
                                .aspectRatio( contentMode: .fit)
                                .frame(maxHeight: 50)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                }
            }
        }
        .frame(maxHeight: 60)
        .padding(.bottom)
    }
}

#Preview {
    Header()
}
