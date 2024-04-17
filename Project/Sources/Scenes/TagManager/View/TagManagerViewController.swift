//
//  TagManagerViewController.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/17/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

protocol ITagManagerViewController {
	func render(viewModel: TagManagerModel.ViewModel)
}

final class TagManagerViewController: UIViewController {

	// MARK: - Dependencies

	var interactor: ITagManagerInteractor?

	// MARK: - Private Properties

	private lazy var searchBar = makeSearchBar()

	private lazy var tableView = makeTableView(
		accessibilityIdentifier: AccessibilityIdentifier.TagManagerScene.table.description
	)

	private var viewModel: TagManagerModel.ViewModel?

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
	}

	override func viewDidLayoutSubviews() {
		layout()
	}
}

// MARK: - Setup UI

extension TagManagerViewController {
	func setupUI() {
		view.backgroundColor = Theme.backgroundColor

		title = L10n.MainMenu.tags

		view.addSubview(searchBar)
		view.addSubview(tableView)

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
	}

	func makeSearchBar() -> UISearchBar {
		let searchBar = UISearchBar()

		searchBar.translatesAutoresizingMaskIntoConstraints = false
		searchBar.placeholder = L10n.Tag.placeholder
		searchBar.autocapitalizationType = .none
		searchBar.barTintColor = Theme.backgroundColor
		searchBar.searchTextField.backgroundColor = Theme.inputColor

		searchBar.delegate = self

		return searchBar
	}

	func makeTableView(accessibilityIdentifier: String) -> UITableView {
		let tableView = UITableView()

		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.backgroundColor = Theme.backgroundColor

		tableView.delegate = self
		tableView.dataSource = self

		return tableView
	}
}

// MARK: - Layout UI

extension TagManagerViewController {
	func layout() {
		NSLayoutConstraint.activate(
			[
				searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

				tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Sizes.Padding.normal),
				tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
			]
		)
	}

	func configureCell(_ cell: UITableViewCell, with searchModel: String) {
		var content = cell.defaultContentConfiguration()

		cell.tintColor = Theme.accentColor
		cell.backgroundColor = Theme.backgroundColor

		content.text = searchModel

		cell.contentConfiguration = content
	}
}

// MARK: - Preview

struct TagManagerViewControllerProvider: PreviewProvider {
	static var previews: some View {
		TagManagerAssembler()
			.assembly(
				delegate: MainCoordinator(navigationController: UINavigationController())
			)
			.preview()
	}
}
// MARK: - UISearchBarDelegate

extension TagManagerViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()

		if let searchTag = searchBar.text {
			interactor?.fetchData(request: .searchButtonPressed(searchTag: searchTag))
		}
	}
}

// MARK: - UITableViewDelegate

extension TagManagerViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel?.result.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

		if let item = viewModel?.result[indexPath.row] {
			configureCell(cell, with: item.text)
		}

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		interactor?.performAction(request: .resultSelected(indexPath: indexPath))
	}
}

// MARK: - ITagManagerViewController

extension TagManagerViewController: ITagManagerViewController {
	func render(viewModel: TagManagerModel.ViewModel) {
		self.viewModel = viewModel
		tableView.reloadData()
	}
}
