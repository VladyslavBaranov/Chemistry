//
//  DatabaseInfoCollectionViewCell.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 31.01.2022.
//

import UIKit
import AVFoundation

final class MainElementCollectionViewCell: UICollectionViewCell {
    
    var value: String = "" {
        didSet {
            valueLabel.text = value
            valueLabel.sizeToFit()
        }
    }
    
    var element: ChemicalElement! {
        didSet {
            titleLabel.text = element.short
            orderLabel.text = "\(element.order)"
            nameLabel.text = "\(element.name)"
            titleLabel.sizeToFit()
            orderLabel.sizeToFit()
            nameLabel.sizeToFit()
            if element.isRadioactive != nil {
                if radiationImage.image == nil {
                    radiationImage.image = UIImage(named: "radiactive")?.withRenderingMode(.alwaysTemplate)
                }
            }
            radiationImage.isHidden = element.isRadioactive == nil
        }
    }
    
    private var titleLabel: UILabel!
    private var orderLabel: UILabel!
    private var nameLabel: UILabel!
    private var valueLabel: UILabel!
    
    private var radiationImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding = LayoutManager.mainScreenElementCollectionViewCellPadding
        orderLabel.frame.origin = .init(x: padding, y: padding)
        titleLabel.center = .init(x: bounds.midX, y: bounds.midY)
        nameLabel.frame.origin = .init(x: padding, y: bounds.height - nameLabel.bounds.height - padding)
        valueLabel.frame.origin = .init(x: bounds.width - valueLabel.bounds.width - padding, y: padding)
        radiationImage.frame = .init(x: bounds.width - 30 - padding, y: bounds.height - 30 - padding, width: 30, height: 30)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIPasteboard.general.string = value.replacingOccurrences(of: ".", with: ",")
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform.init(scaleX: 0.84, y: 0.84)
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    private func commonInit() {
        titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.font = UIFont(name: "Times", size: 50)
        titleLabel.textAlignment = .left
        
        orderLabel = UILabel()
        addSubview(orderLabel)
        orderLabel.font = UIFont(name: "Times", size: 16)
        orderLabel.textAlignment = .left
        
        nameLabel = UILabel()
        addSubview(nameLabel)
        nameLabel.font = UIFont(name: "Times", size: 16)
        nameLabel.textAlignment = .left
        
        valueLabel = UILabel()
        addSubview(valueLabel)
        valueLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        valueLabel.textColor = UIColor(named: "Value2")
        valueLabel.textAlignment = .left
        
        radiationImage = UIImageView()
        radiationImage.tintColor = UIColor(named: "Value2")
        addSubview(radiationImage)
    }
    
}
