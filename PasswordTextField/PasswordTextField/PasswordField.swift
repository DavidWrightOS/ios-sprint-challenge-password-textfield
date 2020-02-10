//
//  PasswordField.swift
//  PasswordTextField
//
//  Created by Ben Gohlke on 6/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum PasswordStrength: String {
    case weak = "Too weak"
    case medium = "Could be stronger"
    case strong = "Strong password"
}

//@IBDesignable
class PasswordField: UIControl {
    
    // Public API - these properties are used to fetch the final password and strength values
    private (set) var password: String = ""
    private (set) var passwordStrength: PasswordStrength = .weak
    
    private let standardMargin: CGFloat = 8.0
    private let textFieldContainerHeight: CGFloat = 50.0
    private let textFieldMargin: CGFloat = 6.0
    private let colorViewSize: CGSize = CGSize(width: 60.0, height: 5.0)
    
    private let labelTextColor = UIColor(hue: 233.0/360.0, saturation: 16/100.0, brightness: 41/100.0, alpha: 1)
    private let labelFont = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    
    private let textFieldBorderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
    private let bgColor = UIColor(hue: 0, saturation: 0, brightness: 97/100.0, alpha: 1)
    
    // States of the password strength indicators
    private let unusedColor = UIColor(hue: 210/360.0, saturation: 5/100.0, brightness: 86/100.0, alpha: 1)
    private let weakColor = UIColor(hue: 0/360, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let mediumColor = UIColor(hue: 39/360.0, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let strongColor = UIColor(hue: 132/360.0, saturation: 60/100.0, brightness: 75/100.0, alpha: 1)
    
    private var titleLabel: UILabel = UILabel()
    private var textField: UITextField = UITextField()
    private var showHideButton: UIButton = UIButton()
    private var weakView: UIView = UIView()
    private var mediumView: UIView = UIView()
    private var strongView: UIView = UIView()
    private var strengthDescriptionLabel: UILabel = UILabel()
    
    private var passwordStrengthStackView: UIStackView = UIStackView()
    private var strengthColorsStackView: UIStackView = UIStackView()
    
    private func setup() {
        backgroundColor = .red
        //backgroundColor = bgColor
        // Lay out your subviews here
        setupTitleLabel()
        setupTextField()
        setupPasswordStrengthViews()
    }
    
    // MARK: - Setup Title Label
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "ENTER PASSWORD"
        titleLabel.font = labelFont
        titleLabel.textColor = labelTextColor
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: standardMargin),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardMargin),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -standardMargin)
        ])
    }
    
    // MARK: - Setup Text Field
    
    private func setupTextField() {
        
        // Text Field
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = textFieldBorderColor.cgColor
        textField.backgroundColor = bgColor
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.layoutMargins = UIEdgeInsets(top: textFieldMargin,
                                               left: textFieldMargin,
                                               bottom: textFieldMargin,
                                               right: textFieldMargin)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: standardMargin),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardMargin),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -standardMargin),
            textField.heightAnchor.constraint(equalToConstant: textFieldContainerHeight)
        ])
        
        // Show/Hide Button
        textField.addSubview(showHideButton)
        showHideButton.translatesAutoresizingMaskIntoConstraints = false
        showHideButton.backgroundColor = bgColor
        showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
        showHideButton.imageView?.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            showHideButton.topAnchor.constraint(equalTo: textField.topAnchor, constant: textFieldMargin),
            showHideButton.bottomAnchor.constraint(equalTo: textField.bottomAnchor, constant: -textFieldMargin),
            showHideButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -textFieldMargin),
        ])
    }
        
    // MARK: - Password Strength Views
        
    private func setupPasswordStrengthViews() {
        
        // Password Strength StackView
        addSubview(passwordStrengthStackView)
        passwordStrengthStackView.translatesAutoresizingMaskIntoConstraints = false
        passwordStrengthStackView.axis = .horizontal
        passwordStrengthStackView.alignment = .center
        passwordStrengthStackView.spacing = standardMargin
        
        NSLayoutConstraint.activate([
            passwordStrengthStackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: standardMargin),
            passwordStrengthStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: standardMargin)
        ])
        
        // Add Colors StackView
        setupColorsStackView()
        passwordStrengthStackView.addArrangedSubview(strengthColorsStackView)
        
        // Add Strength Description Label
        strengthDescriptionLabel.text = PasswordStrength.weak.rawValue
        strengthDescriptionLabel.font = labelFont
        strengthDescriptionLabel.textColor = labelTextColor
        passwordStrengthStackView.addArrangedSubview(strengthDescriptionLabel)
    }
    
    private func setupColorsStackView() {
        strengthColorsStackView.translatesAutoresizingMaskIntoConstraints = false
        strengthColorsStackView.axis = .horizontal
        strengthColorsStackView.spacing = 2.0
        
        strengthColorsStackView.addArrangedSubview(weakView)
        strengthColorsStackView.addArrangedSubview(mediumView)
        strengthColorsStackView.addArrangedSubview(strongView)
        
        weakView.backgroundColor = weakColor
        mediumView.backgroundColor = unusedColor
        strongView.backgroundColor = unusedColor
        
        for view in strengthColorsStackView.arrangedSubviews where ((view as? UILabel) == nil) {
            view.layer.cornerRadius = colorViewSize.height / 2.0
            
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: colorViewSize.width),
                view.heightAnchor.constraint(equalToConstant: colorViewSize.height)
            ])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
}

/*
extension PasswordField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        // TODO: send new text to the determine strength method
        return true
    }
}
*/
