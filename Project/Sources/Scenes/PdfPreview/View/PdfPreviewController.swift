//
//  PdfPreviewController.swift
//  MdEditor
//
//  Created by Alexey Turulin on 3/7/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit
import PDFKit

protocol IPdfPreviewController: AnyObject {
	func render(viewModel: PdfPreviewModel.ViewModel)
}

final class PdfPreviewController: UIViewController {

	// MARK: - Dependencies

	var interactor: IPdfPreviewInteractor?

	// MARK: - Private Properties

	private var viewModel: PdfPreviewModel.ViewModel! // swiftlint:disable:this implicitly_unwrapped_optional

	private lazy var pdfView = makePdfView(
		accessibilityIdentifier: AccessibilityIdentifier.PdfPreviewScene.pdfView.description
	)

	private lazy var activityIndicator = makeActivityIndicator()

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

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		interactor?.fetchData()
	}
}

// MARK: - Setup UI

private extension PdfPreviewController {
	private func  setupUI() {
		view.backgroundColor = Theme.backgroundColor
		navigationController?.navigationBar.prefersLargeTitles = true

		view.addSubview(pdfView)
		view.addSubview(activityIndicator)

		activityIndicator.center = view.center
		activityIndicator.startAnimating()
	}

	func makePdfView(accessibilityIdentifier: String) -> PDFView {
		return PDFView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
	}

	func makeActivityIndicator() -> UIActivityIndicatorView {
		let activityIndicator = UIActivityIndicatorView()

		activityIndicator.hidesWhenStopped = true
		activityIndicator.style = .large
		activityIndicator.color = Theme.accentColor

		return activityIndicator
	}
}

// MARK: - Layout UI

private extension PdfPreviewController {
	func layout() {
		NSLayoutConstraint.deactivate(constraints)

		let newConstraints = [
			pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Sizes.Padding.normal),
			pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Sizes.Padding.normal),
			pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Sizes.Padding.normal),
			pdfView.bottomAnchor.constraint(
				equalTo: view.safeAreaLayoutGuide.bottomAnchor,
				constant: Sizes.Padding.normal
			)
		]

		NSLayoutConstraint.activate(newConstraints)

		constraints = newConstraints
	}
}

// MARK: - PdfPreviewViewController

extension PdfPreviewController: IPdfPreviewController {
	func render(viewModel: PdfPreviewModel.ViewModel) {
		self.viewModel = viewModel
		title = viewModel.currentTitle
		pdfView.document = PDFDocument(data: viewModel.data)
		activityIndicator.stopAnimating()
	}
}
