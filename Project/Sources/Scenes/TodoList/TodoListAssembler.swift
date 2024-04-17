//
//  TodoListAssembler.swift
//  MdEditor
//
//  Created by Alexey Turulin on 12/04/23.
//

import UIKit
import TaskManagerPackage

final class TodoListAssembler {

	func assembly(taskManager: ITaskManager, createTaskClosure: (() -> Void)?) -> TodoListViewController {
		let viewController = TodoListViewController()
		let sectionForTaskManagerAdapter = SectionForTaskManagerAdapter(taskManager: taskManager)
		let presenter = TodoListPresenter(viewController: viewController)
		let interactor = TodoListInteractor(
			presenter: presenter,
			sectionManager: sectionForTaskManagerAdapter,
			createTaskClosure: createTaskClosure
		)
		viewController.interactor = interactor

		return viewController
	}
}
