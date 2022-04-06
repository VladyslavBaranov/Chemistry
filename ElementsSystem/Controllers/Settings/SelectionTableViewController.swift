//
//  AppearanceTableViewController.swift
//  ElementsSystem
//
//  Created by VladyslavMac on 06.04.2022.
//

import UIKit

private class SelectionTableViewCell: UITableViewCell {
	var checkMarkView: UIImageView!
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: "id")
		checkMarkView = UIImageView(image: UIImage(systemName: "circle"))
		checkMarkView.tintColor = .label
		addSubview(checkMarkView)
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		checkMarkView.frame = .init(x: bounds.width - bounds.height + 10, y: 10, width: bounds.height - 20, height: bounds.height - 20)
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	func select() {
		checkMarkView.image = UIImage(systemName: "checkmark.circle.fill")
		checkMarkView.tintColor = .label
	}
	func deselect() {
		checkMarkView.image = UIImage(systemName: "circle")
		checkMarkView.tintColor = .systemGray3
	}
}

protocol SelectionTableViewControllerDelegate: AnyObject {
	func didTapCell(section: Int, identifier: String)
}

final class SelectionTableViewController: UITableViewController {
	
	weak var delegate: SelectionTableViewControllerDelegate!
	
	static func createInstance(title: String, sections: [Section], delegate: SelectionTableViewControllerDelegate) -> SelectionTableViewController {
		let vc = SelectionTableViewController(style: .insetGrouped)
		vc.delegate = delegate
		vc.sections = sections
		vc.navigationItem.title = title
		return vc
	}
	
	struct Section {
		var title: String
		var isSelected: Bool
	}
	
	var sections: [Section] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		// let id = UserDefaultsHelper.shared.getAppearanceId()
		// sections[id].isSelected = true
	}
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		50
	}
	override func numberOfSections(in tableView: UITableView) -> Int {
		sections.count
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		1
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = SelectionTableViewCell(style: .default, reuseIdentifier: "id")
		cell.textLabel?.text = sections[indexPath.section].title
		if sections[indexPath.section].isSelected {
			cell.select()
		} else {
			cell.deselect()
		}
		cell.selectionStyle = .none
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		(tableView.cellForRow(at: indexPath) as? SelectionTableViewCell)?.deselect()
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		delegate?.didTapCell(section: indexPath.section, identifier: navigationItem.title ?? "")
		for i in 0..<sections.count {
			sections[i].isSelected = false
		}
		sections[indexPath.section].isSelected = true
		tableView.reloadData()
	}
}
