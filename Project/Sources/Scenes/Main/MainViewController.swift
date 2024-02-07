//
//  MainViewController.swift
//  MdEditor
//
//  Created by Alexey Turulin on 2/5/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import UIKit

protocol IMainViewController: AnyObject {
	func render(viewModel: MainModel.ViewModel)
}

final class MainViewController: UIViewController {

	// MARK: - Dependencies

	var interactor: IMainInteractor?

	// MARK: - Private Properties

	private var viewModel = MainModel.ViewModel(files: [])

	private lazy var collectionView: UICollectionView = makeCollectionView()
	private lazy var buttonNew: UIButton = makeButton()
	private lazy var buttonOpen: UIButton = makeButton()
	private lazy var buttonAbout: UIButton = makeButton()

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

// MARK: - UI Setup

private extension MainViewController {

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

		let collectionView = UICollectionView(
			frame: view.frame,
			collectionViewLayout: layout
		)

		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

		collectionView.backgroundColor = Theme.backgroundColor
		collectionView.showsVerticalScrollIndicator = false
		collectionView.showsHorizontalScrollIndicator = false

		collectionView.translatesAutoresizingMaskIntoConstraints = false

		return collectionView
	}

	func makeButton() -> UIButton {
		let button = UIButton()

		button.translatesAutoresizingMaskIntoConstraints = false

		button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
		button.titleLabel?.adjustsFontForContentSizeCategory = true

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
}

// MARK: - Layout UI

private extension MainViewController {
	func layout() {
		NSLayoutConstraint.deactivate(constraints)

		let newConstraints = [
			collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			collectionView.heightAnchor.constraint(equalToConstant: Sizes.CollectionView.height)
		]

		NSLayoutConstraint.activate(newConstraints)

		constraints = newConstraints
	}
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		viewModel.files.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
		cell.backgroundColor = Theme.accentColor
		return cell
	}
}

// MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(
		_ collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAt indexPath: IndexPath
	) -> CGSize {
		Sizes.CollectionView.cellSize
	}
}

// MARK: - IStartViewController

extension MainViewController: IMainViewController {
	func render(viewModel: MainModel.ViewModel) {
		self.viewModel = viewModel
		collectionView.reloadData()
	}
}
