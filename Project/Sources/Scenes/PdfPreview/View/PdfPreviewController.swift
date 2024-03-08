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

	private var viewModel: TextPreviewModel.ViewModel! // swiftlint:disable:this implicitly_unwrapped_optional

	private lazy var pdfView = makePdfView(
		accessibilityIdentifier: AccessibilityIdentifier.PdfPreviewScene.pdfView.description
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

// MARK: - Setup UI

private extension PdfPreviewController {
	private func  setupUI() {
		if let navigationBarY = navigationController?.navigationBar.frame.maxY {
			pdfView.frame = CGRect(
				x: 0,
				y: navigationBarY,
				width: view.bounds.width,
				height: view.bounds.height
			)
		}
		view.addSubview(pdfView)
	}

	func makePdfView(accessibilityIdentifier: String) -> PDFView {
		let pdfView = PDFView()
		pdfView.autoScales = true
		pdfView.pageBreakMargins = UIEdgeInsets(
			top: Sizes.Padding.double,
			left: Sizes.Padding.normal,
			bottom: Sizes.Padding.normal,
			right: Sizes.Padding.normal
		)

		return pdfView
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
//		pdfView.document = PDFDocument(data: viewModel.data)
	}
}

//		let printController = UIPrintInteractionController.shared
//		printController.printingItem = data
//		printController.present(animated: true) { _, completed, error in
//
//			if completed {
//				print("Completed")
//			} else if let error = error {
//				print(error.localizedDescription)
//			} else {
//				print("Canceled")
//			}
//		}
