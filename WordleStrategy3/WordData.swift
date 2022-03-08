//
//  WordData.swift
//  WordleStrategy3
//
//  Created by Roger on 2022/3/6.
//

import Foundation
import UIKit
import CoreData

class WordData {
    static let shared = WordData()
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WordleStrategy3")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveWord(texts: [String]) {
        print("saveWord")
        let context = persistentContainer.viewContext
        
        for text in texts {
            let db = WordRecord(context: context)
            let alphabets = Array(text)
            db.alphabet0 = String(alphabets[0])
            db.alphabet1 = String(alphabets[1])
            db.alphabet2 = String(alphabets[2])
            db.alphabet3 = String(alphabets[3])
            db.alphabet4 = String(alphabets[4])
        }
        
        persistentContainer.saveContext()
    }
    
    func loadWord() -> [String]? {
        print("loadWord")
        let context = persistentContainer.viewContext
        let request = WordRecord.fetchRequest()
        do {
            let dbs = try context.fetch(request)
//            print("搜尋到\(dbs.count)筆單字")
            if dbs.count > 0 {
                
//                for item in dbs {
//                    print("Word: \(item.fullWord)")
//                }
                return dbs.map { $0.fullWord }
            } else {
                print("no data.")
            }
        } catch {
            print("Fetch db Error.")
        }
        return nil
    }
    
    private func combineArrayToString(dbs: [WordRecord]) -> String {
        return "搜尋到\(dbs.count)筆單字\n \(dbs.map { $0.fullWord }.joined(separator: ","))"
    }
    
    func searchWord(initialAlphabet: String) -> String {
        let context = persistentContainer.viewContext
        let request = WordRecord.fetchRequest()
        let predicate = NSPredicate(format: "alphabet0 == %@", initialAlphabet)
        request.predicate = predicate
        do {
            let dbs = try context.fetch(request)
//            print("搜尋到\(dbs.count)筆單字")
            if dbs.count > 0 {
                return combineArrayToString(dbs: dbs)
                
//                for item in dbs {
//                    print("Word: \(item.fullWord)")
//                }
            } else {
                print("no data.")
            }
        } catch {
            print("Fetch db Error.")
        }
        return "no data"
    }
    
    func searchWord(predicate: NSPredicate) -> [String]? {
        let context = persistentContainer.viewContext
        let request = WordRecord.fetchRequest()
//        let predicate = NSPredicate(format: "alphabet0 == %@ AND NOT (alphabet2 IN %@)", "a", ["k", "p"])
        request.predicate = predicate
        do {
            let dbs = try context.fetch(request)
//            print("搜尋到\(dbs.count)筆單字")
            if dbs.count > 0 {
                
//                for item in dbs {
//                    print("Word: \(item.fullWord)")
//                }
                return dbs.map { $0.fullWord }
            } else {
                print("no data.")
            }
        } catch {
            print("Fetch db Error.")
        }
        return nil
    }
    
    func loadWordFile() -> [String]? {
        guard let data = NSDataAsset(name: "Words")?.data else {
            print("Get file fail")
            return nil
        }
        
        do {
            let text = String(decoding: data, as: UTF8.self)
            return text.components(separatedBy: ",")
        }
    }
    
    func initWordRecord() {
        if loadWord() == nil {
            if let fileTexts = loadWordFile() {
                saveWord(texts: fileTexts)
            }
        }
    }
}

extension WordRecord {
    var fullWord: String {
        guard let alphabet0 = alphabet0,
            let alphabet1 = alphabet1,
            let alphabet2 = alphabet2,
            let alphabet3 = alphabet3,
            let alphabet4 = alphabet4 else {
            return ""
        }
        return "\(alphabet0)\(alphabet1)\(alphabet2)\(alphabet3)\(alphabet4)"
    }
}
