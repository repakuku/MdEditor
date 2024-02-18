//
//  MainMenuViewController.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

protocol IMainMenuViewController: AnyObject {
	func render(viewModel: MainMenuModel.ViewModel)
}

final class MainMenuViewController: UIViewController {

	// MARK: - Dependencies

	var interactor: IMainMenuInteractor?

	// MARK: - Private Properties

	private var viewModel: MainMenuModel.ViewModel! // swiftlint:disable:this implicitly_unwrapped_optional

	private lazy var collectionViewRecentFiles = makeCollectionView(
		accessibilityIdentifier: AccessibilityIdentifier.MainMenuScene.recentFiles.description
	)

	private lazy var tableView = makeTableView(
		accessibilityIdentifier: AccessibilityIdentifier.MainMenuScene.menu.description
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

// MARK: - UI Setup

private extension MainMenuViewController {

	func setupUI() {
		view.backgroundColor = Theme.backgroundColor
		title = L10n.Main.title
		navigationController?.navigationBar.prefersLargeTitles = true

		view.addSubview(collectionViewRecentFiles)
		view.addSubview(tableView)

		collectionViewRecentFiles.register(
			RecentFileCollectionViewCell.self,
			forCellWithReuseIdentifier: RecentFileCollectionViewCell.reusableIdentifier
		)
		tableView.register(
			MainMenuTableViewCell.self,
			forCellReuseIdentifier: MainMenuTableViewCell.reusableIdentifier
		)
	}

	func makeFlowLayout() -> UICollectionViewFlowLayout {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: Sizes.CollectionView.width, height: Sizes.CollectionView.height)
		layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: Sizes.Padding.normal)
		layout.scrollDirection = .horizontal
		layout.minimumLineSpacing = Sizes.Padding.double
		layout.minimumInteritemSpacing = Sizes.Padding.double

		return layout
	}

	func makeCollectionView(accessibilityIdentifier: String) -> UICollectionView {
		let layout = makeFlowLayout()

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
		collectionView.isPagingEnabled = true
		collectionView.backgroundColor = Theme.backgroundColor
		collectionView.translatesAutoresizingMaskIntoConstraints = false

		collectionView.accessibilityIdentifier = accessibilityIdentifier
		collectionView.dataSource = self
		collectionView.delegate = self

		return collectionView
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

private extension MainMenuViewController {
	func layout() {
		NSLayoutConstraint.deactivate(constraints)

		let newConstraints = [
			collectionViewRecentFiles.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collectionViewRecentFiles.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			collectionViewRecentFiles.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			collectionViewRecentFiles.heightAnchor.constraint(equalToConstant: Sizes.CollectionView.height),

			tableView.topAnchor.constraint(
				equalTo: collectionViewRecentFiles.bottomAnchor,
				constant: Sizes.Padding.normal
			),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		]

		NSLayoutConstraint.activate(newConstraints)

		constraints = newConstraints
	}
}

// MARK: - UICollectionViewDelegate

extension MainMenuViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel.recentFiles.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: "cell",
			for: indexPath
		) as! RecentFileCollectionViewCell // swiftlint:disable:this force_cast

		let recentFile = viewModel.recentFiles[indexPath.row]
		cell.configure(fileName: recentFile.fileName, previewText: recentFile.previewText)
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		interactor?.performAction(request: .recentFileSelected(indexPath: indexPath))
	}
}

// MARK: - UITableViewDelegate

extension MainMenuViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.menu.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(
			withIdentifier: MainMenuTableViewCell.reusableIdentifier,
			for: indexPath
		) as! MainMenuTableViewCell // swiftlint:disable:this force_cast
		
		let menuItem = viewModel.menu[indexPath.row]
		var menuImage: UIImage?
		
		switch menuItem.item {
		case .openFIle:
			menuImage = UIImage(systemName: "folder.fill")?.withTintColor(
				Theme.mainColor, 
				renderingMode: .alwaysOriginal
			)
		case .newFile:
			menuImage = UIImage(systemName: "doc.fill")?.withTintColor(
				Theme.mainColor,
				renderingMode: .alwaysOriginal
			)
		case .showAbout:
			menuImage = UIImage(systemName: "info.bubble.fill")?.withTintColor(
				Theme.mainColor,
				renderingMode: .alwaysOriginal
			)
		}
		cell.configure(menuTitle: menuItem.title, menuImage: menuImage ?? UIImage())
	
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		interactor?.performAction(request: .menuItemSelected(indexPath: indexPath))
	}
}

// MARK: - IMainMenuViewController

extension MainMenuViewController: IMainMenuViewController {
	func render(viewModel: MainMenuModel.ViewModel) {
		self.viewModel = viewModel
		collectionViewRecentFiles.reloadData()
		tableView.reloadData()
	}
}
