//
//  SFDeveloper.swift
//  SFBase
//
//  Created by hsf on 2024/7/12.
//

import Foundation

// MARK: - SFDeveloper
public struct SFDeveloper: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension SFDeveloper {
    public static let hsf = Self(rawValue: 1 << 0)
}
