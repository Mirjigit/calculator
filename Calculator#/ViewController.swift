//
//  ViewController.swift
//  Calculator#
//
//  Created by Миржигит Суранбаев on 21/5/23.
//

import UIKit

class ViewController: UIViewController {

    var firstNum: String = ""
    var operation: String = ""
    var secondNum: String = ""
    var haveResult: Bool = false
    var resultNumber: String = ""
    var numAfterResult : String = ""
    
    @IBOutlet weak var removeLast: UIButton!
    
    @IBAction func removeNumberLast(_ sender: UIButton) {
        
        firstNum.count = firstNum.removeLast()
        secondNum.count = secondNum.removeLast()
    }
    @IBOutlet weak var numOnScreen: UILabel!
    
    @IBOutlet weak var historyView: UITextView!
    @IBAction func numPressed(_ sender: UIButton) {
        if operation == "" {
            
            firstNum += String(sender.tag)
            numOnScreen.text = firstNum
        }
        else if operation != "" && !haveResult{
            secondNum += String(sender.tag)
            numOnScreen.text = secondNum
        }
        else if operation != "" && haveResult{
            numAfterResult += String(sender.tag)
            numOnScreen.text = numAfterResult
        }
    }
    @IBAction func clear(_ sender: Any) {
        firstNum = ""
        operation = ""
        secondNum = ""
        haveResult = false
        resultNumber = ""
        numAfterResult = ""
        numOnScreen.text = "0"
    }
    
    @IBAction func add(_ sender: Any) {
    operation = "+"
    }
    @IBAction func subtract(_ sender: Any) {
        operation = "-"
    }
    @IBAction func multiple(_ sender: Any) {
        operation = "*"
    }
    @IBAction func divide(_ sender: Any) {
        operation = "/"
    }
    @IBAction func equal(_ sender: Any) {
        resultNumber = String(doOperation())
        let numArray = resultNumber.components(separatedBy: ".")
        print(numArray)
        
        if historyView.text == "0" {
            historyView.text = ""
            historyView.text += firstNum + operation + secondNum + "=" + resultNumber + "\n"
        }else{
            historyView.text += firstNum + operation + secondNum + "=" + resultNumber
        }
        
        if numArray[1] == "0"{
            numOnScreen.text = numArray[0]
        }
        else{
            numOnScreen.text = resultNumber
        }
        firstNum = resultNumber
        numAfterResult = ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func doOperation() -> Double{
        if operation == "+" {
            if !haveResult {
                haveResult = true
                return Double(firstNum)! + Double(secondNum)!
            }
            else {
                return Double(resultNumber)! +
                Double(numAfterResult)!
            }
        }
        else if operation == "-" {
            if !haveResult {
                haveResult = true
                return Double(firstNum)! - Double(secondNum)!
            }
            else {
                return Double(resultNumber)! - Double(numAfterResult)!
            }
        }
        else if operation == "*" {
            if !haveResult {
                haveResult = true
                return Double(firstNum)! * Double(secondNum)!
            }
            else {
                return Double(resultNumber)! * Double(numAfterResult)!
            }
        }
        else if operation == "/" {
            if !haveResult {
                haveResult = true
                return Double(firstNum)! / Double(secondNum)!
            }
            else {
                return Double(resultNumber)! / Double(numAfterResult)!
            }
        }
        return 0
    }
}
