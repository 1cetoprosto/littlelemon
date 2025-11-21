//
//  UserProfile.swift
//  LittleLemonApp
//
//  Created by Leonid Kvit on 19.10.2025.
//

import PhotosUI
import SwiftUI
import UIKit

struct UserProfile: View {
    enum Route: Hashable { case onboarding }

    @StateObject private var viewModel = ViewModel()

    @Environment(\.dismiss) private var dismiss

    @State private var orderStatuses = true
    @State private var passwordChanges = true
    @State private var specialOffers = true
    @State private var newsletter = true

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phoneNumber = ""

    @State private var avatarImageData: Data? = nil
    @State private var selectedItem: PhotosPickerItem? = nil

    @State private var isLoggedOut = false
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 5) {
                    VStack {
                        Text("Avatar")
                            .onboardingTextStyle()
                        HStack(spacing: 0) {
                            Group {
                                if let data = avatarImageData, let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                } else {
                                    Image("profile-image-placeholder")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                            }
                            .frame(maxHeight: 75)
                            .clipShape(Circle())
                            .padding(.trailing)
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                Text("Change")
                            }
                            .buttonStyle(ButtonStylePrimaryColor1())
                            Button("Remove") {
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                                avatarImageData = nil
                                UserDefaults.standard.removeObject(forKey: kAvatarImageData)
                            }
                            .buttonStyle(ButtonStylePrimaryColorReverse())
                            Spacer()
                        }
                    }
                    
                    VStack {
                        Text("First name")
                            .onboardingTextStyle()
                        TextField("First Name", text: $firstName)
                    }
                    
                    VStack {
                        Text("Last name")
                            .onboardingTextStyle()
                        TextField("Last Name", text: $lastName)
                        
                    }
                    
                    VStack {
                        Text("E-mail")
                            .onboardingTextStyle()
                        TextField("E-mail", text: $email)
                            .keyboardType(.emailAddress)
                    }
                    
                    VStack {
                        Text("Phone number")
                            .onboardingTextStyle()
                        TextField("Phone number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .onChange(of: phoneNumber) { newValue in
                                var digits = newValue.filter { $0.isNumber }
                                if newValue.first == "+" {
                                    phoneNumber = "+" + digits
                                } else {
                                    phoneNumber = digits
                                }
                            }
                    }
                }
                .textFieldStyle(.roundedBorder)
                .disableAutocorrection(true)
                .padding()
                
                Text("Email notifications")
                    .font(.regularText())
                    .foregroundColor(.primaryColor1)
                VStack {
                    Toggle("Order statuses", isOn: $orderStatuses)
                    Toggle("Password changes", isOn: $passwordChanges)
                    Toggle("Special offers", isOn: $specialOffers)
                    Toggle("Newsletter", isOn: $newsletter)
                }
                .padding()
                .font(Font.leadText())
                .foregroundColor(.primaryColor1)
                
                Button("Log out") {
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                    UserDefaults.standard.set("", forKey: kFirstName)
                    UserDefaults.standard.set("", forKey: kLastName)
                    UserDefaults.standard.set("", forKey: kEmail)
                    UserDefaults.standard.set("", forKey: kPhoneNumber)
                    UserDefaults.standard.set(false, forKey: kOrderStatuses)
                    UserDefaults.standard.set(false, forKey: kPasswordChanges)
                    UserDefaults.standard.set(false, forKey: kSpecialOffers)
                    UserDefaults.standard.set(false, forKey: kNewsletter)
                    isLoggedOut = true
                }
                .buttonStyle(ButtonStyleYellowColorWide())
                Spacer(minLength: 20)
                HStack {
                    Button("Discard Changes") {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        firstName = viewModel.firstName
                        lastName = viewModel.lastName
                        email = viewModel.email
                        phoneNumber = viewModel.phoneNumber
                        
                        orderStatuses = viewModel.orderStatuses
                        passwordChanges = viewModel.passwordChanges
                        specialOffers = viewModel.specialOffers
                        newsletter = viewModel.newsletter
                    }
                    .buttonStyle(ButtonStylePrimaryColorReverse())
                    Button("Save changes") {
                        if viewModel.validateUserInput(
                            firstName: firstName, lastName: lastName, email: email, phoneNumber: phoneNumber)
                        {
                            UserDefaults.standard.set(firstName, forKey: kFirstName)
                            UserDefaults.standard.set(lastName, forKey: kLastName)
                            UserDefaults.standard.set(email, forKey: kEmail)
                            UserDefaults.standard.set(phoneNumber, forKey: kPhoneNumber)
                            UserDefaults.standard.set(orderStatuses, forKey: kOrderStatuses)
                            UserDefaults.standard.set(passwordChanges, forKey: kPasswordChanges)
                            UserDefaults.standard.set(specialOffers, forKey: kSpecialOffers)
                            UserDefaults.standard.set(newsletter, forKey: kNewsletter)
                            viewModel.syncFromDefaults()
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                            dismiss()
                        }
                    }
                    .buttonStyle(ButtonStylePrimaryColor1())
                }
                if viewModel.errorMessageShow {
                    withAnimation {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                    }
                }
            }
            .onAppear {
                viewModel.syncFromDefaults()
                firstName = viewModel.firstName
                lastName = viewModel.lastName
                email = viewModel.email
                phoneNumber = viewModel.phoneNumber
                
                orderStatuses = viewModel.orderStatuses
                passwordChanges = viewModel.passwordChanges
                specialOffers = viewModel.specialOffers
                newsletter = viewModel.newsletter
                avatarImageData = UserDefaults.standard.data(forKey: kAvatarImageData)
            }
            .onChange(of: selectedItem) { newItem in
                guard let newItem = newItem else { return }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        avatarImageData = data
                        UserDefaults.standard.set(data, forKey: kAvatarImageData)
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                    }
                }
            }
            .navigationTitle(Text("Personal information"))
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationDestination(for: Route.self) { route in
            switch route {
            case .onboarding:
                Onboarding()
            }
        }
        .onChange(of: isLoggedOut) { newValue in
            if newValue {
                path.append(Route.onboarding)
            }
        }
    }
}

#Preview {
    UserProfile()
}
