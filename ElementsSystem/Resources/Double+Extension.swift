//
//  Double+Extension.swift
//  ElementsSystem
//
//  Created by VladyslavMac on 06.04.2022.
//

import Foundation

extension Double {
	
	var celciusToFahrenheit: Double { self * 1.8 + 32 }
	
	var celciusToK: Double { self + 273.15 }
	
	func toCurrentTempeatureUnit() -> Double {
		let unit = TemperatureUnit.currentUnit()
		switch unit {
		case .celcius:
			return self
		case .fahrenheit:
			return celciusToFahrenheit
		case .kelvin:
			return celciusToK
		}
	}
	
	var gcmToGl: Double { self * 1000 }
	
	var gcmToKilogramLiter: Double { self }
	
	var gcmToGramMililiter: Double { self }
	
	var gcmToKilogramMililiter: Double { self / 1000 }
	
	var gcmToGramCM: Double { self * 1000000 }
	
	var gcmToKilogramCM: Double { self * 1000 }
	
	var gcmToGramCC: Double { self }
	
	var gcmToKilogramCC: Double { self / 1000 }
	
	func toCurrentDensityUnit() -> Double {
		let unit = DensityUnit.currentUnit()
		switch unit {
		case .gramLiter:
			return gcmToGl
		case .kilogramLiter:
			return gcmToKilogramLiter
		case .gramMililiter:
			return gcmToGramMililiter
		case .kilogramMililiter:
			return gcmToKilogramMililiter
		case .gramCM:
			return gcmToGramCM
		case .kilogramCM:
			return gcmToKilogramCM
		case .gramCC:
			return gcmToGramCC
		case .kilogramCC:
			return gcmToKilogramCC
		}
	}
	
	func getFormattedString() -> String {
		ElementsReader.numFormatter.string(from: NSNumber(value: self)) ?? "0"
	}
}
