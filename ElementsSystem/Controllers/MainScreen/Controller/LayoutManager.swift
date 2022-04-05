//
//  LayoutManager.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 31.01.2022.
//

import UIKit

struct LayoutManager {
    
    static let mainScreenElementCollectionViewCellPadding: CGFloat = 10
    
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
