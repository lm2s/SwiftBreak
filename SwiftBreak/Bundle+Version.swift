//
//  Bundle+Version.swift
//  SwiftBreak
//
//  Created by Luís Silva on 24/11/2020.
//

import Foundation

extension Bundle {
    var releaseVersion: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
