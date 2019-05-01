//
//  Queue.swift
//  EosioSwift
//
//  Created by Ben Martell on 4/30/19.
//  Copyright © 2019 block.one. All rights reserved.
//

import Foundation

/// A queue data structure implemetation for managing FIFO (First In First Out) type of operatons.
public struct Queue<T> {

    fileprivate var list = LinkedList<T>()

    public var isEmpty: Bool {
        return list.isEmpty
    }

    public mutating func enqueue(_ element: T) {
        list.append(element)
    }

    // 4
    public mutating func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else { return nil }

        _ = list.remove(element)

        return element.value
    }

    public func peek() -> T? {
        return list.first?.value
    }
}

extension Queue: CustomStringConvertible {
    public var description: String {
        return list.description
    }
}
