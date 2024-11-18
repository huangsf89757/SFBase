//
//  SFUserDefault.swift
//  SFBase
//
//  Created by hsf on 2024/7/18.
//

import Foundation


// MARK: - SFUserDefault
public class SFUserDefault: UserDefaults {}


// MARK: - 版本记录
extension SFUserDefault {
    private static let key_versionRecords = "SF_KEY_versionRecords"
    
    /// 版本记录
    public static var versionRecords: [Date: [String: String]] {
        get {
            standard.dictionary(forKey: key_versionRecords) as? [Date: [String: String]] ?? [:]
        }
        set {
            standard.setValue(newValue, forKey: key_versionRecords)
        }
    }
    
    /// 获取上一个版本记录
    public static func getPreviousVersionRecord() -> (Date, [String: String])? {
        let sortedArr =  versionRecords.sorted { element1, element2 in
            return element1.key < element2.key
        }
        let count = sortedArr.count
        if count > 1 {
            let record = sortedArr[count-2]
            return (record.key, record.value)
        } else {
            return nil
        }
    }
    
    /// 同步当前版本记录
    public static func syncVersionRecord() {
        var versionRecords = self.versionRecords
        let date = Date()
        let version = SFApp.version
        let build = SFApp.build
        var record = [String: String]()
        record["version"] = version
        record["build"] = build
        versionRecords[date] = record
        self.versionRecords = versionRecords
    }
}
