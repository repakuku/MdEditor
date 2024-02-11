//
//  AboutViewController.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/10/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit
import WebKit

protocol IAboutViewController {
	func render(viewModel: AboutModel.ViewModel)
}

final class AboutViewController: UIViewController, WKNavigationDelegate {
	// MARK: - Dependencies

	var interactor: IAboutInteractor?

	// MARK: - Private Properties

	private let webView = WKWebView()

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
		webView.navigationDelegate = self

		view = webView
		interactor?.fetchData()
	}
}

// MARK: - IAboutViewController

extension AboutViewController: IAboutViewController {
	func render(viewModel: AboutModel.ViewModel) {
		webView.loadHTMLString(viewModel.html, baseURL: nil)
		webView.allowsBackForwardNavigationGestures = false
	}
}
