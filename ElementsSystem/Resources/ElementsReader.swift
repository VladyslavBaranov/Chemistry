//
//  ElementsReader.swift
//  ElementsSystem
//
//  Created by Vladyslav Baranov on 03.04.2022.
//

import Foundation

enum ElementCharacteristics: String, CaseIterable {
    case orderPeriod = "Group & Period"
    case config = "Configuration"
    case mass = "Atomic mass"
    case radius = "Atomic radius"
    case density = "Density"
    case meltPoint = "Melting point"
    case boilPoint = "Boiling point"
    case oxidation = "Oxidation"
}

struct ChemicalElement: Decodable {
    var order: Int
    var group: Int
    var period: Int
    var config: [String]
    var name: String
    var short: String
    var mass: Double
    var radius: Int
    var density: Double?
    var meltPoint: Double?
    var boilPoint: Double?
    var oxidation: [Int]
    var isRadioactive: Bool?
    
    func getValueFor(characteristic: ElementCharacteristics) -> String {
        switch characteristic {
        case .orderPeriod:
            return "\(group), \(period)"
        case .config:
            if config.count == 1 {
                return config[0]
            } else if config.count == 2 {
                return "[\(config[0])]\(config[1])"
            }
            return config.joined()
        case .mass:
            return "\(mass) u"
        case .radius:
            return "\(radius) pm"
        case .density:
			if density == nil {
				return "N/A"
			} else {
				let value = density!.toCurrentDensityUnit()
				return "\(value.getFormattedString()) \(DensityUnit.currentUnit().sign())"
			}
        case .meltPoint:
			if meltPoint == nil {
				return "N/A"
			} else {
				let value = meltPoint!.toCurrentTempeatureUnit()
				return "\(value.getFormattedString()) \(TemperatureUnit.currentUnit().sign())"
			}
        case .boilPoint:
			if boilPoint == nil {
				return "N/A"
			} else {
				let value = boilPoint!.toCurrentTempeatureUnit()
				return "\(value.getFormattedString()) \(TemperatureUnit.currentUnit().sign())"
			}
        case .oxidation:
            return "\(mass)"
        }
    }
}

struct ElementCategory: Decodable {
    var category: String
    var elements: [ChemicalElement]
}

class ElementsReader {
	
	static let numFormatter = NumberFormatter()
    var categories: [ElementCategory] = []
    
    init() {
        guard let url = Bundle.main.url(forResource: "TableContents", withExtension: "json") else { fatalError() }
        guard let data = try? Data(contentsOf: url) else { fatalError() }
        guard let categories = try? JSONDecoder().decode([ElementCategory].self, from: data) else { fatalError() }
        self.categories = categories
		Self.numFormatter.minimumFractionDigits = 0
		Self.numFormatter.maximumFractionDigits = 5
    }
    
    func searchWith(key: String) -> [ElementCategory] {
        var copy = categories
        if let order = Int(key) {
            for i in 0..<copy.count {
                copy[i].elements = copy[i].elements.filter { $0.order == order }
            }
        } else {
            for i in 0..<copy.count {
                copy[i].elements = copy[i].elements.filter { $0.name.lowercased().contains(key) }
            }
        }
        copy.removeAll { $0.elements.isEmpty }
        return copy
    }
}
