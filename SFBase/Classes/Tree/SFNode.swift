//
//  SFNode.swift
//  SFUI
//
//  Created by hsf on 2024/7/24.
//

import Foundation


// MARK: - SFNode
public class SFNode<T> {
    // MARK: var
    /// 关联值
    public internal(set) var value: T?
    /// 层级，默认"0"
    public internal(set) var level: String = ""
    /// 层级索引
    public var levelIdx: Int {
        return level.components(separatedBy: ".").count
    }
    /// 是否展开，默认true
    public internal(set) var isExpanded: Bool = true
    /// 是否可展开
    public var isExpandable: Bool {
        children.count > 0
    }
    /// 是否显示，默认true
    public internal(set) var isVisible: Bool = true
    
    /// 树
    public internal(set) var tree: SFTree<T>?
    /// 父节点
    public internal(set) var parent: SFNode<T>?
    /// 子节点
    public internal(set) var children: [SFNode<T>] = []
    
    // MARK: life cycle
    /// 初始化
    public init(value: T?) {
        self.value = value
    }
}


// MARK: - 检查
extension SFNode {
    /// 检查index
    private func check(index: Int) -> Bool {
        guard index >= 0, index < self.children.count else {
            return false
        }
        return true
    }
    /// 检查range
    private func check(range: Range<Int>) -> Bool {
        let allRange = 0..<self.children.count
        let clampedRange = range.clamped(to: allRange)
        return clampedRange == range
    }
}


// MARK: - 增删改查
extension SFNode {
    // MARK: 增
    /// 新增child
    public func append(child: SFNode<T>) {
        append(children: [child])
    }
    
    /// 新增children
    public func append(children: [SFNode<T>]) {
        let index = self.children.count
        insert(children: children, at: index)
    }
    
    /// 插入child
    public func insert(child: SFNode<T>, at index: Int) {
        insert(children: [child], at: index)
    }
    
    /// 插入children
    public func insert(children: [SFNode<T>], at index: Int) {
        if index == self.children.count {
            children.forEach { child in
                child.parent = self
            }
            self.children.append(contentsOf: children)
            return
        }
        guard check(index: index) else { return }
        children.forEach { child in
            child.parent = self
        }
        self.children.insert(contentsOf: children, at: index)
    }
    
    
    // MARK: 删
    /// 删除child
    public func removeChild(at index: Int) -> SFNode<T>? {
        guard check(index: index) else { return nil }
        let child = self.children.remove(at: index)
        child.tree = nil
        child.parent = nil
        return child
    }
    
    /// 删除第一个
    public func removeFirst() -> SFNode<T>? {
        let index = 0
        return removeChild(at: index)
    }
    
    /// 删除最后一个
    public func removeLast() -> SFNode<T>? {
        let index = self.children.count - 1
        return removeChild(at: index)
    }
    
    /// 删除全部
    public func removeAll() -> [SFNode<T>?] {
        let range = 0..<self.children.count
        return removeChildren(in: range)
    }
    
    /// 删除某个range内的
    public func removeChildren(in range: Range<Int>) -> [SFNode<T>?] {
        guard check(range: range) else { return [] }
        var removedChildren: [SFNode<T>?] = []
        for index in range.reversed() {
            if let removedChild = removeChild(at: index) {
                removedChildren.insert(removedChild, at: 0)
            }
        }
        return removedChildren
    }
    
    
    // MARK: 改
    /// 替换某个index的child
    public func replaceChild(at index: Int, with child: SFNode<T>) -> SFNode<T>? {
        guard check(index: index) else { return nil }
        let replacedChild = self.children.remove(at: index)
        replacedChild.tree = nil
        replacedChild.parent = nil
        insert(child: child, at: index)
        return replacedChild
    }
    
    /// 替换某个range内的children
    public func replaceChildren(at range: Range<Int>, with children: [SFNode<T>]) -> [SFNode<T>] {
        guard check(range: range) else { return [] }
        let replacedChildren = Array(self.children[range])
        self.children.removeSubrange(range)
        replacedChildren.forEach { node in
            node.tree = nil
            node.parent = nil
        }
        insert(children: children, at: range.lowerBound)
        return replacedChildren
    }

    
    // MARK: 查
    /// 获取某个Range内的Children
    public func findChildrenAtRange(_ range: Range<Int>) -> [SFNode<T>?] {
        guard check(range: range) else { return [] }
        var result: [SFNode<T>?] = []
        for index in range {
            result.append(findChildrenAtIndex(index))
        }
        return result
    }

    /// 获取某个Range内的Children
    public func findChildrenAtIndex(_ index: Int) -> SFNode<T>? {
        guard check(index: index) else { return nil }
        return self.children[index]
    }
    
}


// MARK: expand & shrink
extension SFNode {
    /// 展开节点
    public func expand() {
        tree?.expand(node: self)
    }
    /// 收缩节点
    public func shrink() {
        tree?.shrink(node: self)
    }
    /// 展开或收缩节点
    public func expandOrShrink() {
        if isExpanded {
            shrink()
        } else {
            expand()
        }
    }
}
