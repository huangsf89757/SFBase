//
//  SFDebouncer.swift
//  SFUI
//
//  Created by hsf on 2024/8/5.
//

import Foundation

// MARK: - SFDebouncer（防抖）
/// 防抖处理类
public final class SFDebouncer<T> {
    // 防抖时间间隔
    private var delay: TimeInterval
    // 执行任务的队列
    private var queue: DispatchQueue
    // 当前待执行的任务
    private var workItem: DispatchWorkItem?
    // 用于管理状态的队列
    private var stateQueue: DispatchQueue
    // 当前任务的状态
    private var state: State
    
    // 任务状态的枚举
    private enum State {
        case idle               // 空闲状态
        case scheduled(UUID)    // 已调度了一个任务，等待执行
        case executing          // 当前有任务正在执行
    }

    /// 初始化防抖处理类
    /// - Parameters:
    ///   - delay: 防抖延迟时间（秒）
    ///   - queue: 执行防抖任务的队列，默认为主队列
    init(delay: TimeInterval, queue: DispatchQueue = .main) {
        self.delay = delay
        self.queue = queue
        self.stateQueue = DispatchQueue(label: "debouncer.state", attributes: .concurrent)
        self.state = .idle
    }

    /// 执行防抖任务
    /// - Parameter action: 需要执行的任务闭包
    func debounce(action: @escaping (T) -> Void) -> (T) -> Void {
        return { [weak self] input in
            guard let self = self else { return }

            let identifier = UUID()
            
            // 使用屏障（barrier）确保对状态的安全修改
            self.stateQueue.async(flags: .barrier) {
                // 取消前一个任务
                self.workItem?.cancel()
                // 更新状态为已调度，带有唯一标识符
                self.state = .scheduled(identifier)
                
                // 创建一个新的任务项
                let workItem = DispatchWorkItem { [weak self] in
                    guard let self = self else { return }
                    
                    // 执行任务前，再次确认状态，确保是最新的任务
                    self.stateQueue.async(flags: .barrier) {
                        if case .scheduled(let id) = self.state, id == identifier {
                            self.state = .executing
                        }
                    }
                    
                    // 执行传入的任务
                    action(input)
                    
                    // 更新状态为空闲
                    self.stateQueue.async(flags: .barrier) {
                        self.state = .idle
                    }
                }
                
                // 保存当前任务项
                self.workItem = workItem
                // 在指定延迟后执行任务
                self.queue.asyncAfter(deadline: .now() + self.delay, execute: workItem)
            }
        }
    }
}

//// 示例用法
//class ExampleViewController: UIViewController {
//    // 创建一个防抖处理实例，延迟时间为0.5秒
//    private let clickDebouncer = SFDebouncer<Void>(delay: 0.5)
//    private let inputDebouncer = SFDebouncer<String>(delay: 0.3)
//    private let scrollDebouncer = SFDebouncer<Void>(delay: 0.2)
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupButton()
//        setupTextField()
//        setupScrollView()
//    }
//    
//    // 设置按钮
//    private func setupButton() {
//        let button = UIButton(type: .system)
//        button.setTitle("Click Me", for: .normal)
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//        view.addSubview(button)
//    }
//    
//    // 设置文本输入框
//    private func setupTextField() {
//        let textField = UITextField()
//        textField.borderStyle = .roundedRect
//        textField.placeholder = "Type here..."
//        textField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .editingChanged)
//    }
//
//    // 设置滚动视图
//    private func setupScrollView() {
//        let scrollView = UIScrollView()
//        scrollView.delegate = self
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(scrollView)
//    }
//
//    // 按钮点击事件处理
//    @objc private func buttonTapped() {
//        // 使用防抖处理点击事件
//        let debouncedAction = clickDebouncer.debounce { _ in
//            print("Button tapped with debounce")
//            // 这里可以放置需要执行的代码
//        }
//        debouncedAction(())
//    }
//    
//    // 文本输入框内容变化事件处理
//    @objc private func textFieldChanged(_ textField: UITextField) {
//        // 使用防抖处理文本输入事件
//        let debouncedAction = inputDebouncer.debounce { input in
//            print("Text field value changed with debounce: \(input)")
//            // 这里可以放置需要执行的代码
//        }
//        debouncedAction(textField.text ?? "")
//    }
//}
//
//// 扩展 ExampleViewController 实现 UIScrollViewDelegate
//extension ExampleViewController: UIScrollViewDelegate {
//    // 滚动视图滚动事件处理
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        // 使用防抖处理滚动事件
//        let debouncedAction = scrollDebouncer.debounce { _ in
//            print("Scroll view did scroll with debounce")
//            // 这里可以放置需要执行的代码
//        }
//        debouncedAction(())
//    }
//}

