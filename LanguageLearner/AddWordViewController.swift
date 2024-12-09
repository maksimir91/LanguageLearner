//
//  AddWordViewController.swift
//  LanguageLearner
//
//  Created by Stanislav Shut on 09.12.2024.
//

import UIKit

class AddWordViewController: UIViewController {
    
    // MARK: - UI Elements
    private let englishTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите слово на английском"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let translationTextField: UITextField = {
       let textField = UITextField()
        textField.placeholder = "Введите перевод"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.backgroundColor = .systemTeal
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var onSave: ((String, String) -> Void)?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIAddWord()
        addGradientBackground()
    }
    
    // MARK: - Setup UI
    private func setupUIAddWord() {
        view.backgroundColor = .white
        title = "Добавить слово"
        
        
        // Добавляем элементы на экран
        view.addSubview(englishTextField)
        view.addSubview(translationTextField)
        view.addSubview(saveButton)
        
        // Настраиваем констрейнты
        NSLayoutConstraint.activate([
            englishTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            englishTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            englishTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            englishTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            translationTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            translationTextField.topAnchor.constraint(equalTo: englishTextField.bottomAnchor, constant: 20),
            translationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            translationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: translationTextField.bottomAnchor, constant: 30),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // Метод для добавления градиента
    private func addGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Actions
    
    @objc private func saveButtonTapped() {
        guard let englishWord = englishTextField.text, !englishWord.isEmpty, let translation = translationTextField.text, !translation.isEmpty else { showAlert(title: "Ошибка", message: "Заполните оба поля")
            return
        }
        // Передаем слово и перевод через замыкание
        onSave?(englishWord, translation)
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert,animated: true, completion: nil)
    }
    
}
