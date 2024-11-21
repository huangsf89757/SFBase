//
//  SFRemoteDatanable.swift
//  SFBase
//
//  Created by hsf on 2024/11/20.
//

import Foundation

public protocol SFRemoteDatanable {
    /// 序号
    /// 自增索引
    var orderR: Int {get set}
    
    /// 唯一标识
    /// MD5
    var idR: String {get set}
    
    /// 创建时间
    /// yyyy/MM/dd HH:mm:ss Z
    var createTimeR: String {get set}
    
    /// 更新时间
    /// yyyy/MM/dd HH:mm:ss Z
    var updateTimeR: String? {get set}
}
