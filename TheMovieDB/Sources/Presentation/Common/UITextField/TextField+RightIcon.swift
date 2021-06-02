//
//  TextField+RightIcon.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 01.05.2021.
//

import UIKit

/// Текстовое поле `UITextField` с настраиваемым `UIView` с правой стороны
final class TextFieldWithRightIcon: UITextField {
    
    // MARK: - Constants
    
    private enum Constants {
        static let borderWidth: CGFloat = 2
        static let cornerRadius: CGFloat = 5
        static let leftViewMultiplier: CGFloat = 6
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Private methods
    
    private func commonInit() {
        addRightIconPlaceholder()
        configureAppearance()
    }
    
    private func addLeftSpacing() {
        leftViewMode = .always
        leftView = UIView()
    }
    
    private func addRightIconPlaceholder() {
        rightViewMode = .always
        rightView?.contentMode = .center
    }
    
    private func configureAppearance() {
        addLeftSpacing()
        layer.borderWidth = Constants.borderWidth
        layer.cornerRadius = Constants.cornerRadius
        layer.borderColor = UIColor.borderBlue.cgColor
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [.foregroundColor: UIColor.gray])
    }
    
    // MARK: - UITextField
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - bounds.height, y: 0, width: bounds.height, height: bounds.height)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: bounds.height / Constants.leftViewMultiplier, height: bounds.height)
    }
}
