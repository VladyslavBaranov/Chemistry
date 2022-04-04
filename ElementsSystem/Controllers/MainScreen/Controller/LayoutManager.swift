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
        let deviceScreenWidth = windowFrame.width
        switch deviceScreenWidth {
        case 0..<500: // for all iPhones
            return 3
        case 500...800: // for small iPads
            return 3
        case 800..<1200: // for big iPads
            return 4
        case 1200...1600:
            return 5
        default:
            return 6
        }
    }
}
