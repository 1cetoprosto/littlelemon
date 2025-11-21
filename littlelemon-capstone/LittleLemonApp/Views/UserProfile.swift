//
//  UserProfile.swift
//  LittleLemonApp
//
//  Created by Leonid Kvit on 19.10.2025.
//

import SwiftUI

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
              Image("profile-image-placeholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 75)
                .clipShape(Circle())
                .padding(.trailing)
              Button("Change") {}
                .buttonStyle(ButtonStylePrimaryColor1())
              Button("Remove") {}
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
            firstName = viewModel.firstName
            lastName = viewModel.lastName
            email = viewModel.email
            phoneNumber = viewModel.phoneNumber

            orderStatuses = viewModel.orderStatuses
            passwordChanges = viewModel.passwordChanges
            specialOffers = viewModel.specialOffers
            newsletter = viewModel.newsletter
            dismiss()
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
        firstName = viewModel.firstName
        lastName = viewModel.lastName
        email = viewModel.email
        phoneNumber = viewModel.phoneNumber

        orderStatuses = viewModel.orderStatuses
        passwordChanges = viewModel.passwordChanges
        specialOffers = viewModel.specialOffers
        newsletter = viewModel.newsletter
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
