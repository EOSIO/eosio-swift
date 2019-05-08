//
//  Queue.swift
//  EosioSwift
//
//  Created by Ben Martell on 4/30/19.
//  Copyright (c) 2017-2019 block.one and its contributors. All rights reserved.
//

import Foundation

/// A queue data structure implementation for managing FIFO (First In First Out) type of operations.
public struct Queue<T> {

    fileprivate var list = LinkedList<T>()

    /// - Returns: A `Bool` indicating if the queue is empty.
    public var isEmpty: Bool {
        return list.isEmpty
    }

    /// Adds a new element of type <T> to this `Queue` instance.
    ///
    /// - Parameter element: The object to add to the queue.
    public mutating func enqueue(_ element: T) {
        list.append(element)
    }

    /// Removes an element from the queue.
    ///
    /// - Returns: The queue element that was removed from the queue.
    public mutating func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else { return nil }

        _ = list.remove(element)

        return element.value
    }

    /// - Returns: The next queue element in the queue. Does not remove the element from the queue.
    public func peek() -> T? {
        return list.first?.value
    }
}

extension Queue: CustomStringConvertible {
    /// - Returns: A `String` describing the contents of the queue.
    public var description: String {
        return list.description
    }
}
