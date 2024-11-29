//
//  SFBaseLib.swift
//  SFBase
//
//  Created by hsf on 2024/11/23.
//

import Foundation
// Basic
import SFExtension

// MARK: - SFBaseLib
public class SFBaseLib: SFLib {
    public static var bundle: Bundle? = Bundle.sf.bundle(cls: SFBaseLib.self, resource: nil)
}
