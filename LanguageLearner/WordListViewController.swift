//
//  WordListViewController.swift
//  LanguageLearner
//
//  Created by Stanislav Shut on 09.12.2024.
//

import UIKit
import CoreData

class WordListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var wordsWithTranslations: [(englishWord: String, translation: String)] = []
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Список слов"
        addGradientBackground()
        setupTableView()
        setupNavigationBar()
        loadWordsFromDatabase()
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
    
    // MARK: - Setup UI
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .done, target: self, action: #selector(dismissView))
    }
    
    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Data Loading
    
    private func loadWordsFromDatabase() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Word")
        
        do {
            let fetchedWords = try context.fetch(fetchRequest)
            wordsWithTranslations = fetchedWords.compactMap { word in
                guard let englishWord = word.value(forKey: "englishWord") as? String,
                let translation = word.value(forKey: "translation") as? String else {
                    return nil
                }
                return (englishWord, translation)
            }
            tableView.reloadData()
        } catch {
            print("Ошибка загрузки слов: \(error)")
        }
    }
    // MARK: - TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsWithTranslations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let word = wordsWithTranslations[indexPath.row]
        cell.textLabel?.text = "\(word.englishWord) - \(word.translation)"
        return cell
    }
    
    // MARK: - Редактирование и удаление слов
    func  tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteWord(at: indexPath)
        }
    }
    
    private func deleteWord(at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let wordToDelete = wordsWithTranslations[indexPath.row]
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Word")
        fetchRequest.predicate = NSPredicate(format: "englishWord == %@ AND translation == %@", wordToDelete.englishWord, wordToDelete.translation)
        
        do {
            if let word = try context.fetch(fetchRequest).first {
                context.delete(word)
                try context.save()
                
                // удаляем слово из массива и обновляем таблицу
                wordsWithTranslations.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        } catch {
            print("Ошибка удаления слова: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wordToEdit = wordsWithTranslations[indexPath.row]
        showEditAlert(for: wordToEdit, at: indexPath)
    }
    
    private func showEditAlert(for word: (englishWord: String, translation: String), at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Редактировать слово", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = word.englishWord
        }
        
        alert.addTextField { textField in
            textField.text = word.translation
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            guard let newEnglishWord = alert.textFields?[0].text,
                  let newTranslation = alert.textFields?[1].text else { return }
            self.updateWord(oldWord: word, with: (newEnglishWord, newTranslation), at : indexPath)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func updateWord(oldWord: (englishWord: String, translation: String), with newWord: (englishWord: String, translation: String), at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Word")
        fetchRequest.predicate = NSPredicate(format: "englishWord == %@ AND translation = %@", oldWord.englishWord, oldWord.translation)
        do {
            if let word = try context.fetch(fetchRequest).first {
                word.setValue(newWord.englishWord, forKey: "englishWord")
                word.setValue(newWord.translation, forKey: "translation")
                try context.save()
                
                // обновляем массив и таблицу
                wordsWithTranslations[indexPath.row] = newWord
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        } catch {
            print("Ошибка обновления слова: \(error)")
        }
    }
}
