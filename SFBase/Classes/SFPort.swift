//
//  SFPort.swift
//  SFBase
//
//  Created by hsf on 2024/11/30.
//

import Foundation

// MARK: - SFPort
public enum SFPort: CaseIterable {
    case none
    case client    // 客户端
    case server    // 服务端
}

extension SFPort {
    /// 本地路径
    public var path: String {
        switch self {
        case .none:
            return "none"
        case .client:
            return "client"
        case .server:
            return "server"
        }
    }
}
