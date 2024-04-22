//
//  FolderMonitor.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/22/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation

protocol IFolderMonitor {
	var url: URL { get }
	var folderDidChange: (() -> Void)? { get }
	func start()
	func stop()
}

final class FolderMonitor: IFolderMonitor {

	var url: URL

	var folderDidChange: (() -> Void)?

	private var monitoringDescriptor: Int32 = -1

	private let monitoringQueue = DispatchQueue(
		label: "FolderMonitor.monitoringQueue",
		attributes: .concurrent
	)

	private var monitoringSource: DispatchSourceFileSystemObject?

	init(url: URL, folderDidChange: (() -> Void)?) {
		self.url = url
		self.folderDidChange = folderDidChange
	}

	func start() {
		guard monitoringSource == nil && monitoringDescriptor == -1 else { return }

		// Открытие папки по URL, только для мониторинга.
		monitoringDescriptor = open(url.path, O_EVTONLY)

		// Определение источника отправки, контролируещего папку на наличие добавлений,
		// удалений и переименований.
		monitoringSource = DispatchSource.makeFileSystemObjectSource(
			fileDescriptor: monitoringDescriptor,
			eventMask: .write,
			queue: monitoringQueue
		)

		// Определение блока, который будет вызываться при обнаружении изменения файлов.
		monitoringSource?.setEventHandler { [weak self] in
			self?.folderDidChange?()
		}

		// Определение блока, который будет обеспечивать закрытие папки при отмене источника.
		monitoringSource?.setCancelHandler { [weak self] in
			guard let self = self else { return }
			close(monitoringDescriptor)
			monitoringDescriptor = -1
			monitoringSource = nil
		}

		// Начало мониторинга папки.
		monitoringSource?.resume()
	}

	func stop() {
		monitoringSource?.cancel()
	}
}
