//
//  UserDefaults.swift
//  SwiftBreak
//
//  Created by Luís Silva on 23/11/2020.
//

import Foundation

struct UserDefaultsConfig {
    @UserDefault("automaticallyDetectIndentationStyle", defaultValue: true)
    static var automaticallyDetectIndentationStyle: Bool

    @UserDefault("displayMissingParametersError", defaultValue: true)
    static var displayMissingParametersError: Bool

    @UserDefault("displayMissingParenthesesError", defaultValue: true)
    static var displayMissingParenthesesError: Bool

    @UserDefault("displayOtherErrors", defaultValue: true)
    static var displayOtherErrors: Bool

    private init() { }

    enum Constants {
        static let userDefaultsSuiteName = "group.co.hellobit.swiftbreak"
    }

    @propertyWrapper
    struct UserDefault<T> {
        let key: String
        let defaultValue: T

        init(
            _ key: String,
            defaultValue: T
        ) {
            self.key = key
            self.defaultValue = defaultValue
        }

        var wrappedValue: T {
            get {
                return UserDefaults(suiteName: UserDefaultsConfig.Constants.userDefaultsSuiteName)?.object(forKey: key) as? T ?? defaultValue
            }
            set {
                UserDefaults(suiteName: UserDefaultsConfig.Constants.userDefaultsSuiteName)?.set(newValue, forKey: key)
            }
        }
    }
}
