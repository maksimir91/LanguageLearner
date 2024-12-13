//
//  CoreDataManager.swift
//  LanguageLearner
//
//  Created by Stanislav Shut on 13.12.2024.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LanguageLearnerModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Ошибка загрузки Core Data: \(error)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do {
                try context.save()
            } catch {
                print("Ошибка сохранения контекста: \(error)")
            }
        }
    }
    
    func fetchWords() -> [Word] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Word> = Word.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Ошибка загрузки слов: \(error)")
            return []
        }
    }
    
    func deleteWord(_ word: Word) {
        let context = persistentContainer.viewContext
        context.delete(word)
        saveContext()
    }
    
    func updateWord(_ word: Word, englishWord: String, translation: String) {
        word.englishWord = englishWord
        word.translation = translation
        saveContext()
    }
    
    func addWord(englishWord: String, translation: String) {
        let context = persistentContainer.viewContext
        let newWord = Word(context: context)
        newWord.englishWord = englishWord
        newWord.translation = translation
        saveContext()
    }
    
}

