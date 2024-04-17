//
//  TodoListModelModels.swift
//  MdEditor
//
//  Created by Alexey Turulin on 11/28/23.
//

import Foundation
import TaskManagerPackage

enum TodoListModel {

	enum Request {
		struct TaskSelected {
			let indexPath: IndexPath
		}
	}

	struct Response {
		let data: [SectionWithTasks]

		struct SectionWithTasks {
			let section: Section
			let tasks: [Task]
		}
	}

	struct ViewModel {

		let tasksBySections: [Section]

		struct Section {
			let title: String
			let tasks: [Task]
		}

		enum Task {
			case regularTask(RegularTask)
			case importantTask(ImportantTask)
		}

		struct RegularTask {
			let title: String
			let completed: Bool
		}

		struct ImportantTask {
			let title: String
			let completed: Bool
			let deadLine: String
			let priority: String
		}
	}
}
