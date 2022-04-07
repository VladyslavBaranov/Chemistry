//
//  ElementsReader.swift
//  ElementsSystem
//
//  Created by Vladyslav Baranov on 03.04.2022.
//

import Foundation

enum ElementCharacteristics: String, CaseIterable {
    case orderPeriod = "list_group_period"
    case config = "list_config"
    case mass = "list_mass"
    case radius = "list_radius"
    case density = "list_density"
    case meltPoint = "list_melt"
    case boilPoint = "list_boil"
    case oxidation = "Oxidation"
	
	func getLocalizedString() -> String {
		localizedString(rawValue)
	}
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
    var oxidation: [Int?]
    var isRadioactive: Bool?
	
	func getScalarValue(characteristic: ElementCharacteristics) -> String {
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
			return "\(mass)"
		case .radius:
			return "\(radius)"
		case .density:
			return "\(density?.toCurrentDensityUnit() ?? 0)"
		case .meltPoint:
			return "\(meltPoint?.toCurrentTempeatureUnit() ?? 0)"
		case .boilPoint:
			return "\(boilPoint?.toCurrentTempeatureUnit() ?? 0)"
		case .oxidation:
			return oxidation.map { String($0 ?? 0) }
			.joined(separator: ",")
			.trimmingCharacters(in: .whitespacesAndNewlines)
		}
	}
    
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
			let string = oxidation.map { String($0 ?? 0) }
				.joined(separator: ",")
				.trimmingCharacters(in: .whitespacesAndNewlines)
			return string.isEmpty ? "N/A" : string
        }
    }
}

struct ElementCategory: Decodable {
    var category: String
    var elements: [ChemicalElement]
	
	enum CodingKeys: String, CodingKey {
		case category = "category"
		case elements = "elements"
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		category = try values.decode(String.self, forKey: .category)
		elements = try values.decode([ChemicalElement].self, forKey: .elements)
	}
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
                copy[i].elements = copy[i].elements.filter {
					let lowercasedName = $0.name.lowercased()
					let lowercasedShortName = $0.short.lowercased()
					return lowercasedName.contains(key) || lowercasedShortName.contains(key)
				}
            }
        }
        copy.removeAll { $0.elements.isEmpty }
        return copy
    }
}
