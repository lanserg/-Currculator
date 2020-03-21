//
//  SecondViewController.swift
//  ParsJSON
//
//  Created by Elena Nazarova on 28.November.19.
//  Copyright © 2019 Elena Nazarova. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var picker2: UIPickerView!
    @IBOutlet weak var picker1: UIPickerView!
    @IBOutlet weak var exchangeB: UIButton!
    
    // кнопка обмена валюты
    
    let saving = UserDefaults.standard // UserDefault для сохранения пользовательских данных
    
    @IBAction func exchangeBtn(_ sender: UIButton) {  // ПОСЛЕ ОБМЕНА СБРАСЫВАЮТСЯ ПИКЕРЫ
        
        if (textFieldLbl.text != "0") {
            print(pickerValue1, pickerValue2)
            switch pickerValue1 {
            case "UAH":
    
                switch pickerValue2 {
                    case "USD":
                        prepareForChangeStraight(character: "/", value: arrayOfData[2])
                        equal()
                    case "EUR":
                        prepareForChangeStraight(character: "/", value: arrayOfData[0])
                        equal()
                    case "RUB":
                        prepareForChangeStraight(character: "/", value: arrayOfData[4])
                        equal()
                    default:
                        break
            }
            case "USD":
                
                switch pickerValue2 {
                          case "UAH":
                              prepareForChangeStraight(character: "*", value: arrayOfData[3])
                              equal()
                          case "EUR":
                            prepareForChangeStraight(character: "*", value: arrayOfData[3])
                            equal()
                            prepareForChangeStraight (character: "/", value: arrayOfData[0])
                              equal()
                          case "RUB":
                            prepareForChangeStraight(character: "*", value: arrayOfData[3])
                            equal()
                              prepareForChangeStraight (character: "/", value: arrayOfData[4])
                              equal()
                          default:
                              break
                  }
            case "EUR":
                
                switch pickerValue2 {
                          case "UAH":
                              prepareForChangeStraight (character: "*", value: arrayOfData[1])
                              equal()
                          case "USD":
                            prepareForChangeStraight (character: "*", value: arrayOfData[1])
                            equal()
                              prepareForChangeStraight(character: "/", value: arrayOfData[2])
                              equal()
                          case "RUB":
                            prepareForChangeStraight (character: "*", value: arrayOfData[1])
                            equal()
                              prepareForChangeStraight(character: "/", value: arrayOfData[4])
                              equal()
                          default:
                              break
                  }
            case "RUB":
                
                switch pickerValue2 {
                          case "USD":
                            prepareForChangeStraight (character: "*", value: arrayOfData[5])
                            equal()
                              prepareForChangeStraight(character: "/", value: arrayOfData[2])
                              equal()
                          case "EUR":
                            prepareForChangeStraight (character: "*", value: arrayOfData[5])
                            equal()
                              prepareForChangeStraight(character: "/", value: arrayOfData[0])
                              equal()
                          case "UAH":
                              prepareForChangeStraight (character: "*", value: arrayOfData[5])
                              equal()
                          default:
                              break
                  }
            default:
                break
        }
    }
        saving.set(textFieldLbl.text, forKey: "TEXT")  // сохраняем результат обмена валют в текстовом поле

}
  
    // подготовка массива для произведения прямой операции обмена валют
    
    func prepareForChangeStraight (character: String, value: String) {
        let curr = textFieldLbl.text
        arraySum.append(curr!)
        arraySum.append(character)
        arraySum.append(value)
    }
    
    // массив для пикера выбора валюты
    
    var arrayOfCurrencyes : [String] = ["USD", "UAH", "EUR", "RUB"]
    var arrayOfCurrencyes2 : [String] = ["USD", "UAH", "EUR", "RUB"]
    
    //функции пикера
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayOfCurrencyes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return arrayOfCurrencyes.count
        } else {
            return arrayOfCurrencyes2.count
        }
    }

    var pickerValue1 = ""
    var pickerValue2 = ""
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            pickerValue1 = arrayOfCurrencyes [row]
            saving.set(row, forKey: "currencyOne")
        } else  {
            pickerValue2 = arrayOfCurrencyes2 [row]
            saving.set(row, forKey: "currencyTwo")
        }
    }
    
    
    
    
    
    @IBOutlet weak var textFieldLbl: UITextField!
    
    @IBOutlet weak var ACOutlet: UIButton!
    @IBOutlet weak var PercentOutlet: UIButton!
    @IBOutlet weak var PlusMinusOutlet: UIButton!
    @IBOutlet weak var PlusOutlet: UIButton!
    @IBOutlet weak var OneOutlet: UIButton!
    @IBOutlet weak var TwoOutlet: UIButton!
    @IBOutlet weak var ThreeOutlet: UIButton!
    @IBOutlet weak var MinusOutlet: UIButton!
    @IBOutlet weak var FoutOutlet: UIButton!
    @IBOutlet weak var FiveOutlet: UIButton!
    @IBOutlet weak var SixOutlet: UIButton!
    @IBOutlet weak var MultiOutlet: UIButton!
    @IBOutlet weak var SevenOutlet: UIButton!
    
    var numberOne : String = ""   //первое число в выражении и число для вывода на экран калькулятора
    var numberTwo : String = "" // вророе число в выражении
    var arraySum : [String] = [] // массив для хранения элементов выражения
    var resultNum = ""          // результат выражения
    var arrayOfData : [String] = [] // данные с первого VC для подсчета кросс курсов
    
    // кнопки калькулятора
    
    @IBAction func ACButton(_ sender: Any) {
        saving.removeObject(forKey: "TEXT")
        textFieldLbl.text = "0"
        numberOne = ""
        numberTwo = ""
        resultNum = ""
        arraySum.removeAll()
    }
    
    @IBAction func OneBtn(_ sender: Any) {
        numbers(element: "1")
    }
    
    @IBAction func TwoBtn(_ sender: Any) {
        numbers(element: "2")
    }
    
    @IBAction func ThreeBtn(_ sender: Any) {
        numbers(element: "3")
    }
    
    @IBAction func FourBtn(_ sender: Any) {
        numbers(element: "4")
    }
    
    @IBAction func FiveBtn(_ sender: Any) {
        numbers(element: "5")
    }
    
    @IBAction func SixBtn(_ sender: Any) {
        numbers(element: "6")
    }
    
    @IBAction func SevenBtn(_ sender: Any) {
        numbers(element: "7")
    }
    
    @IBAction func EightBtn(_ sender: Any) {
        numbers(element: "8")
    }
    
    @IBAction func NineBtn(_ sender: Any) {
        numbers(element: "9")
    }
    
   // ноль выводится по особым правилам
    
    @IBAction func ZeroBtn(_ sender: Any) {
        if (arraySum.count == 0) {
            if (numberOne.count >= 1 && numberOne[numberOne.startIndex] == "0" && !(numberOne.contains("."))) {
                
            } else {
                numberOne += "0"
                textFieldLbl.text = numberOne
            }
        } else {
            if (numberTwo.count >= 1 && numberTwo[numberTwo.startIndex] == "0" && !(numberTwo.contains("."))) {
                
            } else {
                numberOne += "0"
                numberTwo += "0"
                textFieldLbl.text = numberOne
            }
        }
    }
   
    // точка в числе не везде может стоять
    
    @IBAction func PointBtn(_ sender: Any) {
        if (arraySum.count == 0) {
            if (numberOne.count >= 1 && !(numberOne.contains("."))) {
                numberOne += "."
                textFieldLbl.text = numberOne
            } else if (numberOne.count == 0) {
                numberOne += "0."
                textFieldLbl.text = numberOne
            }
        } else {
            if (numberTwo.count >= 1 && !(numberTwo.contains("."))) {
            numberTwo += "."
            numberOne += "."
            textFieldLbl.text = numberOne
           }
        }
    }
    
    // равно
    
    @IBAction func EqualBtn(_ sender: Any) {
        if (arraySum.isEmpty == false && arraySum.count == 2) {
        arraySum.append(numberTwo)
        equal()
        print(arraySum)
        }
    }
    
    // деление
    
    @IBAction func DevideBtn(_ sender: Any) {
        if (arraySum.isEmpty == true) {
        if (resultNum.isEmpty == true) {
            if (checkTextfield() == true) {
                }
                    else {
                    process(symbol: "/")
                }
            } else {
          numberOne = resultNum
            resultNum = ""
            process(symbol: "/")
                print(arraySum)
        }
    } else if (arraySum.isEmpty == false && arraySum.count == 2 && numberTwo.count > 0) {
                      arraySum.append(numberTwo)
                      equal()
                      numberOne = resultNum
                      process(symbol: "/")
                      print(arraySum)
           }
}
    // умножение
    
    @IBAction func MultiBtn(_ sender: Any) {
        if (arraySum.isEmpty == true) {
           if (resultNum.isEmpty == true) {
                if (checkTextfield() == true) {
                    }
                        else {
                        process(symbol: "*")
                    }
                } else {
                    numberOne = resultNum
                    resultNum = ""
                        process(symbol: "*")
                    print(arraySum)
            }
        } else if (arraySum.isEmpty == false && arraySum.count == 2 && numberTwo.count > 0) {
                   arraySum.append(numberTwo)
                   equal()
                   numberOne = resultNum
                   process(symbol: "*")
                   print(arraySum)
        }
    }
    // минус
    
    @IBAction func MinusBtn(_ sender: Any) {
        if (arraySum.isEmpty == true) {
        if (resultNum.isEmpty == true) {
                if (checkTextfield() == true) {
                    }
                        else {
                        process(symbol: "-")
                    }
                } else {
                  numberOne = resultNum
                  resultNum = ""
                  process(symbol: "-")
                    print(arraySum)
            }
        } else if (arraySum.isEmpty == false && arraySum.count == 2 && numberTwo.count > 0) {
                   arraySum.append(numberTwo)
                   equal()
                   numberOne = resultNum
                   process(symbol: "-")
                   print(arraySum)
        }
    }
   
    // плюс
    
    @IBAction func PlusBtn(_ sender: Any) {
        if (arraySum.isEmpty == true) {
        if (resultNum.isEmpty == true) {
                if (checkTextfield() == true) {
                    }
                        else {
                        process(symbol: "+")
                    }
                } else {
                 numberOne = resultNum
                 resultNum = ""
                 process(symbol: "+")
                    print(arraySum)
            }
        } else if (arraySum.isEmpty == false && arraySum.count == 2 && numberTwo.count > 0) {
                   arraySum.append(numberTwo)
                   equal()
                   numberOne = resultNum
                   process(symbol: "+")
                   print(arraySum)
        }
}
    
    @IBAction func PlusMinusBtn(_ sender: Any) {
        let minus : String = "-"
        if (arraySum.isEmpty == true && numberOne.count > 0) {
             numberOne = minus + numberOne
            textFieldLbl.text = numberOne
            print(arraySum)
        } else if (resultNum.isEmpty == false) {
            if (resultNum[resultNum.startIndex] == Character("-")){
                resultNum.remove(at: resultNum.startIndex)
                textFieldLbl.text = resultNum
            } else {
                resultNum = minus + resultNum
                textFieldLbl.text = resultNum
            }
        }
    }
    
    @IBAction func PercentBtn(_ sender: Any) {
        if (arraySum.isEmpty == true && numberOne.count > 0) {
            arraySum.append(numberOne)
            arraySum.append("/")
            arraySum.append("100")
            equal()
        } else if (arraySum.isEmpty == true && resultNum.count > 0) {
            arraySum.append(resultNum)
            arraySum.append("/")
            arraySum.append("100")
            equal()
        } else if (arraySum.isEmpty == false && arraySum.count == 2) {
            arraySum.append(numberTwo)
            let tempArray = arraySum
            arraySum.removeAll()
            arraySum = [tempArray[0], "/", "100"]
            equal()
            arraySum = [resultNum, "*", tempArray[2]]
            equal()
            arraySum = tempArray
            arraySum[2] = resultNum
            print("array for %", arraySum)
            resultNum = ""
            equal()
            
        }
    }
    
  // округлять очень длинные числа до 5 знаков после запятой
    
    
    
    
    // проверка поля на наличие арифметического знака
    
    func checkTextfield() -> Bool {
        let min = "-"
        if (numberOne.isEmpty ||  numberOne.contains("+") || numberOne.contains("*") || numberOne.contains("/")) || (numberOne.contains(min)) || (numberOne[numberOne.startIndex] == Character(min)) {
            return true
        } else {
            return false
        }
    }

        // добавление в массив первого элемента выражения и знака
    
    func process (symbol : String) {
        arraySum.append(numberOne)
        arraySum.append(symbol)
            numberOne += symbol
               textFieldLbl.text = numberOne
        print(arraySum)
    }
    
    // ф-я правильного вывода чисел 1-9 на экран калькулятора
    
    func numbers (element: String) {
            if (arraySum.isEmpty == true) {
                if (numberOne == "" || numberOne == "0" || resultNum.count > 0) {
                resultNum = ""
                numberOne = element
                textFieldLbl.text = numberOne
               
            } else{
                numberOne += element
                textFieldLbl.text = numberOne
               
            }
        } else {
                if (numberTwo == "") {
              numberTwo = element
              numberOne += element
              textFieldLbl.text = numberOne
               
                } else if (numberTwo == "0") {
                numberTwo = element
                numberOne.remove(at: numberOne.index(before: numberOne.endIndex))
                numberOne += element
                textFieldLbl.text = numberOne
                } else {
                    numberTwo += element
                    numberOne += element
                    textFieldLbl.text = numberOne
                  
                }
        }
    }
    
    // ф-я вывода результата на экран с учетом Int и Double
    
    func equal () {
        if (arraySum.isEmpty == false && arraySum.count == 3) {
            if (plusMinusDouble() == 0.0 && arraySum[1] == "/") {
                afterEqual(text: "Error", result: "", num1: "", num2: "")
                /*
                textFieldLbl.text = "Error"
                resultNum = ""
                numberOne = ""
                numberTwo = ""
                arraySum.removeAll()
                */
            } else {
              let strBefore = String(plusMinusDouble())
                       let strAfterPoint = (strBefore.split(separator: "."))[1]
                       let characterset = CharacterSet.init(charactersIn: "123456789")
                       
                       if strAfterPoint.rangeOfCharacter(from: characterset) != nil {
                        afterEqual(text: strBefore, result: strBefore, num1: "", num2: "")
                        /*
                           textFieldLbl.text = strBefore
                           resultNum = strBefore
                                 numberOne = ""
                                 numberTwo = ""
                                 arraySum.removeAll()
                        */
                           } else {
                               let a = strBefore.split(separator: ".")[0]
                               let integ = String(a)
                        afterEqual(text: integ, result: integ, num1: "", num2: "")
                        /*
                               textFieldLbl.text = int
                               resultNum = int
                                   numberOne = ""
                                   numberTwo = ""
                                   arraySum.removeAll()
                           */
                           
                           }
            }
    }
}
    
    func afterEqual (text: String, result: String, num1: String, num2: String) {
        textFieldLbl.text = text
        resultNum = result
        numberOne = num1
        numberTwo = num2
        arraySum.removeAll()
    }
    
    
    // ф-я определяет знак и производит математическое действие, возвращает результат выражения в Double
    
    func plusMinusDouble () -> Double {
         var result = 0.0
        let first = Double(arraySum[0]) ?? 0
        let second = Double(arraySum[2]) ?? 0
        if (arraySum.isEmpty == false) {
            switch arraySum[1] {
            case "+":
                result = first + second
            case "-":
                result = first - second
            case "*":
                result = first * second
            case "/":
                if (second == 0) {
                   // result = 0
                } else {
                    result = first / second
                }
            default: break
            }
        } else {
            print("error")
        }
        print(Double(result))
        return (Double(result))
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        exchangeB.layer.cornerRadius = 10
//        exchangeB.layer.borderWidth = 1
        //exchangeB.layer.borderColor = UIColor.green.cgColor
        
        
        if (arrayOfData.isEmpty == true) {
            exchangeB.isEnabled = false
        } else {
            exchangeB.isEnabled = true
        }
        textFieldLbl.text = "0"
        textFieldLbl.text = saving.string(forKey: "TEXT")
        if (saving.integer(forKey: "currencyOne") == 1) {
            picker1.selectRow(1, inComponent: 0, animated: true)
            pickerValue1 = arrayOfCurrencyes[1]
                } else {
                    picker1.selectRow(saving.integer(forKey: "currencyOne"), inComponent: 0, animated: true)
                    pickerValue1 = arrayOfCurrencyes[saving.integer(forKey: "currencyOne")]
                }
        if (saving.integer(forKey: "currencyTwo") == 2) {
            picker2.selectRow(2, inComponent: 0, animated: true)
            pickerValue2 = arrayOfCurrencyes2[2]
                } else {
                    picker2.selectRow(saving.integer(forKey: "currencyTwo"), inComponent: 0, animated: true)
                    pickerValue2 = arrayOfCurrencyes2[saving.integer(forKey: "currencyTwo")]
                }
       print(arrayOfData)
    }
    
}
