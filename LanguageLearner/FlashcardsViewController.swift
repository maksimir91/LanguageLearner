//
//  FlashcardsViewController.swift
//  LanguageLearner
//
//  Created by Stanislav Shut on 06.12.2024.
//

import UIKit
import CoreData

class FlashcardsViewController: UIViewController {
    
    // MARK: - Properties
    // Массив слов для изучения
    private var wordsWithTranslations: [(englishWords: String, translations: String)] = []
    
    // Индекс текущей карточки
    private var currentIndex = 0
    
    // Переменная для отслеживания состояния перевода (флаг)
    private var showingTranslation = false
    
    private var toggleTranslationButton: UIButton!
    
    // Метка для отображения текста
    private let wordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        addGradientBackground() // добавляем градиент
        setupUIFlashcards() // отображаем UI
        loadWordsFromDatabase() // загрузка из базы данных
        showCurrentWord() // отображаем первую карточку
    }
    
    // MARK: - Методы
    
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
        nextButton.backgroundColor = .systemOrange
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 10
        nextButton.layer.shadowColor = UIColor.black.cgColor
        nextButton.layer.shadowOpacity = 0.2
        nextButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        nextButton.layer.shadowRadius = 5
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            wordLabel.widthAnchor.constraint(equalToConstant: 300),
            wordLabel.heightAnchor.constraint(equalToConstant: 250),
            
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 250),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Кнопка показать перевод
        toggleTranslationButton = UIButton(type: .system)
        toggleTranslationButton.setTitle("Показать перевод", for: .normal)
        toggleTranslationButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        toggleTranslationButton.backgroundColor = .systemTeal
        toggleTranslationButton.setTitleColor(.white, for: .normal)
        toggleTranslationButton.layer.cornerRadius = 10
        toggleTranslationButton.layer.shadowColor = UIColor.black.cgColor
        toggleTranslationButton.layer.shadowOpacity = 0.2
        toggleTranslationButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        toggleTranslationButton.layer.shadowRadius = 5
        toggleTranslationButton.translatesAutoresizingMaskIntoConstraints = false
        toggleTranslationButton.addTarget(self, action: #selector(toggleTranslation), for: .touchUpInside)
        
        view.addSubview(toggleTranslationButton)
        
        // Констрейнты для кнопки показать перевод
        NSLayoutConstraint.activate([
            toggleTranslationButton.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 20),
            toggleTranslationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toggleTranslationButton.widthAnchor.constraint(equalToConstant: 250),
            toggleTranslationButton.heightAnchor.constraint(equalToConstant: 50),
            
            nextButton.topAnchor.constraint(equalTo: toggleTranslationButton.bottomAnchor, constant: 20)
        ])
    }
    
    // Отображение текущего слова
    private func showCurrentWord() {
        guard currentIndex < wordsWithTranslations.count else {
            wordLabel.text = "Вы изучили все слова!"
            return
        }
        // Цвета карточек - случайные
        let currentColor = UIColor(red: CGFloat.random(in: 0.3...1), green: CGFloat.random(in: 0.3...1), blue: CGFloat.random(in: 0.3...1), alpha: 1.0)
        
        // Анимация исчезновения
        UIView.animate(withDuration: 0.3, animations: {
            self.wordLabel.alpha = 0.0 // скрываем текст
        }) {
            _ in
            // Обновляем текст после завершения анимации исчезновения
            self.wordLabel.text = self.showingTranslation ? self.wordsWithTranslations[self.currentIndex].translations : self.wordsWithTranslations[self.currentIndex].englishWords
            
            // Анимация появления
            UIView.animate(withDuration: 0.3) {
                self.wordLabel.backgroundColor = currentColor // меняем цвет фона
                self.wordLabel.alpha = 1.0 // показываем новый текст
            }
        }
        
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
    
    // Метод добавления новых слов
    func addWord(english: String, translation: String) {
        loadWordsFromDatabase()
        showCurrentWord()
    }
    
    // Метод для дефолтных слов в базе данных, если она пуста
    private func setupDefaultWords(in context: NSManagedObjectContext) {
        let defaultWords = [
            ("Apple", "Яблоко"), ("Orange", "Апельсин"), ("Banana", "Банан"), ("Grape", "Виноград"), ("Cherry", "Вишня"),("CatPoopHead", "Коська-какаська")
        ]
        
        for word in defaultWords {
            let newWord = NSEntityDescription.insertNewObject(forEntityName: "Word", into: context)
            newWord.setValue(word.0, forKey: "englishWord")
            newWord.setValue(word.1, forKey: "translation")
        }
        
        do {
            try context.save()
            print("Данные по умолчанию успешно добавлены.")
            wordsWithTranslations = defaultWords
        } catch {
            print("Ошибка добавления данных по умолчанию: \(error)")
        }
    }
    
    // Метод загрузки слов из базы данных
    private func loadWordsFromDatabase() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Word")
        
        do {
            let fetchedWords = try context.fetch(fetchRequest)
  
            // Если база данных пустая, используем данные по умолчанию
            if fetchedWords.isEmpty {
                setupDefaultWords(in: context)
            } else {
                // загружаем слова из базы данных
                wordsWithTranslations = fetchedWords.compactMap { word in
                    guard let englishWord = word.value(forKey: "englishWord") as? String,
                          let translation = word.value(forKey: "translation") as? String else {
                        return nil
                    }
                    return (englishWord, translation)
                }
                wordsWithTranslations.shuffle()
            }
        } catch {
            print("Ошибка загрузки слов: \(error)")
        }
    }
    
    
    
    // MARK: - Обработчики нажатия на кнопки
    
    // Обработчик кнопки "Следующая"
    @objc private func nextButtonTapped() {
        if currentIndex < wordsWithTranslations.count - 1 {
            currentIndex += 1
        } else {
            // Если слов больше нет, сбрасываем индекс
            currentIndex = 0
            wordsWithTranslations.shuffle()
        }
        showCurrentWord()
    }
    
    // Обработчик кнопки Показать перевод
    @objc private func toggleTranslation() {
        // Переключаем флаг
        showingTranslation.toggle()
        // Обновляем текст на карточке
        if showingTranslation {
            wordLabel.text = wordsWithTranslations[currentIndex].translations
            // меняем текст кнопки
            toggleTranslationButton.setTitle("Скрыть перевод", for: .normal)
        } else {
            wordLabel.text = wordsWithTranslations[currentIndex].englishWords
            // меняем текст кнопки
            toggleTranslationButton.setTitle("Показать перевод", for: .normal)
        }
    }
    
}
