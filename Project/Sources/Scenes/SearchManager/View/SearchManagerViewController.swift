//
//  SearchManagerViewController.swift
//  MdEditor
//
//  Created by Alexey Turulin on 4/12/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

protocol ISearchManagerViewController {
	func render(viewModel: SearchManagerModel.ViewModel)
}

final class SearchManagerViewController: UIViewController {

	// MARK: - Dependencies

	var interactor: ISearchManagerInteractor?

	// MARK: - Private Properties

	private lazy var searchBar = makeSearchBar()
	private lazy var tableView = makeTableView(
		accessibilityIdentifier: AccessibilityIdentifier.SearchManagerScene.table.description
	)

	private var viewModel: SearchManagerModel.ViewModel?

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
		super.viewDidLayoutSubviews()
		layout()
	}
}

// MARK: - Setup UI

private extension SearchManagerViewController {
	func setupUI() {
		view.backgroundColor = Theme.backgroundColor
		navigationController?.navigationBar.prefersLargeTitles = true

		title = L10n.MainMenu.search

		view.addSubview(searchBar)
		view.addSubview(tableView)

		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
	}

	func makeSearchBar() -> UISearchBar {
		let searchBar = UISearchBar()
		searchBar.translatesAutoresizingMaskIntoConstraints = false
		searchBar.delegate = self

		searchBar.barTintColor = Theme.backgroundColor
		searchBar.searchTextField.backgroundColor = Theme.inputColor

		searchBar.placeholder = L10n.Search.placeholder
		searchBar.autocapitalizationType = .none

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

private extension SearchManagerViewController {
	func layout() {
		NSLayoutConstraint.activate(
			[
				searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

				tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Sizes.Padding.normal),
				tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
				tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
			]
		)
	}

	func configureCell(_ cell: UITableViewCell, with searchModel: SearchManagerModel.ViewModel.SearchModel) {
		var content = cell.defaultContentConfiguration()

		cell.backgroundColor = Theme.backgroundColor

		content.text = searchModel.fileName
		content.secondaryText = searchModel.text

		cell.contentConfiguration = content
	}
}

// MARK: - UITableView

extension SearchManagerViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel?.result.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		if let item = viewModel?.result[indexPath.row] {
			configureCell(cell, with: item)
		}
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		interactor?.performAction(request: .resultSelected(indexPath: indexPath))
	}
}

// MARK: - ISearchViewController

extension SearchManagerViewController: ISearchManagerViewController {
	func render(viewModel: SearchManagerModel.ViewModel) {
		self.viewModel = viewModel
		tableView.reloadData()
	}
}

extension SearchManagerViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()

		if let seachText = searchBar.text {
			interactor?.fetchData(request: .searchButtonPressed(searchText: seachText))
		}
	}
}

// MARK: - Preview

struct SearchManagerViewControlleProviderr: PreviewProvider {
	static var previews: some View {
		SearchManagerAssembler().assembly(delegate: MainCoordinator(navigationController: UINavigationController())).preview()
	}
}
