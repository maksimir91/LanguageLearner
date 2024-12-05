//
//  ViewController.swift
//  LanguageLearner
//
//  Created by Stanislav Shut on 05.12.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        // Устанавливаем цвет фона
        view.backgroundColor = .white
        // Создаем заголовок
        let titleLable = UILabel()
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.text = "Language Learner"
        titleLable.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLable.textAlignment = .center
        
        // Кнопки
        let flashCardsButton = createButton(withTitle: "Флэш-карточки")
        let addWordsButton = createButton(withTitle: "Добавить слова")
        let testButton = createButton(withTitle: "Тесты")
        
        // Стек для упрощения расположения
        let stackView = UIStackView(arrangedSubviews: [titleLable, flashCardsButton, addWordsButton, testButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
     
        // Добавляем стек на экран
        view.addSubview(stackView)
        
        // Устанавливаем констрейнты
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            flashCardsButton.widthAnchor.constraint(equalToConstant: 200),
            addWordsButton.widthAnchor.constraint(equalToConstant: 200),
            testButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    // Метод для создания кнопок
    private func createButton(withTitle title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
    }
    
}

