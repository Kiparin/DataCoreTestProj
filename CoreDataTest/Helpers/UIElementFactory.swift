//
//  FieldFactory.swift
//  CoreDataTest
//
//  Created by Alexey Kiparin on 05.01.2025.
//

import UIKit

final class UIElementFactory {
	
	// UIButton
	static func createButton(title: String, color: UIColor, action: UIAction) -> UIButton {
		var atributes = AttributeContainer()
		atributes.font = UIFont.boldSystemFont(ofSize: 18)
		
		var buttonConfig = UIButton.Configuration.filled()
		buttonConfig.attributedTitle = AttributedString(
			title,
			attributes: atributes
		)
		buttonConfig.baseBackgroundColor = color
		
		let button = UIButton(
			configuration: buttonConfig,
			primaryAction: action
		)
		
		button.translatesAutoresizingMaskIntoConstraints = false
		return button
	}
	
	// UILabel
	static func createLabel(text: String, font: UIFont, textColor: UIColor) -> UILabel {
		let label = UILabel()
		label.text = text
		label.font = font
		label.numberOfLines = 0
		label.textAlignment = .center
		label.textColor = textColor
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}
	
	//UITextField
	static func createTextField(placeholder: String) -> UITextField {
		let textField = UITextField()
		textField.borderStyle = .roundedRect
		textField.font = .systemFont(ofSize: 16)
		textField.textColor = .label
		textField.textAlignment = .center
		textField.placeholder = placeholder
		textField.translatesAutoresizingMaskIntoConstraints = false
		return textField
	}
}
