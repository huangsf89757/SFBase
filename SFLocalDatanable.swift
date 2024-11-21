//
//  SFLocalDatanable.swift
//  SFBase
//
//  Created by hsf on 2024/11/21.
//

import Foundation

// MARK: - SFLocalDatanable
public protocol SFLocalDatanable {
    /// 序号
    /// 自增索引
    var orderL: Int? {get set}
    
    /// 唯一标识
    /// MD5
    var identifierL: String? {get set}
    
    /// 创建时间
    /// yyyy/MM/dd HH:mm:ss Z
    var createTimeL: String? {get set}
    
    /// 更新时间
    /// yyyy/MM/dd HH:mm:ss Z
    var updateTimeL: String? {get set}
}
