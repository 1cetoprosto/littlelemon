//
//  HeaderBar.swift
//  LittleLemonApp
//
//  Created by Leonid Kvit on 19.10.2025.
//

import SwiftUI

struct Header: View {
    @AppStorage(kIsLoggedIn) private var isLoggedIn = false
    @State private var avatarImageData: Data? = nil
    
    var body: some View {
        VStack {
            ZStack {
                Image("logo")
                HStack {
                    Spacer()
                    if isLoggedIn {
                        NavigationLink(destination: UserProfile()) {
                            Group {
                                if let data = avatarImageData, let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } else {
                                    Image("profile-image-placeholder")
                                        .resizable()
                                        .aspectRatio( contentMode: .fit)
                                }
                            }
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
        .onAppear {
            avatarImageData = UserDefaults.standard.data(forKey: kAvatarImageData)
        }
    }
}

#Preview {
    Header()
}
