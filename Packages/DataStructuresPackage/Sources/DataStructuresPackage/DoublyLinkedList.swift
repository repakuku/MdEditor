//
//  QueueList.swift
//
//
//  Created by Alexey Turulin on 10/30/23.
//

import Foundation

// TODO: Add documentation
public struct DoublyLinkedList<T: Equatable> {

	final class Node<N> {
		var value: N
		var previous: Node<N>?
		var next: Node<N>?

		init(_ value: N, previous: Node<N>? = nil, next: Node<N>? = nil) {
			self.value = value
			self.next = next
			self.previous = previous
		}
	}

	private(set) var head: Node<T>?
	private(set) var tail: Node<T>?

	private(set) var count = 0

	var isEmpty: Bool {
		head == nil && tail == nil
	}

	public init(_ value: T? = nil) {
		if let value = value {
			let newNode = Node(value)
			head = newNode
			tail = newNode
			count = 1
		}
	}

	public mutating func push(_ value: T) {
		let newNode = Node(value, next: head)
		head?.previous = newNode
		head = newNode

		if tail == nil {
			tail = head
		}

		count += 1
	}

	public mutating func append(_ value: T) {
		let newNode = Node(value, previous: tail)

		tail?.next = newNode
		tail = newNode

		if head == nil {
			head = tail
		}

		count += 1
	}

	public mutating func insert(_ value: T, after index: Int) {
		guard let currentNode = node(at: index) else { return }
		let nextNode = currentNode.next
		let newNode = Node(value, previous: currentNode, next: nextNode)
		currentNode.next = newNode
		nextNode?.previous = newNode

		if newNode.next == nil {
			tail = newNode
		}

		count += 1
	}

	public mutating func pop() -> T? {
		guard let currentHead = head else { return nil }
		head = currentHead.next
		head?.previous = nil

		if head == nil {
			tail = nil
		}

		count -= 1

		return currentHead.value
	}

	public mutating func removeLast() -> T? {
		guard let currentTail = tail else { return nil }
		tail = currentTail.previous
		tail?.next = nil

		if tail == nil {
			head = nil
		}

		count -= 1

		return currentTail.value
	}

	public mutating func remove(after index: Int) -> T? {
		guard let currentNode = node(at: index), let nextNode = currentNode.next else { return nil }

		if currentNode.next === tail {
			tail = currentNode
			currentNode.next = nil
		} else {
			currentNode.next = nextNode.next
			nextNode.next?.previous = currentNode
		}

		count -= 1

		return nextNode.value
	}

	public func value(at index: Int) -> T? {
		node(at: index)?.value
	}

	private func node(at index: Int) -> Node<T>? {
		guard index >= 0 && index < count else { return nil }

		var currentIndex = 0
		var currentNode: Node<T>?

		if index <= count / 2 {
			currentNode = head
			while currentIndex < index {
				currentNode = currentNode?.next
				currentIndex += 1
			}
		} else {
			currentIndex = count - 1
			currentNode = tail
			while currentIndex > index {
				currentNode = currentNode?.previous
				currentIndex -= 1
			}
		}

		return currentNode
	}
}
