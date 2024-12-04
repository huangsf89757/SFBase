//
//  SFDateFormatter.swift
//  SFBase
//
//  Created by hsf on 2024/12/4.
//

import Foundation

public class SFDateFormatter {
    private static let cache = NSCache<NSString, DateFormatter>()

    public static func formatter(for format: String) -> DateFormatter {
        if let cachedFormatter = cache.object(forKey: format as NSString) {
            return cachedFormatter
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            cache.setObject(formatter, forKey: format as NSString)
            return formatter
        }
    }
}

extension SFDateFormatter {
    public static var yyyyMMddHHmmssZ: DateFormatter {
        return Self.formatter(for: "yyyy/MM/dd HH:mm:ss Z")
    }
    public static var yyyyMMddHHmmss: DateFormatter {
        return Self.formatter(for: "yyyy/MM/dd HH:mm:ss")
    }
    public static var yyyyMMdd: DateFormatter {
        return Self.formatter(for: "yyyy/MM/dd")
    }
    public static var HHmmss: DateFormatter {
        return Self.formatter(for: "HH:mm:ss")
    }
    public static var HHmm: DateFormatter {
        return Self.formatter(for: "HH:mm")
    }
}
