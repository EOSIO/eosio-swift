//
//  LinkedList.swift
//  EosioSwift
//
//  Created by Ben Martell on 4/30/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

/// A LinkedList utility implementation for tracking item nodes.
public struct LinkedList<T>: CustomStringConvertible {
    private var head: Node<T>?
    private var tail: Node<T>?

    /// The default init.
    public init() { }

    /// - Returns: A `Bool` indicating if the `LinkedList` is empty.
    public var isEmpty: Bool {
        return head == nil
    }

    /// Property for the first item in the `LinkedList`.
    public var first: Node<T>? {
        return head
    }

    /// Adds a new element of type <T> to the end of this `LinkedList`.
    ///
    /// - Parameter value: The object of type T to append to the `LinkedList`.
    public mutating func append(_ value: T) {
        let newNode = Node(value: value)
        if let tailNode = tail {
            newNode.previous = tailNode
            tailNode.next = newNode
        } else {
            head = newNode
        }
        tail = newNode
    }

    /// Removes a `Node` from this `LinkedList`.
    ///
    /// - Parameter node: The `Node` object to remove.
    /// - Returns: The `Node` value of the `Node` that was removed from the `LinkedList`.
    public mutating func remove(_ node: Node<T>) -> T {
        let prev = node.previous
        let next = node.next

        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        next?.previous = prev

        if next == nil {
            tail = prev
        }

        node.previous = nil
        node.next = nil

        return node.value
    }

    /// Property describing the `LinkedList`.
    public var description: String {
        var text = "["
        var node = head

        while node != nil {
            text += "\(node!.value)"
            node = node!.next
            if node != nil { text += ", " }
        }
        return text + "]"
    }
}

/// A generic Node implementation for items to be held in a linked list data structure.
public class Node<T> {
    public var value: T
    public var next: Node<T>?
    public var previous: Node<T>?

    /// The default init.
    ///
    /// - Parameter value: The object of type T to append to the `LinkedList`.
    public init(value: T) {
        self.value = value
    }
}
