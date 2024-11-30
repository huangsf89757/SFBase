//
//  SFEnvironment.swift
//  SFBase
//
//  Created by hsf on 2024/11/30.
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
    public static var cur: SFEnvironment = .dev
    
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

extension SFEnvironment {
    /// 本地路径
    public var path: String {
        switch self {
        case .dev:
            return "dev"
        case .sit:
            return "sit"
        case .ppe:
            return "ppe"
        case .prd:
            return "prd"
        }
    }
}
