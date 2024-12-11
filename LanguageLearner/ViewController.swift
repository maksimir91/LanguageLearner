//
//  ViewController.swift
//  LanguageLearner
//
//  Created by Stanislav Shut on 05.12.2024.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addGradientBackgroundMain()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animatedContentAppearence()
    }
    
    private func setupUI() {
        // Устанавливаем цвет фона
        view.backgroundColor = .white
        // Создаем заголовок
        let titleLable = UILabel()
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.text = "Language Learner"
        titleLable.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLable.textAlignment = .center
        titleLable.textColor = .white
        titleLable.layer.shadowColor = UIColor.black.cgColor
        titleLable.layer.shadowOpacity = 0.5
        titleLable.layer.shadowOffset = CGSize(width: 2, height: 2)
        titleLable.layer.shadowRadius = 3
        
        // Кнопки
        let flashCardsButton = createButton(withTitle: "Флэш-карточки", imageName: "flashcards")
        let addWordsButton = createButton(withTitle: "Добавить слова", imageName: "addWords")
        let testButton = createButton(withTitle: "Тесты", imageName: "tests")
        
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
    private func createButton(withTitle title: String, imageName: String) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.image = UIImage(named: imageName)?.resize(to: CGSize(width: 30, height: 30))
        configuration.baseBackgroundColor = .systemOrange
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .medium
        configuration.imagePadding = 10 // расстояние между текстом и иконкой
        configuration.titleAlignment = .center
        
        let button = UIButton(configuration: configuration,primaryAction: nil)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addAction(UIAction {[weak self] _ in
            self?.buttonTapped(withTitle: title)}, for: .touchUpInside)
        
        return button
    }
    
    // Метод для добавления градиента - ДУБЛИРУЕТСЯ(DRY)
    private func addGradientBackgroundMain() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func animatedContentAppearence() {
        view.subviews.forEach { $0.alpha = 0 } // Начинаем с прозрачности
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut]) {
            self.view.subviews.forEach { $0.alpha = 1 } // Плавно увеличиваем прозрачность
        }
    }
    
    // Метод для добавления нового слова
    private func addNewWord(englishWord: String, translation: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let newWord = NSEntityDescription.insertNewObject(forEntityName: "Word", into: context)
        newWord.setValue(englishWord, forKey: "englishWord")
        newWord.setValue(translation, forKey: "translation")
        
        do {
            try context.save()
            print("Слово сохранено: \(englishWord) - \(translation)")
        } catch {
            print("Ошибка сохранения: \(error)")
        }
    }

    private func buttonTapped(withTitle title: String) {
        if title == "Флэш-карточки" {
            let flashcardsVc = FlashcardsViewController()
            navigationController?.pushViewController(flashcardsVc, animated: true)
        } else if title == "Добавить слова" {
            // переход
            let addWordVC = AddWordViewController()
            
            // передаем замыкание для сохранения новых слов
            addWordVC.onSave = { [weak self] englishWord, translation in
                self?.addNewWord(englishWord: englishWord, translation: translation)
            }
            navigationController?.pushViewController(addWordVC, animated: true)
        } else if title == "Тесты" {
            //переход
            let testVC = TestViewController()
            navigationController?.pushViewController(testVC, animated: true)
        }
    }
}

