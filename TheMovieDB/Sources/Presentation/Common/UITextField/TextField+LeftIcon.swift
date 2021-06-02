//
//  TextField+LeftIcon.swift
//  TheMovieDB
//
//  Created by Павел Духовенко on 17.05.2021.
//

import UIKit

/// Текстовое поле `UITextField` с настраиваемым `UIView` с левой стороны
final class TextFieldWithLeftIcon: UITextField {
    
    // MARK: - Constants
    
    private enum Constants {
        static let cornerRadius: CGFloat = 5
        static let insets = UIEdgeInsets(top: 4, left: -6, bottom: 4, right: 4)
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
        addIconPlaceholders()
        configureAppearance()
    }
    
    private func addIconPlaceholders() {
        leftViewMode = .always
        leftView?.contentMode = .center
        rightViewMode = .whileEditing
        rightView?.contentMode = .left
    }
    
    private func configureAppearance() {
        backgroundColor = .darkBlue
        tintColor = .light
        setLeftView()
        setRightView()
        layer.cornerRadius = Constants.cornerRadius
        layer.borderColor = UIColor.bgBlack.cgColor
        attributedPlaceholder = NSAttributedString(
            string: placeholder ?? "",
            attributes: [.foregroundColor: UIColor.light])
    }
    
    private func setLeftView() {
        let leftIcon = UIImageView(image: #imageLiteral(resourceName: "searchIcon"))
        leftIcon.contentMode = .center
        leftView = leftIcon
    }
    
    private func setRightView() {
        let rightButton = UIButton()
        rightButton.setImage(#imageLiteral(resourceName: "clearButton"), for: .normal)
        rightButton.addTarget(self, action: #selector(clearText), for: .touchUpInside)
        rightView = rightButton
    }
    
    @objc private func clearText() {
        text?.removeAll()
    }
    
    // MARK: - UITextField
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: bounds.height, height: bounds.height)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - bounds.height * 0.75, y: 0, width: bounds.height * 0.65, height: bounds.height)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: Constants.insets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: Constants.insets)
    }
}
