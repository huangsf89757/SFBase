//
//  SFRemoteDatanable.swift
//  SFBase
//
//  Created by hsf on 2024/11/21.
//

import Foundation

// MARK: - SFRemoteDatanable
public protocol SFRemoteDatanable {
    /// 序号
    /// 自增索引
    var orderR: Int? {get set}
    
    /// 唯一标识
    /// MD5
    var identifierR: String? {get set}
    
    /// 创建时间
    /// yyyy/MM/dd HH:mm:ss Z
    var createTimeR: String? {get set}
    
    /// 更新时间
    /// yyyy/MM/dd HH:mm:ss Z
    var updateTimeR: String? {get set}
}
