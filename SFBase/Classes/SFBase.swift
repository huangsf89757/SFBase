//
//  SFBase.swift
//  SFBase
//
//  Created by hsf on 2024/7/12.
//

import Foundation

// MARK: - SFEnvironment
public enum SFEnvironment: CaseIterable {
    case dev    // 开发环境
    case sit    // 测试环境
    case ppe    // 预发布环境
    case prd    // 生产环境
}

extension SFEnvironment {
    /// 当前环境
    public static var cur: SFEnvironment = .prd
    
    /// 当前环境是否未Debug环境
    public static var isDebug: Bool {
        switch cur {
        case .dev, .ppe:
            return true
        default:
            return false
        }
    }
    
    /// 当前环境是否未Release环境
    public static var isRelease: Bool {
        switch cur {
        case .dev, .ppe:
            return false
        default:
            return true
        }
    }
}


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
