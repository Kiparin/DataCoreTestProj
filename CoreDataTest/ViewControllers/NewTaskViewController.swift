//
//  NewTaskViewController.swift
//  CoreDataTest
//
//  Created by Alexey Kiparin on 05.01.2025.
//

import UIKit

final class NewTaskViewController: UIViewController {
	
	weak var delegate: ReloadListViewDelegate?
	
//MARK: Fields
	private lazy var titleLabel: UILabel = {
		let label = UIElementFactory.createLabel(
			text: "New task",
			font: .boldSystemFont(ofSize: 24),
			textColor: .black)
		return label
	}()
	
	private lazy var textField: UITextField = {
		let textField = UIElementFactory.createTextField(
			placeholder: "Task name"
		)
		return textField
	}()
	
	private lazy var saveButton: UIButton = {
		let element = UIElementFactory.createButton(
			title: "Save",
			color: .milkGreen,
			action: UIAction{[unowned self] _ in saveButtonAction()}
			)
		return element
	}()
	
	private lazy var cancelButton: UIButton = {
		let element = UIElementFactory.createButton(
			title: "Cancel",
			color: .milkRed,
			action: UIAction{[unowned self] _ in dismiss(animated: true)}
			)
		return element
	}()
	
	private let dataStorage = DataStorageManager.shared
	
//MARK: LifeCircle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBackground
		
		setupViews(titleLabel, textField, saveButton, cancelButton)
		setupConstraints()
	}
	
	private func saveButtonAction() {
		guard textField.text != nil else { return }
		let userTask = UserTask(context: dataStorage.persistentContainer.viewContext)
		userTask.id = UUID()
		userTask.title = textField.text
		dataStorage.saveContext()
		delegate?.reload()
		dismiss(animated: true)
	}
}

private extension NewTaskViewController {
	func setupViews(_ subviews: UIView...) {
		subviews.forEach { view.addSubview($0) }
	}
	
	func setupConstraints() {
		NSLayoutConstraint.activate(
			[
				titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
				titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
				titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
				
				textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
				textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
				textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
				
				saveButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
				saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
				saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
				
				cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
				cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
				cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
				
			]
		)
	}
}

#Preview {
	NewTaskViewController()
}


