//
//  WordleViewController.swift
//  WordleStrategy3
//
//  Created by Roger on 2022/3/7.
//

import UIKit

class WordleViewController: UIViewController {
    
    @IBOutlet var guessButtons: [UIButton]!
    
    @IBOutlet var keyboardButtons: [UIButton]!
    
    let MAX_ALPHABET = 30
    let MIN_SEARCH_COUNT = 5
    let WORD_COUNT = 5
    let startingValue = Int(("A" as UnicodeScalar).value)
    var guessDataArray: [AlphabetButtonData]?
    var alphabetIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alphabetIndex = 0
        initGuessGroup()
        initKeyboardButton()
        WordData.shared.initWordRecord()
    }
    
    func initGuessGroup() {
        guessDataArray = [AlphabetButtonData]()
        guessButtons.sort { $0.tag < $1.tag }
        
        for button in guessButtons {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.gray.cgColor
        }
        
        for (index, _) in guessButtons.enumerated() {
            guessDataArray?.append(AlphabetButtonData(index: index, alphabet: "", onChangeValue: onButtonChange))
        }
        
        if let guessDataArray = guessDataArray {
            for data in guessDataArray {
                data.updateState()
            }
        }
    }
    
    func initKeyboardButton() {
        for button in keyboardButtons {
            button.layer.cornerRadius = 5
        }
    }
    
    func onButtonChange(data: AlphabetButtonData) {
//        print("onButtonChange, index:\(data.index), alphabet: \(data.alphabet), state: \(data.state)")
        guessButtons[data.index].setTitle(data.alphabet, for: .normal)
        switch data.state {
        case .notExist:
            guessButtons[data.index].backgroundColor = UIColor(named: "NotExistColor")
        case .correctPosition:
            guessButtons[data.index].backgroundColor = UIColor(named: "CorrectColor")
        case .wrongPostion:
            guessButtons[data.index].backgroundColor = UIColor(named: "WrongPositionColor")
        default:
            guessButtons[data.index].backgroundColor = .clear
        }
    }
    
    @IBAction func onGuessButton(_ sender: UIButton) {
        guard let guessDataArray = guessDataArray else {
            return
        }

        let index = sender.tag
        guessDataArray[index].nextState()
    }
    
    @IBAction func onAlphabet(_ sender: UIButton) {
        guard alphabetIndex < MAX_ALPHABET, let guessDataArray = guessDataArray else {
            return
        }
        
        let index = sender.tag
        if let unicode = UnicodeScalar(index + startingValue) {
            let alphabet = String(unicode)
            
            guessDataArray[alphabetIndex].setAlphabet(alphabet: alphabet)
            alphabetIndex += 1
        }
    }
    
    @IBAction func onDelete(_ sender: Any) {
        guard alphabetIndex > 0, let guessDataArray = guessDataArray else {
            return
        }
        
        alphabetIndex -= 1
        guessDataArray[alphabetIndex].setAlphabet(alphabet: "", state: .none)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        guard alphabetIndex > 0, let guessDataArray = guessDataArray else {
            return
        }
        
        for i in 0..<alphabetIndex {
            guessDataArray[i].setAlphabet(alphabet: "", state: .none)
        }
        alphabetIndex = 0
    }
    
    @IBAction func onSearch(_ sender: Any) {
        guard let guessDataArray = guessDataArray, alphabetIndex >= MIN_SEARCH_COUNT else {
            return
        }
        var correctPositions = Wordle.CorrectType()
        var wrongPositions = Wordle.WrongType()
        var notExists = Wordle.CharArray()
        
        for i in 0..<alphabetIndex {
            let data = guessDataArray[i]
            let wordIndex = data.index % WORD_COUNT
            let addChar = Character(data.alphabet.lowercased())
            switch data.state {
            case .correctPosition:
                if correctPositions[wordIndex] == nil {
                    correctPositions[wordIndex] = addChar
                }
            case .wrongPostion:
                if wrongPositions[wordIndex] == nil {
                    wrongPositions[wordIndex] = [Character]()
                }
                wrongPositions[wordIndex]?.append(addChar)
            case .notExist:
                notExists.append(addChar)
            default: //.none
                continue
            }
        }
        
        let wordle = Wordle(correctLocationChars: correctPositions, wrongLocationChars: wrongPositions, notExistChars: notExists)

        if let resultViewController = storyboard?.instantiateViewController(withIdentifier: "\(ResultViewController.self)") as? ResultViewController,
            let navigationController = navigationController,
            let texts = wordle.playWithDB() {
            resultViewController.text = "搜尋到\(texts.count)筆單字\n \(texts.joined(separator: ", "))"
            navigationController.pushViewController(resultViewController, animated: true)
        }
    }
    
    
}


