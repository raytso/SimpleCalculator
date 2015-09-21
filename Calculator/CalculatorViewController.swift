//
//  ViewController.swift
//  Calculator
//
//  Created by Ray Tso on 8/20/15.
//  Copyright © 2015 Ray Tso. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController{
    
    @IBOutlet weak var displayResult: UILabel!
    
    var userHasntDoneTyping: Bool = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        
        let number = sender.currentTitle!
        
        // If user hasn't finished input, append number to display text
        // If the user has finished, start the display text with new digit number
        if userHasntDoneTyping {
            displayResult.text = displayResult.text! + number
        } else {
            displayResult.text = number
            userHasntDoneTyping = true
        }
    }
    
    // Used to set the calculated result into the result bar
    var displayValue: Double{
        get{
            return NSNumberFormatter().numberFromString(displayResult.text!)!.doubleValue
        }
        set{
            displayResult.text = "\(newValue)"
            userHasntDoneTyping = false
        }
    }
    
    @IBAction func binaryOperate(sender: UIButton) {
        if let calculatedResult = brain.doBinaryOperation(sender.currentTitle!, number: NSNumberFormatter().numberFromString(displayResult.text!)!.doubleValue) {
            displayValue = calculatedResult
        } else {
            displayValue = 0.211
        }
    }
    
    @IBAction func unaryOperate(sender: UIButton) {
        if let calculatedResult = brain.doUnaryOperation(sender.currentTitle!, number: NSNumberFormatter().numberFromString(displayResult.text!)!.doubleValue) {
            displayValue = calculatedResult
        } else {
            displayValue = 0.311
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        brain.clearStack()
        displayValue = 0
    }
    
    @IBAction func backSpace(sender: UIButton) {
        displayResult.text = String(displayResult.text!.characters.dropLast())
    }
    
}

