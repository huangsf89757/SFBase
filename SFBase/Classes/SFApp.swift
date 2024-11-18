//
//  SFApp.swift
//  SFBase
//
//  Created by hsf on 2024/7/18.
//

import Foundation

// MARK: - SFApp
public class SFApp {
    // MARK: singleton
    private static let shared = SFApp()
    private init () {
        addObserverOfAppState()
    }
    
    
    // MARK: state
    private var state: SFAppState = .unknown
    

}

// MARK: - state
public enum SFAppState {
    case unknown
    case didEnterBackground
    case willEnterForeground
    case didFinishLaunching
    case didBecomeActive
    case willResignActive
    case didReceiveMemoryWarning
    case willTerminate
    
    /// 描述
    public var text: String {
        switch self {
        case .unknown:
            return "未知"
        case .didEnterBackground:
            return "后台"
        case .willEnterForeground:
            return "将前"
        case .didFinishLaunching:
            return "启动"
        case .didBecomeActive:
            return "已前"
        case .willResignActive:
            return "将后"
        case .didReceiveMemoryWarning:
            return "内存"
        case .willTerminate:
            return "挂起"
        }
    }
    
    /// 是否处于前台
    public var isForeground: Bool {
        return self == .didBecomeActive
    }
    
    /// 是否处于后台
    public var isBackground: Bool {
        return self == .didEnterBackground
    }
}
extension SFApp {
    public static var state: SFAppState {
        SFApp.shared.state
    }
    
    private func addObserverOfAppState() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackgroundNotification(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForegroundNotification(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didFinishLaunchingNotification(_:)), name: UIApplication.didFinishLaunchingNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActiveNotification(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActiveNotification(_:)), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMemoryWarningNotification(_:)), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willTerminateNotification(_:)), name: UIApplication.willTerminateNotification, object: nil)
    }
    
    @objc
    private func didEnterBackgroundNotification(_ notify: Notification) { state = .didEnterBackground }
    
    @objc
    private func willEnterForegroundNotification(_ notify: Notification) { state = .willEnterForeground }
    
    @objc
    private func didFinishLaunchingNotification(_ notify: Notification) { state = .didFinishLaunching }
    
    @objc
    private func didBecomeActiveNotification(_ notify: Notification) { state = .didBecomeActive }
    
    @objc
    private func willResignActiveNotification(_ notify: Notification) { state = .willResignActive }
    
    @objc
    private func didReceiveMemoryWarningNotification(_ notify: Notification) { state = .didReceiveMemoryWarning }
    
    @objc
    private func willTerminateNotification(_ notify: Notification) { state = .willTerminate }
}


// MARK: - info
extension SFApp {
    private static var _localizedInfo: [String: Any]?
    private static var _info: [String: Any]?
    /// App localizedInfo
    private static var localizedInfo: [String: Any] {
        if let _localizedInfo = _localizedInfo {
            return _localizedInfo
        }
        let info = Bundle.main.localizedInfoDictionary ?? [:]
        _localizedInfo = info
        return info
    }
    /// App Info
    private static var info: [String: Any] {
        if let _info = _info {
            return _info
        }
        let info = Bundle.main.infoDictionary ?? [:]
        _info = info
        return info
    }
    
    /// getAppInfo
    private static func getAppInfo(key: String) -> Any? {
        if let name = info[key] as? Any {
            return name
        }
        return nil
    }
    
    /// App 名称
    public static var name: String {
        return getAppInfo(key: "CFBundleDisplayName") as? String ?? ""
    }
    
    /// App 版本号
    public static var version: String {
        return getAppInfo(key: "CFBundleShortVersionString") as? String ?? ""
    }
    
    /// App BundleId
    public static var bundle: String {
        return getAppInfo(key: "CFBundleIdentifier") as? String ?? ""
    }
    
    /// App Build号
    public static var build: String {
        return getAppInfo(key: "CFBundleVersion") as? String ?? ""
    }
    
    /// App logo
    public static var logo: UIImage? {
        guard let icons = getAppInfo(key: "CFBundleIcons") as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? NSArray,
              let lastIcon = iconFiles.lastObject as? String,
              let icon = UIImage(named: lastIcon)
        else { return nil }
        return icon
    }
}


// MARK: - windowScene
extension SFApp {
    @available(iOS 13, *)
    private static var _keyWindowScene: UIWindowScene?
    
    @available(iOS 13, *)
    public static func keyWindowScene() -> UIWindowScene? {
        if let _keyWindowScene = _keyWindowScene {
            return _keyWindowScene
        }
        let windowScene = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first as? UIWindowScene
        _keyWindowScene = windowScene
        return windowScene
    }
}

// MARK: - window
extension SFApp {
    private static var _keyWindow: UIWindow?
    
    public static func setKeyWindow(_ keyWindow: UIWindow? = nil) {
        _keyWindow = keyWindow
    }
    
