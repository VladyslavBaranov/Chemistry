//
//  MainViewModel.swift
//  ElementsSystem
//
//  Created by Vladyslav Baranov on 04.04.2022.
//

import Foundation

final class MainViewModel {
    
    var searchKey = "" {
        didSet {
            if searchKey.isEmpty {
                searchResults.removeAll()
            } else {
                searchResults = elementsReader.searchWith(key: searchKey.lowercased())
            }
            reloadCollectionView?()
        }
    }
    
    var searchResults: [ElementCategory] = []
    
    var elementsReader: ElementsReader!
    
    var reloadCollectionView: (() -> ())?
    
    init() {
        elementsReader = ElementsReader()
        reloadCollectionView?()
    }
    
    func getCurrentCharacteristic() -> ElementCharacteristics {
        let currentCharacteristicKey = "com.currentCharacteristicKey"
        guard let value = UserDefaults.standard.value(forKey: currentCharacteristicKey) as? String else {
            return .mass
        }
        return .init(rawValue: value) ?? .mass
    }
    
    func setCurrentCharacteristic(_ char: ElementCharacteristics) {
        UserDefaults.standard.set(char.rawValue, forKey: "com.currentCharacteristicKey")
    }
    
    func getElement(for indexPath: IndexPath) -> ChemicalElement? {
        if searchKey.isEmpty {
            return elementsReader?.categories[indexPath.section].elements[indexPath.row]
        } else {
            return  searchResults[indexPath.section].elements[indexPath.row]
        }
    }
    
    func getNumberOfSections() -> Int {
        if elementsReader == nil {
            return 0
        }
        if searchKey.isEmpty {
            return elementsReader.categories.count
        } else {
            return searchResults.count
        }
    }
    
    func getNumberOfItems(for section: Int) -> Int {
        if elementsReader == nil {
            return 0
        }
        if searchKey.isEmpty {
            return elementsReader.categories[section].elements.count
        } else {
            return searchResults[section].elements.count
        }
    }
    
    func getTitleForHeaderView(for indexPath: IndexPath) -> String {
        if searchKey.isEmpty {
            if let elementCategory = elementsReader?.categories[indexPath.section].category {
                return elementCategory
            }
        } else {
            let elementCategory = searchResults[indexPath.section].category
            return elementCategory
        }
        return ""
    }
}
