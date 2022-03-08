//
//  ResultViewController.swift
//  WordleStrategy3
//
//  Created by Roger on 2022/3/7.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet var resultTextView: UITextView!
    
    var text = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultTextView.text = text
    }
    
}
