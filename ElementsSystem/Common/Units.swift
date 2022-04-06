//
//  Units.swift
//  ElementsSystem
//
//  Created by VladyslavMac on 06.04.2022.
//

import Foundation

enum TemperatureUnit: Int {
	case celcius = 0
	case fahrenheit = 1
	case kelvin = 2
	
	static func currentUnit() -> Self {
		UserDefaultsHelper.shared.getCurrentTempUnit()
	}
	static func setUnit(_ unit: TemperatureUnit) {
		UserDefaultsHelper.shared.setCurrentTempUnit(unit)
	}
	
	func sign() -> String {
		switch self {
		case .celcius:
			return "°C"
		case .fahrenheit:
			return "°F"
		case .kelvin:
			return "K"
		}
	}
}

enum DensityUnit: Int {
	case gramLiter = 0
	case kilogramLiter = 1
	case gramMililiter = 2
	case kilogramMililiter = 3
	case gramCM = 4
	case kilogramCM = 5
	case gramCC = 6
	case kilogramCC = 7
	
	static func currentUnit() -> Self {
		UserDefaultsHelper.shared.getCurrentDensityUnit()
	}
	static func setUnit(_ unit: DensityUnit) {
		UserDefaultsHelper.shared.setCurrentDensityUnit(unit)
	}
	
	func sign() -> String {
		switch self {
		case .gramLiter:
			return "g/L"
		case .kilogramLiter:
			return "kg/L"
		case .gramMililiter:
			return "g/ml"
		case .kilogramMililiter:
			return "kg/ml"
		case .gramCM:
			return "g/m³"
		case .kilogramCM:
			return "kg/m³"
		case .gramCC:
			return "g/cc"
		case .kilogramCC:
			return "kg/cc"
		}
	}
}
