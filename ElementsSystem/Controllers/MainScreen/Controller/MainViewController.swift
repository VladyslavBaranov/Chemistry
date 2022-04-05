//
//  MainViewController.swift
//  ElementsSystem
//
//  Created by Vladyslav Baranov on 03.04.2022.
//

// ¹⁰²³⁴⁵⁶⁷⁸⁹

import UIKit

final class MainViewController: UICollectionViewController {

    var viewModel: MainViewModel!
    
    let searchController = UISearchController()

    private let layoutManager = LayoutManager()

    func createSection(windowFrame: CGRect, traitCollection: UITraitCollection, cellHeightRatio: CGFloat) -> NSCollectionLayoutSection {
        
        let cellsPerRow = layoutManager.cellsForRow(windowFrame: windowFrame, traitCollection: traitCollection)

        let fraction: CGFloat = 1 / CGFloat(cellsPerRow)
        let inset = 5.0
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(fraction))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(fraction))
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
            return createSection(
                windowFrame: view.frame,
                traitCollection: environment.traitCollection,
                cellHeightRatio: 0.25)
        }
        return layout
    }
    
    func createMenu() -> UIMenu {
        
        let characteristicsList = ElementCharacteristics.allCases
        
        let actions = characteristicsList.map { characteristic -> UIAction in
            let action = UIAction(
                title: characteristic.rawValue,
                image: UIImage(systemName: "camera")
            ) { (_) in
                self.viewModel.setCurrentCharacteristic(characteristic)
                self.navigationItem.title = characteristic.rawValue
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
        cell.backgroundColor = .systemGray6
        
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
        
        navigationItem.searchController = searchController
        let item = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "ellipsis.circle"),
            primaryAction: nil,
            menu: createMenu())
        navigationItem.rightBarButtonItem = item
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .systemBackground
        collectionView.register(MainElementCollectionViewCell.self, forCellWithReuseIdentifier: "id")
        collectionView.register(MainCollectionReusableView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "header")
        collectionView.collectionViewLayout = createLayout()
    }
    func setupData() {
        viewModel = MainViewModel()
        viewModel.reloadCollectionView = { [unowned self] in
            navigationItem.title = viewModel.getCurrentCharacteristic().rawValue
            collectionView.reloadData()
        }
        navigationItem.title = viewModel.getCurrentCharacteristic().rawValue
    }
}
