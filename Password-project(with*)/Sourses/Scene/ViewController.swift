//
//  ViewController.swift
//  Password-project(with*)
//
//  Created by Мария Вольвакова on 15.07.2022.
//

import UIKit

//MARK: - Properties

class ViewController: UIViewController {
    
    static var isRunning = true
    static var password = ""
    
    var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 20
        stack.distribution = .fillProportionally
        stack.alignment = .center
        return stack
    }()
    
    var isBlack: Bool = false {
        didSet {
            view.backgroundColor = isBlack ? .black : .white
        }
    }
    
    static var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .systemOrange
        return activityIndicator
    }()
    
    static var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите пароль"
        textField.text = ""
        textField.borderStyle = .roundedRect
        textField.textColor = .darkGray
        textField.textAlignment = .center
        textField.isSecureTextEntry = true
        textField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        return textField
    }()
    
    static var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.text = "Ваш пароль отобразится здесь"
        label.textColor = .darkGray
        return label
    }()
    
    lazy var colorChangeButton = createButton(title: "Изменить цвет фона", color: .systemOrange, selector: #selector(onBut))
    lazy var passwordButton = createButton(title: "Сгенерировать пароль", color: .systemBlue, selector: #selector(generate))
    lazy var resetButton = createButton(title: "Сбросить пароль", color: .darkGray, selector: #selector(reset))
    
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        ViewController.textField.delegate = self
    }
    
    func setupLayout() {
        view.addSubview(verticalStack)
        
        verticalStack.addArrangedSubview(ViewController.textField)
        verticalStack.addArrangedSubview(ViewController.activityIndicator)
        verticalStack.addArrangedSubview(ViewController.label)
        verticalStack.addArrangedSubview(passwordButton)
        verticalStack.addArrangedSubview(resetButton)
        verticalStack.addArrangedSubview(colorChangeButton)
        
        verticalStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 18).isActive = true
        verticalStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18).isActive = true
        verticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        verticalStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200).isActive = true
    }
    
    //MARK: - Actions
    
    @objc func onBut(_ sender: Any) {
        isBlack.toggle()
    }
    
    @objc func generate() {
        ViewController.isRunning = true
        
        ViewController.password = String.randomPassword()
        DispatchQueue.main.async {
            ViewController.textField.text = ViewController.password
            ViewController.activityIndicator.startAnimating()
            ViewController.activityIndicator.isHidden = false
            ViewController.textField.isSecureTextEntry = true
        }
        
        DispatchQueue.global().async {
            BruteforceOperation.bruteForce(passwordToUnlock: ViewController.password)
        }
    }
    
    
    @objc func reset() {
        ViewController.isRunning = false
        
        DispatchQueue.main.async {
            ViewController.textField.text = ""
            ViewController.label.text = "Ваш пароль отобразится здесь"
            ViewController.activityIndicator.stopAnimating()
            ViewController.activityIndicator.isHidden = true
            
        }
    }
    
    //MARK: - Methods
    
    func createButton(title: String, color: UIColor, selector: Selector) -> UIButton {
        let button = UIButton()
        button.setTitle("\(title)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
        button.widthAnchor.constraint(equalToConstant: 300).isActive = true
        button.backgroundColor = color
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
}


