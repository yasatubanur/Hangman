//
//  ViewController.swift
//  Hangman
//
//  Created by Tuba Nur YAŞA on 18.03.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var countLabel: UILabel!
    @IBOutlet var wordLabel: UILabel!
    var allWords = [String]()
    var selectedWord: String = ""
    var usedCharArray = [String]()
    var tryCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(guessChar))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(retry))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
                retry()
            }
        }
    }
    
    func updateWordLabel() {
        wordLabel.text  = ""
        for letter in selectedWord {
            if usedCharArray.contains("\(letter)") {
                wordLabel.text?.append(letter)
            }else {
                wordLabel.text?.append("?")
            }
        }
    }
    
    @objc func guessChar() {
        let alert = UIAlertController(title: "Guess...", message: "Enter a cahracter", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            guard let guess = alert.textFields?.first?.text else { return }
            guard guess.count == 1 else { return }
            self.usedCharArray.append(guess)
            self.updateTryCount(guess)
            self.updateWordLabel()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert,animated: true)
    }
    
    func updateTryCount(_ guess:String){
        if selectedWord.contains(guess) {
        }else {
            tryCount -= 1
            countLabel.text = "tryCount : \(tryCount)"
            if tryCount == 0{
                let alert = UIAlertController(title: "You are lose the game", message: "Please try Again!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                    self.retry()
                }))
                present(alert,animated: true)
            }
        }
    }
    
    @objc func retry(){
        selectedWord = allWords.randomElement() ?? ""
        print(selectedWord)
        usedCharArray.removeAll()
        updateWordLabel()
        tryCount = selectedWord.count
        countLabel.text = "tryCount: \(tryCount)"
    }
}

