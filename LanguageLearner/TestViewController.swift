//
//  TestViewController.swift
//  LanguageLearner
//
//  Created by Stanislav Shut on 11.12.2024.
//

import UIKit
import CoreData

class TestViewController: UIViewController {
    private let wordLabel: UILabel = {
        let label = UILabel()
        label.text = "Слово"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let translationField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите перевод"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Проверить", for: .normal)
        button.backgroundColor = .systemTeal
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Переменные для хранения текущего слова и базы данных
    private var words: [(String, String)] = []
    private var  currentWordIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        loadWords()
        showNextWord()
        addGradientBackground()
        
        checkButton.addTarget(self, action: #selector(checkTranslation), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.addSubview(wordLabel)
        view.addSubview(translationField)
        view.addSubview(checkButton)
        view.addSubview(resultLabel)
        
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            translationField.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 20),
            translationField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            translationField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            checkButton.topAnchor.constraint(equalTo: translationField.bottomAnchor, constant: 20),
            checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: 150),
            checkButton.heightAnchor.constraint(equalToConstant: 50),
            
            resultLabel.topAnchor.constraint(equalTo: checkButton.bottomAnchor, constant: 20),
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func loadWords() {
        let fetchedWords = CoreDataManager.shared.fetchWords()
        words = fetchedWords.map { ($0.englishWord ?? "", $0.translation ?? "") }
        
        if words.isEmpty {
            wordLabel.text = "Слова не найдены!"
            checkButton.isEnabled = false
        }
    }
    
    private func showNextWord() {
        guard !words.isEmpty else {
            wordLabel.text = "Слова не найдены!"
            checkButton.isEnabled = false
            return
        }
        if currentWordIndex < words.count {
            wordLabel.text = words[currentWordIndex].0
            translationField.text = ""
            resultLabel.text = ""
        } else {
            wordLabel.text = "Тест завершён!"
            checkButton.isEnabled = false
        }
    }
    
    @objc private func checkTranslation() {
        guard currentWordIndex < words.count else { return }
        
        let correctTranslation = words[currentWordIndex].1
        let userTranslation = translationField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if userTranslation.lowercased() == correctTranslation.lowercased() {
            resultLabel.text = "Правильно!"
            resultLabel.textColor = .systemGreen
        } else {
            resultLabel.text = "Неправильно! Правильный перевод: \(correctTranslation)"
            resultLabel.textColor = .systemRed
        }
        currentWordIndex += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showNextWord()
        }
    }
}
