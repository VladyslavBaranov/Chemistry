//
//  DatabaseInfoCollectionViewCell.swift
//  SQLiteManager
//
//  Created by Vladyslav Baranov on 31.01.2022.
//

import UIKit
import AVFoundation

protocol MainElementCollectionViewCellDelegate: AnyObject {
    func didTapOnItem()
}

final class MainElementCollectionViewCell: UICollectionViewCell {

    weak var delegate: MainElementCollectionViewCellDelegate?
    var currentCharacteristic: ElementCharacteristics = .config {
        didSet {
			let value = element.getValueFor(characteristic: currentCharacteristic)
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
    private(set) var valueLabel: UILabel!
    private var stackView: UIStackView!
    
    private(set) var radiationImage: UIImageView!
    
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
        radiationImage.frame = .init(x: bounds.width - 30 - padding, y: padding, width: 30, height: 30)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTapOnItem()
        if element.isRadioactive != nil {
            rotateRadiationImage()
        }
		let scalar = element.getScalarValue(characteristic: currentCharacteristic)
			.replacingOccurrences(of: ".", with: ",")
		UIPasteboard.general.string = scalar
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
        
        orderLabel = UILabel()
        addSubview(orderLabel)
        orderLabel.font = .systemFont(ofSize: LayoutManager.valueLabelFontSize(), weight: .semibold)
        orderLabel.textAlignment = .left
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Times", size: 50)
        titleLabel.textAlignment = .center
    
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 16)
        nameLabel.textAlignment = .center
        
        valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
		valueLabel.font = .systemFont(ofSize: LayoutManager.valueLabelFontSize(), weight: .semibold)
        valueLabel.textAlignment = .center
        
        stackView = UIStackView(arrangedSubviews: [titleLabel, nameLabel, valueLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.alignment = .center
        addSubview(stackView)
        
        let padding = LayoutManager.mainScreenElementCollectionViewCellPadding
        
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            stackView.topAnchor.constraint(lessThanOrEqualTo: topAnchor, constant: 2 * padding),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
        
        
        
        radiationImage = UIImageView()
        addSubview(radiationImage)
    }
    
    private func rotateRadiationImage() {
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.toValue = CGFloat.pi * 2
        anim.duration = 0.3
        anim.timingFunction = .init(name: .easeOut)
        anim.isCumulative = true
        anim.repeatCount = 1
        radiationImage?.layer.add(anim, forKey: "anim")
    }
}
