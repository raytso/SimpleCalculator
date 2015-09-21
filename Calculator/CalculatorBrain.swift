//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ray Tso on 8/22/15.
//  Copyright (c) 2015 Ray Tso. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private enum input {
        case SingleOperation(String, Double -> Double )
        case DoubleOperation(String, (Double, Double) -> Double)
        case Number(Double)
        
        var description: String {
            get {
                switch self {
                case .Number(let number):
                    return "\(number)"
                case .DoubleOperation(let symbol, _):
                    return symbol
                case .SingleOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var inputStack = [input]()
    
    private var cache: Double
    
    private var knownOperations = [String: input]()
    
    init() {
        knownOperations["×"] = input.DoubleOperation("×", *)
        knownOperations["−"] = input.DoubleOperation("-", -)
        knownOperations["+"] = input.DoubleOperation("+", +)
        knownOperations["÷"] = input.DoubleOperation("÷", /)
        knownOperations["="] = input.SingleOperation("=") { $0 }
        knownOperations["√"] = input.SingleOperation("√", sqrt)
//        knownOperations["sin"] = 
        cache = 0
    }
    
    private func calculate(inputs: [input]) -> (result: Double?, remainingStack: [input]) {
        if !inputs.isEmpty {
            
            var remainingInputs = inputs                // inputs is passed by reference. Need a var to pass by VALUE for alteration
            let lastInput = remainingInputs.removeLast()
            
            switch lastInput {
            case .Number(let number):
                return (number, remainingInputs)
            case .SingleOperation(_, let operation):
                let operand1Calculation = calculate(remainingInputs)
                if let operand1 = operand1Calculation.result {
                    return (operation(operand1), remainingInputs)
                }
            case .DoubleOperation(_, let opertation):
                let operand1Calculation = calculate(remainingInputs)
                if let operand1 = operand1Calculation.result {
                    let operand2 = cache
                    let doubleOperationResult = opertation(operand1, operand2)
                    inputStack.removeAll(keepCapacity: false)
                    appendNumberToInputStack(doubleOperationResult)
                    return (doubleOperationResult, remainingInputs)
                }
                
            }
        }
        // failure
        return (nil, inputs)
    }
    
    private func calculate() -> Double? {
        let (result, _) = calculate(inputStack)
        return result
    }
    
    private func appendNumberToInputStack(number: Double) {
        inputStack.append(input.Number(number))
    }
    
    func doBinaryOperation(symbol: String, number: Double) -> Double? {
        if inputStack.isEmpty {
            appendNumberToInputStack(0.0)
            let plus = knownOperations["+"]
            inputStack.append(plus!)
        }
        cache = number
        var result: Double
        if let operation = knownOperations[symbol] {
            result = calculate()!
            inputStack.append(operation)
            return result
        }
        else {
            return nil
        }
    }
    
    func doUnaryOperation(symbol: String, number: Double) -> Double? {
        if inputStack.isEmpty {
            appendNumberToInputStack(0.0)
            let plus = knownOperations["+"]
            inputStack.append(plus!)
        }
        cache = number
        var result: Double
        if let operation = knownOperations[symbol] {
            result = calculate()!
            inputStack.append(operation)
            result = calculate()!
            return result
        }
        else {
            return nil
        }
//        inputStack.removeLast()
//        let operation = knownOperations[symbol]
//        inputStack.append(operation!)
//        return calculate()!
    }
    
    func clearStack() {
        inputStack.removeAll(keepCapacity: false)
    }
}
