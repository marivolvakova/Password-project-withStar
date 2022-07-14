//
//  ViewController.swift
//  Password-project(with*)
//
//  Created by Мария Вольвакова on 15.07.2022.
//

import UIKit

//MARK: - Properties

class ViewController: UIViewController {
    
    var isRunning = true
    var password = ""
    
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
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .systemOrange
        return activityIndicator
    }()
    
    var textField: UITextField = {
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
    
    var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.text = "Ваш пароль отобразится здесь"
        label.textColor = .darkGray
        return label
    }()
    
    var colorChangeButton: UIButton = {
        let colorChangeButton = UIButton()
        colorChangeButton.setTitle("Изменить цвет фона", for: .normal)
        colorChangeButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        colorChangeButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        colorChangeButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        colorChangeButton.backgroundColor = .systemOrange
        colorChangeButton.tintColor = .white
        colorChangeButton.layer.masksToBounds = true
        colorChangeButton.layer.cornerRadius = 10
        colorChangeButton.addTarget(self, action: #selector(onBut), for: .touchUpInside)
        return colorChangeButton
    }()
    
    var passwordButton: UIButton = {
        let passwordButton = UIButton()
        passwordButton.setTitle("Сгенерировать пароль", for: .normal)
        passwordButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        passwordButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        passwordButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        passwordButton.backgroundColor = .systemBlue
        passwordButton.tintColor = .white
        passwordButton.layer.masksToBounds = true
        passwordButton.layer.cornerRadius = 10
        passwordButton.addTarget(self, action: #selector(generate), for: .touchUpInside)
        return passwordButton
    }()
    
    var stopButton: UIButton = {
        let stopButton = UIButton()
        stopButton.setTitle("Остановить генерацию", for: .normal)
        stopButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        stopButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        stopButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        stopButton.backgroundColor = .darkGray
        stopButton.tintColor = .white
        stopButton.layer.masksToBounds = true
        stopButton.layer.cornerRadius = 10
        stopButton.addTarget(self, action: #selector(stopFunc), for: .touchUpInside)
        return stopButton
    }()

    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        textField.delegate = self
    }
    
    func setupLayout() {
        view.addSubview(verticalStack)
        
        verticalStack.addArrangedSubview(textField)
        verticalStack.addArrangedSubview(activityIndicator)
        verticalStack.addArrangedSubview(label)
        verticalStack.addArrangedSubview(passwordButton)
        verticalStack.addArrangedSubview(stopButton)
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
        self.isRunning = true
       
        password = textField.text ?? ""
        DispatchQueue.main.async {
            self.textField.text = self.password
            self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
            
        }
        DispatchQueue.global().async { [self] in
            self.bruteForce(passwordToUnlock: password)
        }
    }
    
    @objc func stopFunc() {
        self.isRunning = false
        
        DispatchQueue.main.async {
            
            self.label.text = "Ваш пароль \(self.textField.text ?? "") не взломан"
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.textField.isSecureTextEntry = false
        }
    }
    
    //MARK: - Methods

    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
        var password: String = ""
        
        while password != passwordToUnlock && isRunning {
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
            
            DispatchQueue.main.async {
                self.label.text = "Ваш пароль - \(password)"
                self.activityIndicator.startAnimating()
            }
            print(password)
            }
            
        DispatchQueue.main.async {
            self.textField.isSecureTextEntry = false
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        print(password)
        }
    
    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }
    
    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
        : Character("")
    }
    
    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string
        
        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))
            
            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }
        return str
    }
}


