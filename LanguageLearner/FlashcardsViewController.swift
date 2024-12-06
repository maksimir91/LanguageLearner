//
//  FlashcardsViewController.swift
//  LanguageLearner
//
//  Created by Stanislav Shut on 06.12.2024.
//

import UIKit

class FlashcardsViewController: UIViewController {
    
    // Массив слов для изучения
    private let words = ["Apple", "Orange", "Banana", "Grape", "Cherry"]
    
    // Индекс текущей карточки
    private var currentIndex = 0
    
    // Метка для отображения текста
    private let wordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIFlashcards() // отображаем UI
        showCurrentWord() // отображаем первую карточку
    }
    
    private func setupUIFlashcards() {
        // Цвет фона
        view.backgroundColor = .white
        
        // Заголовок экрана
        title = "Флэш-карточки"
        
        // Добавляем метку на экран
        view.addSubview(wordLabel)
        
        // Кнопка "Следующая карточка"
        let nextButton = UIButton(type: .system)
        nextButton.setTitle("Следующая", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        nextButton.backgroundColor = .systemBlue
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 10
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            wordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            wordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nextButton.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 20),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 150),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Пример элемента интерфейса
//        let label = UILabel()
//        label.text = "Тут будут карточки!"
//        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Добавляем вью на экран
//        view.addSubview(label)
//        
//        // Констрейнты
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
    }
    
    // Отображение текущего слова
    private func showCurrentWord() {
        if currentIndex < words.count {
            wordLabel.text = words[currentIndex]
        } else {
            wordLabel.text = "Вы изучили все слова!"
        }
    }
    
    // Обработчик кнопки "Следующая"
    @objc private func nextButtonTapped() {
        if currentIndex < words.count - 1 {
            currentIndex += 1
            showCurrentWord()
        } else {
            // Если слов больше нет, сбрасываем индекс
            currentIndex = 0
            showCurrentWord()
        }
    }
}
