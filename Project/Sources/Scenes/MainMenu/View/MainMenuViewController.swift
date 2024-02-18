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

	private lazy var collectionView: UICollectionView = makeCollectionView()
	private lazy var buttonNew: UIButton = makeButton(
		withTitle: L10n.Main.buttonNew,
		andImage: Asset.Icons.doc.image,
		action: #selector(showNewScreen)
	)
	private lazy var buttonOpen: UIButton = makeButton(
		withTitle: L10n.Main.buttonOpen,
		andImage: Asset.Icons.folder.image,
		action: #selector(showOpenScreen)
	)
	private lazy var buttonAbout: UIButton = makeButton(
		withTitle: L10n.Main.buttonAbout,
		andImage: Asset.Icons.infoBubble.image,
		action: #selector(showAboutScreen)
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
		setupUI()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layout()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		interactor?.fetchData()
	}
}

// MARK: - Actions

private extension MainMenuViewController {
	@objc
	func showNewScreen() {
		interactor?.performAction(request: .newFile)
	}

	@objc
	func showAboutScreen() {
		interactor?.performAction(request: .showAbout)
	}

	@objc
	func showOpenScreen() {
		interactor?.performAction(request: .openFIle)
	}
}

// MARK: - UI Setup

private extension MainMenuViewController {

	func makeCollectionView() -> UICollectionView {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = Sizes.CollectionView.cellSize
		layout.sectionInset = UIEdgeInsets(
			top: Sizes.Padding.half,
			left: Sizes.Padding.normal,
			bottom: Sizes.Padding.half,
			right: Sizes.Padding.normal
		)
		layout.scrollDirection = .horizontal

		let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)

		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

		collectionView.backgroundColor = Theme.backgroundColor
		collectionView.showsVerticalScrollIndicator = false
		collectionView.showsHorizontalScrollIndicator = false

		collectionView.translatesAutoresizingMaskIntoConstraints = false

		return collectionView
	}

	func makeButton(withTitle title: String, andImage image: UIImage, action: Selector? = nil) -> UIButton {
		let button = UIButton()

		button.configuration = .plain()
		button.configuration?.title = title
		button.configuration?.image = image.withTintColor(Theme.black)
		button.configuration?.imageReservation = Sizes.Button.imageReservation
		button.configuration?.imagePadding = Sizes.Padding.half
		button.configuration?.baseForegroundColor = Theme.black

		button.translatesAutoresizingMaskIntoConstraints = false

		button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
		button.titleLabel?.adjustsFontForContentSizeCategory = true

		if let action {
			button.addTarget(
				self,
				action: action,
				for: .touchUpInside
			)
		}

		return button
	}

	func setupUI() {
		view.backgroundColor = Theme.backgroundColor
		title = L10n.Main.title
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.hidesBackButton = true

		view.addSubview(collectionView)
		view.addSubview(buttonNew)
		view.addSubview(buttonOpen)
		view.addSubview(buttonAbout)
	}

	func configureCell(_ cell: UICollectionViewCell, with file: MainMenuModel.ViewModel.RecentFile) {
		let label = UILabel()

		label.text = file.fileNmae
		label.font = UIFont.systemFont(ofSize: Sizes.CollectionView.fontSize)
		label.textAlignment = .center
		label.frame.origin = CGPoint(x: .zero, y: cell.bounds.height + Sizes.Padding.half)
		label.frame.size = CGSize(width: cell.bounds.width, height: Sizes.CollectionView.labelHeight)

		cell.addSubview(label)

		cell.backgroundColor = Theme.accentColor
		cell.layer.cornerRadius = Sizes.cornerRadius
	}
}

// MARK: - Layout UI

private extension MainMenuViewController {
	func layout() {
		NSLayoutConstraint.deactivate(constraints)

		let newConstraints = [
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			collectionView.heightAnchor.constraint(equalToConstant: Sizes.CollectionView.height),

			buttonNew.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: Sizes.Padding.normal),
			buttonNew.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			buttonNew.heightAnchor.constraint(equalToConstant: Sizes.M.height),

			buttonOpen.topAnchor.constraint(equalTo: buttonNew.bottomAnchor, constant: Sizes.Padding.normal),
			buttonOpen.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			buttonOpen.heightAnchor.constraint(equalToConstant: Sizes.M.height),

			buttonAbout.topAnchor.constraint(equalTo: buttonOpen.bottomAnchor, constant: Sizes.Padding.normal),
			buttonAbout.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			buttonAbout.heightAnchor.constraint(equalToConstant: Sizes.M.height)
		]

		NSLayoutConstraint.activate(newConstraints)

		constraints = newConstraints
	}
}

// MARK: - UICollectionViewDataSource

extension MainMenuViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel.recentFiles.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
		let file = viewModel.recentFiles[indexPath.row]
		configureCell(cell, with: file)
		return cell
	}
}

// MARK: - UICollectionViewDelegate

extension MainMenuViewController: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainMenuViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		Sizes.CollectionView.cellSize
	}
}

// MARK: - IStartViewController

extension MainMenuViewController: IMainMenuViewController {
	func render(viewModel: MainMenuModel.ViewModel) {
		self.viewModel = viewModel
		collectionView.reloadData()
	}
}
