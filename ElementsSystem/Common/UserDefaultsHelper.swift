//
//  UserDefaultsHelper.swift
//  ElementsSystem
//
//  Created by VladyslavMac on 06.04.2022.
//

import Foundation

final class UserDefaultsHelper {

	static let shared = UserDefaultsHelper()
	func setAppearance(id: Int) {
		UserDefaults.standard.set(id, forKey: "com.appearance.id")
	}
	func getAppearanceId() -> Int {
		UserDefaults.standard.value(forKey: "com.appearance.id") as? Int ?? 0
	}
	func getCurrentTempUnit() -> TemperatureUnit {
		let unitId = UserDefaults.standard.value(forKey: "com.appearance.tempunit") as? Int ?? 0
		return .init(rawValue: unitId) ?? .celcius
	}
	func setCurrentTempUnit(_ unit: TemperatureUnit) {
		UserDefaults.standard.set(unit.rawValue, forKey: "com.appearance.tempunit")
	}
	func getCurrentDensityUnit() -> DensityUnit {
		let unitId = UserDefaults.standard.value(forKey: "com.appearance.densityunit") as? Int ?? 4
		return .init(rawValue: unitId) ?? .gramLiter
	}
	func setCurrentDensityUnit(_ unit: DensityUnit) {
		UserDefaults.standard.set(unit.rawValue, forKey: "com.appearance.densityunit")
	}
}
