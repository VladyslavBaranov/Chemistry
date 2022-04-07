//
//  MainViewController.swift
//  ElementsSystem
//
//  Created by Vladyslav Baranov on 03.04.2022.
//

import UIKit

final class MainViewController: UICollectionViewController {
	
	private class CellColorScheme {
		var backgroundColor: UIColor?
		var valueLabelColor: UIColor?
		init(_ backgroundColor: String, _ valueLabelColor: String) {
			self.backgroundColor = UIColor(named: backgroundColor) ?? .systemGray6
			self.valueLabelColor = UIColor(named: valueLabelColor) ?? .label
		}
	}

    var viewModel: MainViewModel!
    
    let searchController = UISearchController()

    private let layoutManager = LayoutManager()
	
	private let cellColorSchemes: [CellColorScheme] = [
		.init("Non-metals", "Non-metalsLabel"),
		.init("Metalloids", "MetalloidsLabel"),
		.init("Noble", "NobleLabel"),
		.init("Alkali", "AlkaliLabel"),
		.init("EarthAlkali", "EarthAlkaliLabel"),
		.init("PostTransition", "PostTransitionLabel"),
		.init("Transition", "TransitionLabel"),
		.init("Lanthanides", "LanthanidesLabel"),
		.init("Actinides", "ActinidesLabel"),
		.init("", "")
	]
	
	func createSection(windowFrame: CGRect, traitCollection: UITraitCollection) -> NSCollectionLayoutSection {
		
		let cellsPerRow = layoutManager.cellsForRow(windowFrame: windowFrame, traitCollection: traitCollection)
		
		let fraction: CGFloat = 1 / CGFloat(cellsPerRow)
		let inset = 5.0
		// Item
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalWidth(fraction * 0.7))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
		// Group
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction * 0.7))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
		
		// Section
		let section = NSCollectionLayoutSection(group: group)
		// section.orthogonalScrollingBehavior = .continuous
		section.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
		
		let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
		let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: "header", alignment: .top)
		section.boundarySupplementaryItems = [headerItem]
		return section
	}

	func createLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout { [unowned self] sectionIndex, environment in
			return createSection(windowFrame: view.frame, traitCollection: traitCollection)
		}
        return layout
    }
    
    func createMenu() -> UIMenu {
        
        let characteristicsList = ElementCharacteristics.allCases
        
        let actions = characteristicsList.map { characteristic -> UIAction in
            let action = UIAction(
				title: characteristic.getLocalizedString(),
                image: nil
            ) { (_) in
                self.viewModel.setCurrentCharacteristic(characteristic)
				self.navigationItem.title = characteristic.getLocalizedString()
                self.collectionView.reloadData()
            }
            return action
        }
        let addNewMenu = UIMenu(
            title: "",
            children: actions)
        
        return addNewMenu
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! MainCollectionReusableView
        view.title = viewModel.getTitleForHeaderView(for: indexPath)
        return view
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.getNumberOfSections()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getNumberOfItems(for: section)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! MainElementCollectionViewCell
        if let element = viewModel.getElement(for: indexPath) {
            cell.element = element
            cell.currentCharacteristic = viewModel.getCurrentCharacteristic()
        }
		cell.backgroundColor = cellColorSchemes[indexPath.section].backgroundColor ?? .systemGray6
		cell.valueLabel.textColor = cellColorSchemes[indexPath.section].valueLabelColor ?? .label
		cell.radiationImage.tintColor = cellColorSchemes[indexPath.section].valueLabelColor ?? .label
        cell.layer.cornerCurve = .continuous
        cell.layer.cornerRadius = 10
        return cell
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchKey = searchText
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchKey = ""
    }
}

private extension MainViewController {
    func setupUI() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Element name or atomic number"

        view.backgroundColor = .systemBackground
        collectionView.register(MainElementCollectionViewCell.self, forCellWithReuseIdentifier: "id")
        collectionView.register(MainCollectionReusableView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "header")
        collectionView.collectionViewLayout = createLayout()
		setupNavigationController()
    }
	
	func setupNavigationController() {
		navigationItem.searchController = searchController
		let item = UIBarButtonItem(
			title: nil,
			image: UIImage(systemName: "ellipsis.circle"),
			primaryAction: nil,
			menu: createMenu())
		item.tintColor = .label
		
		let leadingItem = UIBarButtonItem(
			image: UIImage(systemName: "gearshape"),
			style: .plain,
			target: self,
			action: #selector(openPreferences)
		)
		leadingItem.tintColor = .label
		
		navigationItem.leftBarButtonItem = leadingItem
		navigationItem.rightBarButtonItem = item
		
		navigationItem.rightBarButtonItem?.tintColor = .label
		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
    func setupData() {
        viewModel = MainViewModel()
        viewModel.reloadCollectionView = { [unowned self] in
			navigationItem.title = viewModel.getCurrentCharacteristic().getLocalizedString()
            collectionView.reloadData()
		}
		navigationItem.title = viewModel.getCurrentCharacteristic().getLocalizedString()
	}
	
	@objc func openPreferences() {
		let settingsViewController = SettingsTableViewController(style: .insetGrouped)
		settingsViewController.delegate = self
		let nav = UINavigationController(rootViewController: settingsViewController)
		present(nav, animated: true, completion: nil)
	}
}

extension MainViewController: SettingsTableViewControllerDelegate {
	func shouldReloadTable() {
		collectionView.reloadData()
	}
}
