//
//  SFTree.swift
//  SFUI
//
//  Created by hsf on 2024/7/22.
//

import Foundation


// MARK: - Tree
public class SFTree<T> {
    // MARK: var
    /// 根节点
    public private(set) var root = SFNode<T>(value: nil)
    /// 所有显示的节点
    public private(set) var visibleNodes: [SFNode<T>] = []
    /// 刷新回调
    public var reloadCompleteBlock: (()->())?
    
    // MARK: life cycle
    public init() {}
}

// MARK: expand & shrink
extension SFTree {
    /// 展开节点
    public func expand(node: SFNode<T>) {
        guard node.isExpandable else { return }
        print("[SFTree]", "展开节点", node.level) // FIXME: log
        node.isExpanded = true
        reload()
    }
    /// 收缩节点
    public func shrink(node: SFNode<T>) {
        guard node.isExpandable else { return }
        print("[SFTree]", "收缩节点", node.level) // FIXME: log
        node.isExpanded = false
        reload()
    }
}

// MARK: reload
extension SFTree {
    /// 更新
    public func reload() {
        var queue: [SFNode<T>] = []
        queue.append(root)
        while !queue.isEmpty {
            let currentNode = queue.removeFirst()
            currentNode.tree = self
            if let parent = currentNode.parent {
                let index = parent.children.firstIndex { element in
                    currentNode === element
                } ?? 0
                currentNode.level = parent.level.appending(".\(index)")
            } else {
                currentNode.level = "0"
            }
            currentNode.isVisible = false
            print("[SFTree]", "节点", currentNode.level) // FIXME: log
            for child in currentNode.children {
                queue.append(child)
            }
        }
        
        var visibleNodes: [SFNode<T>] = []
        var stack: [SFNode<T>] = []
        stack.append(root)
        while !stack.isEmpty {
            let currentNode = stack.popLast()!
            currentNode.isVisible = true
            if currentNode !== root {
                visibleNodes.append(currentNode)
            }
            guard currentNode.isExpanded else { continue }
            for child in currentNode.children.reversed() {
                stack.append(child)
            }
        }
        self.visibleNodes = visibleNodes
        self.reloadCompleteBlock?()
    }
    
    /// 清空
    public func clear() {
        let _ = root.removeAll()
    }
}


// MARK: traverseTree
extension SFTree {
    /// 深度优先遍历（DFS）
    public func traverseTreeDFS(_ node: SFNode<T>, closure: (SFNode<T>) -> Bool) {
        var stack: [SFNode<T>] = []
        stack.append(node)
        while !stack.isEmpty {
            let currentNode = stack.popLast()!
            let canContinue = closure(currentNode)
            guard canContinue else { break }
            for child in currentNode.children.reversed() {
                stack.append(child)
            }
        }
    }
    /// 广度优先遍历（BFS）
    public func traverseTreeBFS(_ node: SFNode<T>, closure: (SFNode<T>) -> Bool) {
        var queue: [SFNode<T>] = []
        queue.append(node)
        while !queue.isEmpty {
            let currentNode = queue.removeFirst()
            let canContinue = closure(currentNode)
            guard canContinue else { break }
            for child in currentNode.children {
                queue.append(child)
            }
        }
    }
}
