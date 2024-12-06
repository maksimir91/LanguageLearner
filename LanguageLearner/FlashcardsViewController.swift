//
//  FlashcardsViewController.swift
//  LanguageLearner
//
//  Created by Stanislav Shut on 06.12.2024.
//

import UIKit

class FlashcardsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIFlashcards()
    }
    
    private func setupUIFlashcards() {
        // Цвет фона
        view.backgroundColor = .white
        
        // Заголовок экрана
        title = "Флэш-карточки"
        
        // Пример элемента интерфейса
        let label = UILabel()
        label.text = "Тут будут карточки!"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавляем вью на экран
        view.addSubview(label)
        
        // Констрейнты
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}