    public static func keyWindow() -> UIWindow? {
        if let window = _keyWindow {
            return window
        }
        var window: UIWindow?
        if #available(iOS 13.0, *) {
            window = keyWindowScene()?.windows.last
        } else {
            window = UIApplication.shared.keyWindow
        }
        _keyWindow = window
        return window
    }
}

// MARK: - topVc
extension SFApp {
    /// 获取当前显示的控制器
    public static func topVc(from vc: UIViewController? = nil) -> UIViewController? {
        var rootVc = vc
        if rootVc == nil {
            rootVc = keyWindow()?.rootViewController
        }
        return _topVc(from: rootVc)
    }
    
    private static func _topVc(from vc: UIViewController? = nil) -> UIViewController? {
        if let navC = vc as? UINavigationController,
            let visibleVc = navC.visibleViewController {
            return topVc(from: visibleVc)
        }
        if let tabC = vc as? UITabBarController,
           let selectedVc = tabC.selectedViewController {
            return topVc(from: selectedVc)
        }
        if let presentedVc = vc?.presentedViewController {
            return topVc(from: presentedVc)
        }
        return vc
    }
}

// MARK: - landscape
extension SFApp {
    public static var isPortrait: Bool {
        if #available(iOS 16.0, *), let windowScene = keyWindowScene() {
            return windowScene.interfaceOrientation.isPortrait
        } else {
            return UIDevice.current.orientation.isPortrait
        }
    }
    
    public static var isLandscape: Bool {
        if #available(iOS 16.0, *), let windowScene = keyWindowScene() {
            return windowScene.interfaceOrientation.isLandscape
        } else {
            return UIDevice.current.orientation.isLandscape
        }
    }
}

// MARK: - safeAreaInsets
extension SFApp {
    private static var _safeAreaInsets: UIEdgeInsets?
    
    /// safeAreaInsets
    public static func safeAreaInsets() -> UIEdgeInsets {
        if let insert = _safeAreaInsets {
            return insert
        }
        var insert = UIEdgeInsets.zero
        if let window = keyWindow(),
           #available(iOS 11.0, *) {
            insert = window.safeAreaInsets;
        } else {
            insert = UIEdgeInsets.zero;
        }
        _safeAreaInsets = insert
        return insert
    }
}

// MARK: - size
extension SFApp {
    private static var _statusBarHeight: CGFloat?
    public static func statusBarHeight() -> CGFloat {
        if let _statusBarHeight = _statusBarHeight {
            return _statusBarHeight
        }
        var height: CGFloat = 0
        if #available(iOS 13.0, *),
           let manager = UIApplication.shared.windows.first?.windowScene?.statusBarManager {
            height = manager.statusBarFrame.size.height
        } else {
            height = UIApplication.shared.statusBarFrame.size.height
        }
        _statusBarHeight = height
        return height
    }
    
    
    private static var _screenSizePortrait: CGSize?
    public static func screenSizePortrait() -> CGSize {
        if let _screenSizePortrait = _screenSizePortrait {
            return _screenSizePortrait
        }
        var size = UIScreen.main.bounds.size
        if (size.height < size.width) {
            let tmp = size.height
            size.height = size.width
            size.width = tmp
        }
        _screenSizePortrait = size
        return size
    }
    
    private static var _screenSizeLandscape: CGSize?
    public static func screenSizeLandscape() -> CGSize {
        if let _screenSizeLandscape = _screenSizeLandscape {
            return _screenSizeLandscape
        }
        var size = UIScreen.main.bounds.size
        if (size.height > size.width) {
            let tmp = size.height
            size.height = size.width
            size.width = tmp
        }
        _screenSizeLandscape = size
        return size
    }
    
    public static func screenSize() -> CGSize {
        if isPortrait {
            return screenSizePortrait()
        } else {
            return screenSizeLandscape()
        }
    }
    
    
    public static func screenWidthPortrait() -> CGFloat {
        return screenSizePortrait().width
    }
    
    public static func screenWidthLandscape() -> CGFloat {
        return screenSizeLandscape().width
    }
    
    public static func screenWidth() -> CGFloat {
        if isPortrait {
            return screenWidthPortrait()
        } else {
            return screenWidthLandscape()
        }
    }
    
    
    public static func screenHeightPortrait() -> CGFloat {
        return screenSizePortrait().height
    }
    
    public static func screenHeightLandscape() -> CGFloat {
        return screenSizeLandscape().height
    }
    
    public static func screenHeight() -> CGFloat {
        if isPortrait {
            return screenHeightPortrait()
        } else {
            return screenHeightLandscape()
        }
    }
    
    
    public static func navBarHeight() -> CGFloat {
        return 44.0
    }
    
    
    public static func tabBarHeight() -> CGFloat {
        return 49.0
    }
    
}


