//
//  FlashcardsViewController.swift
//  LanguageLearner
//
//  Created by Stanislav Shut on 06.12.2024.
//

import UIKit

class FlashcardsViewController: UIViewController {
    
    // MARK: - Properties
    // Массив слов для изучения
    private let wordsWithTranslations: [(englishWords: String, translations: String)] = [
        ("Apple", "Яблоко"), ("Orange", "Апельсин"), ("Banana", "Банан"), ("Grape", "Виноград"), ("Cherry", "Вишня")
    ]
    
    // Индекс текущей карточки
    private var currentIndex = 0
    
    // Переменная для отслеживания состояния перевода (флаг)
    private var showingTranslation = false
    
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
    
    // MARK: - Функции
    
    // Отображение UI
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
            
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 150),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Кнопка показать перевод
        let toggleTranslationButton = UIButton(type: .system)
        toggleTranslationButton.setTitle("Показать перевод", for: .normal)
        toggleTranslationButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        toggleTranslationButton.backgroundColor = .systemGreen
        toggleTranslationButton.setTitleColor(.white, for: .normal)
        toggleTranslationButton.layer.cornerRadius = 10
        toggleTranslationButton.translatesAutoresizingMaskIntoConstraints = false
        toggleTranslationButton.addTarget(self, action: #selector(toggleTranslation), for: .touchUpInside)
        
        view.addSubview(toggleTranslationButton)
        
        // Констрейнты для кнопки показать перевод
        NSLayoutConstraint.activate([
            toggleTranslationButton.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 20),
            toggleTranslationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleTranslationButton.widthAnchor.constraint(equalToConstant: 200),
            toggleTranslationButton.heightAnchor.constraint(equalToConstant: 50),
            
            nextButton.topAnchor.constraint(equalTo: toggleTranslationButton.bottomAnchor, constant: 20)
        ])
    }
    
    // Отображение текущего слова
    private func showCurrentWord() {
        if currentIndex < wordsWithTranslations.count {
            showingTranslation = false
            wordLabel.text = wordsWithTranslations[currentIndex].englishWords
        } else {
            wordLabel.text = "Вы изучили все слова!"
        }
    }
    
    
    // MARK: - Обработчики нажатия на кнопки
    
    // Обработчик кнопки "Следующая"
    @objc private func nextButtonTapped() {
        if currentIndex < wordsWithTranslations.count - 1 {
            currentIndex += 1
            showCurrentWord()
        } else {
            // Если слов больше нет, сбрасываем индекс
            currentIndex = 0
            showCurrentWord()
        }
    }
    
    // Обработчик кнопки Показать перевод
    @objc private func toggleTranslation() {
        // Переключаем флаг
        showingTranslation.toggle()
        // Обновляем текст на карточке
        if showingTranslation {
            wordLabel.text = wordsWithTranslations[currentIndex].translations
        } else {
            wordLabel.text = wordsWithTranslations[currentIndex].englishWords
        }
    }
}
