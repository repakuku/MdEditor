//
//  DoublyLinkedList+CustomStringConvertible.swift
//  
//
//  Created by Alexey Turulin on 1/13/24.
//

import Foundation

// TODO: Add documentation
extension DoublyLinkedList.Node: CustomStringConvertible {
	public var description: String {
		"\(value)"
	}
}

// TODO: Add documentation
extension DoublyLinkedList: CustomStringConvertible {
	public var description: String {
		var values = [String]()
		var current = head

		while current != nil {
			values.append("\(current!)")
			current = current?.next
		}

		return "count = \(count); list = " + values.joined(separator: " <-> ")
	}
}
