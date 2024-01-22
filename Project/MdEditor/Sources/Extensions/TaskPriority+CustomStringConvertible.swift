//
//  TaskPriority+CustomStringConvertible.swift
//  MdEditor
//
//  Created by Alexey Turulin on 1/14/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation
import TaskManagerPackage

extension ImportantTask.TaskPriority: CustomStringConvertible {
	public var description: String {
		switch self {
		case .high:
			return L10n.TodoList.TaskPriority.high
		case .medium:
			return L10n.TodoList.TaskPriority.medium
		case .low:
			return L10n.TodoList.TaskPriority.low
		}
	}
}
