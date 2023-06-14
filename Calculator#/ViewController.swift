//  ViewController.swift
//  Calculator#
//
//  Created by Миржигит Суранбаев on 21/5/23.
//

import UIKit

class ViewController: UIViewController {
    
    var firstNum: String = "" // Первое число
    var operation: String = "" // Оператор (+, -, *, /)
    var secondNum: String = "" // Второе число
    var haveResult: Bool = false // Флаг, указывающий наличие результата
    var resultNumber: String = "" // Результат операции
    var numAfterResult : String = "" // Дополнительное число после результата
    
    
    @IBAction func trash(_ sender: UIButton) {
        // Корзина
        // Очищаем все значения и устанавливаем начальное значение на экране
        firstNum = ""
        operation = ""
        secondNum = ""
        haveResult = false
        resultNumber = ""
        numAfterResult = ""
        numOnScreen.text = "0"
        historyView.text = "0"
        
        // Очищаем историю операций в UserDefaults
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "operationHistory")
        defaults.synchronize()
    }
    @IBOutlet weak var removeLast: UIButton! // Удаление последнего числа в resultView
    
    @IBAction func removeNumberLast(_ sender: UIButton) {
        // Действие для удаления последней цифры (не реализовано в данном коде)
        if operation == "" {
            // Если оператор не выбран, удаляем последнюю цифру из первого числа
            if !firstNum.isEmpty {
                firstNum.removeLast()
                numOnScreen.text = firstNum
            }
        } else if operation != "" && !haveResult {
            // Если оператор выбран и результата еще нет, удаляем последнюю цифру из второго числа
            if !secondNum.isEmpty {
                secondNum.removeLast()
                numOnScreen.text = secondNum
            }
        } else if operation != "" && haveResult {
            // Если оператор выбран и есть результат, удаляем последнюю цифру из числа после результата
            if !numAfterResult.isEmpty {
                numAfterResult.removeLast()
                numOnScreen.text = numAfterResult
            }
        }
        
    }
    
    @IBOutlet weak var numOnScreen: UILabel!
    @IBOutlet weak var historyView: UITextView!
    
    @IBAction func numPressed(_ sender: UIButton) {
        if operation == "" {
            // Если оператор не выбран, добавляем цифры к первому числу
            firstNum += String(sender.tag)
            numOnScreen.text = firstNum
        }
        else if operation != "" && !haveResult {
            // Если оператор выбран, но результата еще нет, добавляем цифры ко второму числу
            secondNum += String(sender.tag)
            numOnScreen.text = secondNum
        }
        else if operation != "" && haveResult {
            // Если оператор выбран и есть результат, добавляем цифры к дополнительному числу после результата
            numAfterResult += String(sender.tag)
            numOnScreen.text = numAfterResult
            numOnScreen.text = "\n"
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        // Очищаем все значения и устанавливаем начальное значение на экране
        firstNum = ""
        operation = ""
        secondNum = ""
        haveResult = false
        resultNumber = ""
        numAfterResult = ""
        numOnScreen.text = "0"
    }
    
    @IBAction func add(_ sender: Any) {
        operation = "+" // Устанавливаем оператор сложения
    }
    
    @IBAction func subtract(_ sender: Any) {
        operation = "-" // Устанавливаем оператор вычитания
    }
    
    @IBAction func multiple(_ sender: Any) {
        operation = "*" // Устанавливаем оператор умножения
    }
    
    @IBAction func divide(_ sender: Any) {
        operation = ":" // Устанавливаем оператор деления
    }
    
    @IBAction func equal(_ sender: Any) {
        resultNumber = String(doOperation()) // Выполняем операцию и получаем результат
        let numArray = resultNumber.components(separatedBy: ".") // Разбиваем число на целую и десятичную части
        
        // Убираем ".0" из десятичной части числа
        resultNumber = resultNumber.replacingOccurrences(of: ".0", with: "")
        
        let operationHistory = firstNum + operation + secondNum + "=" + resultNumber
        
        if historyView.text == "0" {
            historyView.text = ""
        } else {
            historyView.text += "\n"
        }
        
        historyView.text += operationHistory
        
        // Сохраняем историю операций в UserDefaults
        let defaults = UserDefaults.standard
        let savedHistory = defaults.string(forKey: "operationHistory")
        let updatedHistory = (savedHistory ?? "") + "\n" + operationHistory
        defaults.set(updatedHistory, forKey: "operationHistory")
        defaults.synchronize()
        
        if numArray[1] == "0" {
            numOnScreen.text = numArray[0] // Если десятичная часть равна 0, выводим только целую часть
        }
        else {
            numOnScreen.text = resultNumber // Иначе выводим полный результат
        }
        
        firstNum = resultNumber // Устанавливаем результат как первое число для последующих операций
        operation = "" // Сбрасываем оператор
        secondNum = "" // Сбрасываем второе число
        haveResult = false // Сбрасываем флаг наличия результата
        numAfterResult = "" // Очищаем дополнительное число после результата
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numOnScreen.text = "0" // Устанавливаем начальное значение на экране
        
        // Восстанавливаем историю операций из UserDefaults
        let defaults = UserDefaults.standard
        if let savedHistory = defaults.string(forKey: "operationHistory") {
            historyView.text = savedHistory
        }
    }
    
    func doOperation() -> Double {
        if operation == "+" {
            if !haveResult {
                haveResult = true
                return Double(firstNum)! + Double(secondNum)! // Складываем два числа
            } else {
                return Double(resultNumber)! + Double(numAfterResult)! // Складываем результат с дополнительным числом
            }
        } else if operation == "-" {
            if !haveResult {
                haveResult = true
                return Double(firstNum)! - Double(secondNum)! // Вычитаем второе число из первого
            } else {
                return Double(resultNumber)! - Double(numAfterResult)! // Вычитаем дополнительное число из результата
            }
        } else if operation == "*" {
            if !haveResult {
                haveResult = true
                return Double(firstNum)! * Double(secondNum)! // Умножаем два числа
            } else {
                return Double(resultNumber)! * Double(numAfterResult)! // Умножаем результат на дополнительное число
            }
        } else if operation == ":" {
            if !haveResult {
                haveResult = true
                if Double(secondNum)! == 0 {
                    // Обработка деления на ноль
                    // Возвращаем ноль или выполняем другое действие
                    return 0
                }
                let result = Double(firstNum)! / Double(secondNum)! // Делим первое число на второе
                return formatResult(result)
            } else {
                if Double(numAfterResult)! == 0 {
                    // Обработка деления на ноль
                    // Возвращаем ноль или выполняем другое действие
                    return 0
                }
                let result = Double(resultNumber)! / Double(numAfterResult)! // Делим результат на дополнительное число
                return formatResult(result)
            }
        }
        return 0
    }
    
    func formatResult(_ number: Double) -> Double {
        let formattedNumber = String(format: "%.3f", number) // Форматируем число с тремя десятичными знаками
        return Double(formattedNumber)!
    }
}
