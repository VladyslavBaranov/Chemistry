//
//  SettingsTableViewCcontroller.swift
//  ElementsSystem
//
//  Created by VladyslavMac on 06.04.2022.
//

import UIKit

protocol SettingsTableViewControllerDelegate: AnyObject {
	func shouldReloadTable()
}

final class SettingsTableViewController: UITableViewController {
	
	struct Section {
		struct Option {
			var title: String
			var value: String
		}
		var title: String?
		var options: [Option]
	}
	
	var sections: [Section] = [
		.init(
			title: nil,
			options: [.init(title: "Appearance", value: "")]),
		.init(
			title: "Units",
			options: [
				.init(title: "Temperature", value: TemperatureUnit.currentUnit().sign()),
				.init(title: "Density", value: "g/L")
			]
		)
	]
	
	weak var delegate: SettingsTableViewControllerDelegate!

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.backButtonTitle = ""
		navigationController?.navigationBar.tintColor = .label
		navigationItem.title = "Preferences"
	}
	override func numberOfSections(in tableView: UITableView) -> Int {
		sections.count
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		sections[section].options.count
	}
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		sections[section].title
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1, reuseIdentifier: "id")
		cell.textLabel?.text = sections[indexPath.section].options[indexPath.row].title
		cell.selectionStyle = .none
		cell.detailTextLabel?.text = sections[indexPath.section].options[indexPath.row].value
		cell.accessoryType = .disclosureIndicator
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		var sections: [SelectionTableViewController.Section] = []
		var title = ""
		if indexPath.section == 0 {
			sections = [
				.init(title: "System", isSelected: false),
				.init(title: "Light", isSelected: false),
				.init(title: "Dark", isSelected: false)
			]
			let currentId = UserDefaultsHelper.shared.getAppearanceId()
			sections[currentId].isSelected = true
			title = "Appearance"
		} else if indexPath.section == 1 && indexPath.row == 0 {
			sections = [
				.init(title: "C", isSelected: false),
				.init(title: "F", isSelected: false),
				.init(title: "K", isSelected: false)
			]
			let currentId = TemperatureUnit.currentUnit().rawValue
			sections[currentId].isSelected = true
			title = "Temperature"
		} else if indexPath.section == 1 && indexPath.row == 1 {
			sections = [
				.init(title: "g/L", isSelected: false),
				.init(title: "kg/L", isSelected: false),
				.init(title: "g/ml", isSelected: false),
				.init(title: "kg/ml", isSelected: false),
				.init(title: "g/m3", isSelected: false),
				.init(title: "kg/m3", isSelected: false),
				.init(title: "g/cm3", isSelected: false),
				.init(title: "kg/cm3", isSelected: false),
			]
			let currentId = DensityUnit.currentUnit().rawValue
			sections[currentId].isSelected = true
			title = "Density"
		}
		let controller = SelectionTableViewController.createInstance(title: title, sections: sections, delegate: self)
		navigationController?.pushViewController(controller, animated: true)
	}
}

extension SettingsTableViewController: SelectionTableViewControllerDelegate {
	func didTapCell(section: Int, identifier: String) {
		switch identifier {
		case "Appearance":
			guard let keyWindow = UIApplication.shared.keyWindow else { return }
			UIView.transition(with: keyWindow, duration: 0.3, options: .transitionCrossDissolve, animations: {
				switch section {
				case 0:
					keyWindow.overrideUserInterfaceStyle = .unspecified
				case 1:
					keyWindow.overrideUserInterfaceStyle = .light
				case 2:
					keyWindow.overrideUserInterfaceStyle = .dark
				default:
					break
				}
			}, completion: nil)
			UserDefaultsHelper.shared.setAppearance(id: section)
		case "Temperature":
			switch section {
			case 0:
				sections[1].options[0].value = "C"
			case 1:
				sections[1].options[0].value = "F"
			case 2:
				sections[1].options[0].value = "K"
			default:
				break
			}
			TemperatureUnit.setUnit(.init(rawValue: section) ?? .celcius)
			tableView.reloadData()
			delegate?.shouldReloadTable()
		case "Density":
			switch section {
			case 0:
				sections[1].options[1].value = "g/L"
			case 1:
				sections[1].options[1].value = "kg/L"
			case 2:
				sections[1].options[1].value = "g/ml"
			case 3:
				sections[1].options[1].value = "kg/ml"
			case 4:
				sections[1].options[1].value = "g/m3"
			case 5:
				sections[1].options[1].value = "kg/m3"
			case 6:
				sections[1].options[1].value = "g/cm3"
			case 7:
				sections[1].options[1].value = "kg/cm3"
			default:
				break
			}
			DensityUnit.setUnit(.init(rawValue: section) ?? .gramLiter)
			tableView.reloadData()
			delegate?.shouldReloadTable()
		default:
			break
		}
	}
}
