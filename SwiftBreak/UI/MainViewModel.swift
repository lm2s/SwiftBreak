//
//  MainViewModel.swift
//  SwiftBreak
//
//  Created by Luís Silva on 24/11/2020.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    @Published var automaticallyDetectIndentationStyle: Bool
    @Published var displayMissingParametersError: Bool
    @Published var displayMissingParenthesesError: Bool
    @Published var displayOtherErrors: Bool

    var appVersion: String {
        return Bundle.main.releaseVersion ?? "1.0"
    }

    private var cancellables: Set<AnyCancellable> = Set()

    init() {
        automaticallyDetectIndentationStyle = UserDefaultsConfig.automaticallyDetectIndentationStyle
        displayMissingParametersError = UserDefaultsConfig.displayMissingParametersError
        displayMissingParenthesesError = UserDefaultsConfig.displayMissingParenthesesError
        displayOtherErrors = UserDefaultsConfig.displayOtherErrors

        $automaticallyDetectIndentationStyle.sink { (value) in
            UserDefaultsConfig.automaticallyDetectIndentationStyle = value
        }.store(in: &cancellables)

        $displayMissingParametersError.sink { (value) in
            UserDefaultsConfig.displayMissingParametersError = value
        }.store(in: &cancellables)

        $displayMissingParenthesesError.sink { (value) in
            UserDefaultsConfig.displayMissingParenthesesError = value
        }.store(in: &cancellables)

        $displayOtherErrors.sink { (value) in
            UserDefaultsConfig.displayOtherErrors = value
        }.store(in: &cancellables)
    }
}
