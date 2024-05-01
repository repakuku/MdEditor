//
//  BaseCoordinator.swift
//  MdEditor
//
//  Created by Alexey Turulin on 1/14/24.
//

/// Protocol defining a coordinator's basic functionality.
protocol ICoordinator: AnyObject {

	/// Start the coordination process.
	func start()
}

/// A base coordinator for all coordinators.
class BaseCoordinator: ICoordinator {

	/// Holds all child coordinators to prevent them from being deallocated.
	var childCoordinators: [ICoordinator] = []

	/// Start the coordination process. Should be overriden by subclasses.
	func start() {}

	/// Adds a coordinator to the list of child coordinators.
	///
	/// Adds a new coordinator only if it isn't already included in the childCoordinators array.
	/// - Parameter coordinator: The coordinator to add.
	func addDependency(_ coordinator: ICoordinator) {
		guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
		childCoordinators.append(coordinator)
	}

	/// Removes a coordinator from the list of child coordinators.
	///
	/// Checks if the given coordinator is a subclass of BaseCoordinator and whether it has any child coordinators.
	/// If so, it recuresively calls removeDependency from each child to ensure all dependencies are cleared.
	/// - Parameter coordinator: The coordinator to remove.
	func removeDependency(_ coordinator: ICoordinator) {
		guard !childCoordinators.isEmpty else { return }

		if let coordinator = coordinator as? BaseCoordinator, !coordinator.childCoordinators.isEmpty {
			coordinator.childCoordinators.forEach { coordinator.removeDependency($0) }
		}

		if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
			childCoordinators.remove(at: index)
		}
	}
}
