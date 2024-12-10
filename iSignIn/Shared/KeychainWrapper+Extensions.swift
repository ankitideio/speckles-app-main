//
//  KeychainWrapper+Extensions.swift
//  iSignIn
//
//  Created by Dmitrij on 2022-12-28.
//

import Foundation
import SwiftKeychainWrapper

extension KeychainWrapper.Key {
    static let applicationPasscode: KeychainWrapper.Key = "iSignInApplicationPasscode"
    static let applicationBiometricsEnabled: KeychainWrapper.Key = "iSignInApplicationBiometricsEnabled"
    static let apiToken: KeychainWrapper.Key = "iSignInUserApiToken"
    static let currentYear: KeychainWrapper.Key = "year"
    static let speakerID: KeychainWrapper.Key = "speakerID"
    static let speakerName: KeychainWrapper.Key = "speakerName"
    static let locationID: KeychainWrapper.Key = "locationID"
    static let locationName: KeychainWrapper.Key = "locationName"
    static let qrCode: KeychainWrapper.Key = "locationName"

}
