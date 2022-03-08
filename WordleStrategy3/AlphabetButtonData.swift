//
//  AlphabetButtonData.swift
//  WordleStrategy3
//
//  Created by Roger on 2022/3/7.
//

import Foundation

enum AlphabetState {
    case none
    case correctPosition
    case wrongPostion
    case notExist
}

class AlphabetButtonData {
    var index: Int
    var alphabet: String
    var state: AlphabetState
    var onChangeValue: ((AlphabetButtonData) -> Void)?
    
    init(index: Int, alphabet: String, state: AlphabetState = .none, onChangeValue: @escaping (AlphabetButtonData) -> Void) {
        self.index = index
        self.alphabet = alphabet
        self.state = state
        self.onChangeValue = onChangeValue
    }
    
    func setAlphabet(alphabet: String, state: AlphabetState = .notExist) {
        self.alphabet = alphabet
        self.state = state
        onChangeValue?(self)
    }
    
    func nextState() {
        switch state {
        case .notExist:
            state = .correctPosition
        case .correctPosition:
            state = .wrongPostion
        case .wrongPostion:
            state = .notExist
        default:
            state = .none
        }
        if state != .none {
            onChangeValue?(self)
        }
    }
    
    func updateState() {
        onChangeValue?(self)
    }
}
