//
//  TextEditorViewController.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

protocol ITextEditorViewController: AnyObject {
	func render(viewModel: TextEditorModel.ViewModel)
}

final class TextEditorViewController: UIViewController {

	// MARK: - Dependencies

	var interactor: ITextEditorInteractor?

	// MARK: - Private Properties

	private var hasTasks = false

	private lazy var segmentedControl = makeSegmentedControl()

	private lazy var textViewEditor = makeTextView(
		accessibilityIdentifier: AccessibilityIdentifier.TextPreviewScene.textView.description
	)

	private lazy var textViewPreview = makeTextView(
		accessibilityIdentifier: AccessibilityIdentifier.TextPreviewScene.textView.description
	)

	private var constraints = [NSLayoutConstraint]()

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
		interactor?.fetchData()
		setupUI()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layout()
	}
}

private extension TextEditorViewController {
	@objc
	func segmentChanged(_ sender: UISegmentedControl) {
		switchState(toShowPreview: sender.selectedSegmentIndex == 1)
	}

	func switchState(toShowPreview: Bool) {
		if toShowPreview {
			interactor?.needConvertText(text: textViewEditor.text)
			textViewEditor.isHidden = true
			textViewPreview.isHidden = false
		} else {
			textViewEditor.isHidden = false
			textViewPreview.isHidden = true
		}
	}
}

// MARK: - Actions

extension TextEditorViewController {
	@objc
	func menuTapped() {
		let alert = UIAlertController(title: Consts.menuTitle, message: Consts.menuMessage, preferredStyle: .actionSheet)

		if hasTasks {
			alert.addAction(
				UIAlertAction(title: Consts.menuItemTasks, style: .default) { _ in
					self.interactor?.openTodoList(text: self.textViewEditor.text)
				}
			)
		}

		alert.addAction(
			UIAlertAction(title: Consts.menuItemPrint, style: .default) { _ in
				self.interactor?.print(text: self.textViewEditor.text)
			}
		)

		alert.addAction(UIAlertAction(title: Consts.menuItemDismiss, style: .cancel, handler: nil))

		self.present(alert, animated: true)
	}
}

// MARK: - Setup UI

private extension TextEditorViewController {
	func setupUI() {
		view.backgroundColor = Theme.backgroundColor
		navigationController?.navigationBar.prefersLargeTitles = true

		textViewEditor.isHidden = false
		textViewPreview.isHidden = true
		textViewPreview.isEditable = false

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .action,
			target: self,
			action: #selector(menuTapped)
		)

		view.addSubview(segmentedControl)
		view.addSubview(textViewEditor)
		view.addSubview(textViewPreview)
	}

	func makeTextView(accessibilityIdentifier: String) -> UITextView {
		let textView = UITextView()
		textView.font = UIFont.boldSystemFont(ofSize: 18)
		textView.textColor = Theme.mainColor
		textView.backgroundColor = Theme.backgroundColor
		textView.textAlignment = .left
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.accessibilityIdentifier = accessibilityIdentifier

		return textView
	}

	func makeSegmentedControl() -> UISegmentedControl {
		let segmentedControl = UISegmentedControl(
			items: [
				Consts.segmentItemText,
				Consts.segmentItemConverter
			]
		)

		segmentedControl.translatesAutoresizingMaskIntoConstraints = false
		segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
		segmentedControl.selectedSegmentIndex = 0

		return segmentedControl
	}
}

// MARK: - Layout UI

private extension TextEditorViewController {
	func layout() {
		NSLayoutConstraint.deactivate(constraints)

		let newConstraints = [
			segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Sizes.Padding.small),
			segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),

			textViewEditor.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Sizes.Padding.small),
			textViewEditor.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizes.Padding.normal),
			textViewEditor.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Sizes.Padding.normal),
			textViewEditor.bottomAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.bottomAnchor,
				constant: Sizes.Padding.normal
			),

			textViewPreview.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Sizes.Padding.small),
			textViewPreview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizes.Padding.normal),
			textViewPreview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Sizes.Padding.normal),
			textViewPreview.bottomAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.bottomAnchor,
				constant: Sizes.Padding.normal
			)
		]

		NSLayoutConstraint.activate(newConstraints)

		constraints = newConstraints
	}
}

// MARK: - ITextPreviewViewController

extension TextEditorViewController: ITextEditorViewController {
	func render(viewModel: TextEditorModel.ViewModel) {
		switch viewModel {
		case .initial(let text, let title, let hasTasks):
			self.title = title
			textViewEditor.isScrollEnabled = false
			textViewEditor.text = text
			textViewEditor.isScrollEnabled = true
			self.hasTasks = hasTasks
		case .convert(let text, let hasTasks):
			textViewPreview.isScrollEnabled = false
			textViewPreview.attributedText = text
			textViewPreview.isScrollEnabled = true
			self.hasTasks = hasTasks
		case .print(let text):
			let printController = UIPrintInteractionController.shared
			printController.printingItem = text
			printController.present(animated: true)
		}
	}
}

private extension TextEditorViewController {
	enum Consts {
		static let segmentItemText = "Text"
		static let segmentItemConverter = "Preview"
		static let menuTitle = "Меню"
		static let menuMessage = "Выберите дополнительное действие"
		static let menuItemTasks = "Посмотреть задачи"
		static let menuItemPrint = "Печать"
		static let menuItemDismiss = "Отмена"
	}
}
