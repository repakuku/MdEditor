//
//  TextPreviewViewController.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

protocol ITextPreviewViewController: AnyObject {
}

final class TextPreviewViewController: UIViewController {
	// MARK: - Dependencies

	var interactor: ITextPreviewInteractor?

	// MARK: - Private Properties

	// MARK: - Initialization

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		interactor?.fetchData()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if self.isMovingFromParent {
		}
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
	}
}

// MARK: - IAboutViewController

extension TextPreviewViewController: ITextPreviewViewController {
}

// MARK: - Setup UI

private extension TextPreviewViewController {
	func setupUI() {
		navigationController?.navigationBar.tintColor = Theme.black
		title = L10n.About.title
		navigationController?.navigationBar.prefersLargeTitles = true
	}
}
