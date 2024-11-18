//
//  SFThrottler.swift
//  SFUI
//
//  Created by hsf on 2024/8/5.
//

import Foundation

// MARK: - SFThrottler（节流）
public class SFThrottler {
    public private(set) var queue: DispatchQueue
    public private(set) var interval: TimeInterval
    private var lastFireTime: DispatchTime = .now()
    private var workItem: DispatchWorkItem?

    public init(queue: DispatchQueue = .main, interval: TimeInterval = 1.0) {
        self.queue = queue
        self.interval = interval
    }

    public func throttle(_ action: @escaping () -> Void) {
        // 取消之前的任务（如果存在）
        workItem?.cancel()

        // 检查是否已经过了节流间隔
        let now = DispatchTime.now()
        let deadline: DispatchTime
        let elapsedTime = now.uptimeNanoseconds - lastFireTime.uptimeNanoseconds
        let elapsedTimeInSeconds = Double(elapsedTime) / 1_000_000_000 // 转换为秒

        if elapsedTimeInSeconds > interval {
            // 如果已经过了间隔，立即执行
            deadline = now
        } else {
            // 如果还没过间隔，设置在间隔结束时执行
            deadline = DispatchTime.now() + interval - elapsedTimeInSeconds
        }

        // 创建新的任务
        let item = DispatchWorkItem { [weak self] in
            action()
            self?.lastFireTime = .now()
        }
        self.workItem = item

        // 在指定时间执行任务
        queue.asyncAfter(deadline: deadline, execute: item)
    }

    public func cancel() {
        workItem?.cancel()
    }
}
