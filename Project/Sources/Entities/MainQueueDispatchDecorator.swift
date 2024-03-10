//
//  MainQueueDispatchDecorator.swift
//  MdEditor
//
//  Created by Alexey Turulin on 3/8/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import Foundation
import MarkdownPackage

final class MainQueueDispatchDecorator: IMarkdownToPdfConverter {

	let decoratee: IMarkdownToPdfConverter

	init(decoratee: IMarkdownToPdfConverter) {
		self.decoratee = decoratee
	}

	func convert(
		markdownText: String,
		author: String,
		title: String,
		pageFormat: MarkdownPackage.PageFormat,
		completion: @escaping (Data) -> Void
	) {
		DispatchQueue.global(qos: .userInitiated).async {
			self.decoratee.convert(
				markdownText: markdownText,
				author: author,
				title: title,
				pageFormat: pageFormat
			) { data in
				self.doInMainThread {
					completion(data)
				}
			}
		}
	}

	private func doInMainThread(_ work: @escaping () -> Void) {
		if Thread.isMainThread {
			work()
		} else {
			DispatchQueue.main.async(execute: work)
		}
	}
}
