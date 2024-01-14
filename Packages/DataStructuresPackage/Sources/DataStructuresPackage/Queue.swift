//
//  QueueList.swift
//
//
//  Created by Alexey Turulin on 10/30/23.
//

import Foundation

public struct Queue<T: Equatable> {

	private var elements = DoublyLinkedList<T>()

	public var count: Int {
		elements.count
	}

	public var isEmpty: Bool {
		elements.isEmpty
	}

	public var peek: T? {
		elements.value(at: 0)
	}

	public mutating func enqueue(_ element: T) {
		elements.append(element)
	}

	public mutating func dequeue() -> T? {
		return elements.pop()
	}
}
