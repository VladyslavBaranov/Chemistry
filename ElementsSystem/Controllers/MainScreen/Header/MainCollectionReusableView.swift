//
//  MainCollectionReusableView.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 31.01.2022.
//

import UIKit

final class MainCollectionReusableView: UICollectionReusableView {
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
        }
    }

    private var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel = UILabel()
        titleLabel.text = "Scripts"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.sizeToFit()
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame.origin = .init(
            x: (bounds.maxY - titleLabel.bounds.height) / 2,
            y: bounds.maxY - titleLabel.bounds.height
        )
    }
}
