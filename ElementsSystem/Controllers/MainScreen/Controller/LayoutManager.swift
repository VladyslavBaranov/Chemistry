//
//  LayoutManager.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 31.01.2022.
//

import UIKit

enum DeviceCategory {
	case smallPhone
	case midSizePhone
	case maxPhone
	case miniPad
	case midPad
	case pad11
	case pad13
	
	static func getCurrentSizeCategory() -> DeviceCategory {
		let screenSize = UIScreen.main.bounds.size
		let minDimension = min(screenSize.width, screenSize.height)
		switch minDimension {
		case 0..<380:
			return .smallPhone
		case 380..<400:
			return .midSizePhone
		case 400..<500:
			return .maxPhone
		case 500..<780:
			return .miniPad
		case 780..<830:
			return .midPad
		case 830..<850:
			return .pad11
		case 850...1100:
			return .pad13
		default:
			return .midSizePhone
		}
	}
}

enum LayoutType {
	case phone
	case padHorizontalFull
	case padHorizontalOneThird
	case padHorizontalHalf
	case padHorizontal75
	
	case padVerticalFull
	case padVerticalOneThird
	case padVerticalHalf
	case padVertical75
}

struct LayoutManager {
    
    static let mainScreenElementCollectionViewCellPadding: CGFloat = 10
	
	static func valueLabelFontSize() -> CGFloat {
		switch DeviceCategory.getCurrentSizeCategory() {
		case .smallPhone:
			return 14
		case .midSizePhone:
			return 15
		case .maxPhone:
			return 17
		default:
			return 17
		}
	}
	
	func getLayoutType(windowFrame: CGRect) -> LayoutType {
		let device = UIDevice.current.userInterfaceIdiom
		let orientation = UIDevice.current.orientation
		
		switch device {
		case .phone:
			return .phone
		case .pad:
			let dimension = UIScreen.main.bounds.width
			let fraction = windowFrame.width / dimension
			
			switch fraction {
			case 0...0.4:
				switch orientation {
				case .portrait, .portraitUpsideDown:
					return .padVerticalOneThird
				default:
					return .padHorizontalOneThird
				}
			case 0.4...0.5:
				switch orientation {
				case .portrait, .portraitUpsideDown:
					return .padVerticalHalf
				default:
					return .padHorizontalHalf
				}
			case 0.6..<1:
				switch orientation {
				case .portrait, .portraitUpsideDown:
					return .padVertical75
				default:
					return .padHorizontal75
				}
			case 1:
				switch orientation {
				case .portrait, .portraitUpsideDown:
					return .padVerticalFull
				default:
					return .padHorizontalFull
				}
			default:
				return .phone
			}
		default:
			return .phone
		}
	}
	
	func cellsForRowV2(windowFrame: CGRect, traitCollection: UITraitCollection) -> (LayoutType, Int) {
		let layoutType = getLayoutType(windowFrame: windowFrame)
		switch layoutType {
		case .phone:
			return (layoutType, 2)
		case .padHorizontalFull:
			return (layoutType, 6)
		case .padHorizontalOneThird:
			return (layoutType, 2)
		case .padHorizontalHalf:
			return (layoutType, 3)
		case .padHorizontal75:
			// if windowFrame.width < windowFrame.height {
			// 	return (layoutType, 2)
			// } else {
			return (layoutType, 4)
			// }
		case .padVerticalFull:
			return (layoutType, 4)
		case .padVerticalOneThird:
			return (layoutType, 1)
		case .padVerticalHalf:
			return (layoutType, 2)
		case .padVertical75:
			return (layoutType, 2)
		}
	}
    
    func cellsForRow(windowFrame: CGRect, traitCollection: UITraitCollection) -> Int {
		
		let device = UIDevice.current.userInterfaceIdiom
		let orientation = UIDevice.current.orientation
		
		switch device {
		case .phone:
			return 2
		case .pad:
			let dimension = UIScreen.main.bounds.width
			let fraction = windowFrame.width / dimension
			
			switch fraction {
			case 0...0.4:
				switch orientation {
				case .portrait, .portraitUpsideDown:
					return 1
				default:
					return 2
				}
			case 0.4...0.5:
				return 3
			case 0.6..<1:
				switch orientation {
				case .portrait, .portraitUpsideDown:
					return 3
				default:
					return 4
				}
			case 1:
				switch orientation {
				case .portrait, .portraitUpsideDown:
					return 5
				default:
					return 6
				}
			default:
				return 2
			}
		default:
			return 1
		}
		
        // let deviceScreenWidth = windowFrame.width
        // switch deviceScreenWidth {
        // case 0..<500: // for all iPhones
        //     return 2
        // case 500...800: // for small iPads
        //     return 5
        // case 800..<1200: // for big iPads
        //     return 6
        // case 1200...1600:
        //     return 6
        // default:
        //     return 7
        // }
    }
}
