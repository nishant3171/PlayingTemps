//
//  ConversionViewController.swift
//  PlayingTemps
//
//  Created by Nishant Punia on 23/05/16.
//  Copyright © 2016 MLBNP. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var fahrenheitLbl: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var celsiusValue: Double? {
        didSet {
            updateFahrenheitLabel()
        }
    }
    var fahrenheitValue: Double? {
        if let value = celsiusValue {
            return (value * (9/5)) + 32
        } else {
            return nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
        
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = NSCharacterSet.init(charactersInString: "0123456789.,")
        let receivedCharacters = NSCharacterSet.init(charactersInString: string)
        let validString = allowedCharacters.isSupersetOfSet(receivedCharacters)
        
        let currentLocale = NSLocale.currentLocale()
        let decimalSeparator =
            currentLocale.objectForKey(NSLocaleDecimalSeparator) as! String
        
        let existingTextHasDecimalSeparator = textField.text?.rangeOfString(decimalSeparator)
        let replacementTextHasDecimalSeparator = string.rangeOfString(decimalSeparator)
        
        if existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil {
            return false
        }
        else {
            return validString
        }
        
    }

    @IBAction func celsiusTextField(textField: UITextField) {
        if let text = textField.text , let value = numberFormatter.numberFromString(text)  {
            celsiusValue = value.doubleValue
            if celsiusValue >= 35.0 {
                self.view.backgroundColor = UIColor(red: 237.0 / 255.0, green: 185.0 / 255.0, blue: 154.0 / 255.0, alpha: 1.0)
            } else {
                self.view.backgroundColor = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
            }
        } else {
            celsiusValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        textField.resignFirstResponder()
    }
    
    func updateFahrenheitLabel() {
        if let value = fahrenheitValue {
            fahrenheitLbl.text = numberFormatter.stringFromNumber(value)
        } else {
            fahrenheitLbl.text = "???"
        }
    }
    
    let numberFormatter: NSNumberFormatter = {
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        nf.maximumFractionDigits = 1
        nf.minimumFractionDigits = 0
        return nf
    }()
    
//    func randomColor() {
//        let colors = [UIColor.grayColor(),UIColor.blueColor(),UIColor.blackColor()]
//        let number = arc4random_uniform(UInt32(colors.count))
//        self.view.backgroundColor = colors[Int(number)]
//        
//    }
}
