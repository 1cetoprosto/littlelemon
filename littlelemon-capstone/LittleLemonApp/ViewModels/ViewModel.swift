//
//  viewModel.swift
//  LittleLemonApp
//
//  Created by Leonid Kvit on 25.10.2025.
//

import Combine
import Foundation

public let kFirstName = "first name key"
public let kLastName = "last name key"
public let kEmail = "e-mail key"
public let kIsLoggedIn = "kIsLoggedIn"
public let kPhoneNumber = "phone number key"
public let kAvatarImageData = "avatar image data key"

public let kOrderStatuses = "order statuses key"
public let kPasswordChanges = "password changes key"
public let kSpecialOffers = "special offers key"
public let kNewsletter = "news letter key"

class ViewModel: ObservableObject {
    
    @Published var firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
    @Published var lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
    @Published var email = UserDefaults.standard.string(forKey: kEmail) ?? ""
    @Published var phoneNumber = UserDefaults.standard.string(forKey: kPhoneNumber) ?? ""
    
    @Published var orderStatuses = UserDefaults.standard.bool(forKey: kOrderStatuses)
    @Published var passwordChanges = UserDefaults.standard.bool(forKey: kPasswordChanges)
    @Published var specialOffers = UserDefaults.standard.bool(forKey: kSpecialOffers)
    @Published var newsletter = UserDefaults.standard.bool(forKey: kNewsletter)
    
    @Published var errorMessageShow = false
    @Published var errorMessage = ""
    
    @Published var searchText = ""
    
    func validateUserInput(firstName: String, lastName: String, email: String, phoneNumber: String)
        -> Bool
    {
        guard !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty else {
            errorMessage = "All fields are required"
            errorMessageShow = true
            return false
        }
        
        guard email.contains("@") else {
            errorMessage = "Invalid email address"
            errorMessageShow = true
            return false
        }
        
        let emailParts = email.split(separator: "@")
        
        guard emailParts.count == 2 else {
            errorMessage = "Invalid email address"
            errorMessageShow = true
            return false
        }
        
        guard emailParts[1].contains(".") else {
            errorMessage = "Invalid email address"
            errorMessageShow = true
            return false
        }
        let isDigitsOnly = phoneNumber.allSatisfy({ $0.isNumber })
        let isPlusDigits = phoneNumber.first == "+" && phoneNumber.dropFirst().allSatisfy({ $0.isNumber })
        guard phoneNumber.isEmpty || isDigitsOnly || isPlusDigits else {
            errorMessage = "Invalid phone number format."
            errorMessageShow = true
            return false
        }
        errorMessageShow = false
        errorMessage = ""
        return true
    }
    
    func syncFromDefaults() {
        firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
        lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
        email = UserDefaults.standard.string(forKey: kEmail) ?? ""
        phoneNumber = UserDefaults.standard.string(forKey: kPhoneNumber) ?? ""
        orderStatuses = UserDefaults.standard.bool(forKey: kOrderStatuses)
        passwordChanges = UserDefaults.standard.bool(forKey: kPasswordChanges)
        specialOffers = UserDefaults.standard.bool(forKey: kSpecialOffers)
        newsletter = UserDefaults.standard.bool(forKey: kNewsletter)
    }
}
