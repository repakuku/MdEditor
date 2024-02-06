//
//  StartViewController.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

protocol IStartViewController: AnyObject {
	func render(viewModel: StartModel.ViewModel)
}

final class StartViewController: UIViewController {

	// MARK: - Public Properties

	// MARK: - Dependencies

	var interactor: IStartInteractor?

	// MARK: - Private Properties

	private var viewModel = StartModel.ViewModel(files: [])

	// MARK: - Initialization

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	// MARK: - Public Methods

	// MARK: - Delegate Implementation

	// MARK: - Private Methods
}

extension StartViewController: IStartViewController {
	func render(viewModel: StartModel.ViewModel) {
	}
}
