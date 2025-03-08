//
//  Untitled.swift
//  iOS Calculator App
//
//  Created by Takeshi Sakamoto on 2025/03/04.
//
import Foundation

// 演算子の種類を定義
enum CalculatorOperator {
    case none
    case add
    case subtract
    case multiply
    case divide
}

// 計算機の状態を定義
enum CalculatorState {
    case enteringNumber    // 数字入力中
    case operatorSelected  //演算子選択後
    case showingResult  //結果表示中
}

// 計算機のモデルクラス
class CalculatorModel {
    // 現在の表示の値
    private var displayValue: Double = 0
    
    // 前回の計算値
    private var previousValue: Double = 0
    
    // 現在選択されている演算子
    private var currentOperator: CalculatorOperator = .none
    
    // 計算機の状態
    private var state: CalculatorState = .enteringNumber
    
    // 入力中の文字列（数字と小数点）
    private var inputString: String = "0"
    
    // 小数点が入力されたかどうか
    private var decimalPointEntered: Bool = false
    
    // 表示中の式（一段上に表示される計算式）
    private var exprettionString: String = ""
    
    // 最大桁数（10億まで）
    private let maxDigits = 10
    
    // 小数点以下の制度（8桁）
    private let decimalPrecision = 8
    
    // 現在の表示文字列を取得
    var displayString: String {
        // 桁区切りを適用
        return formatNumber(inputString)
    }
    
    // 計算式の文字列を取得
    var expression: String {
        return exprettionString
    }
    
    // 数字ボタンが押された時の処理
    func inputDigit(_ digit: Int) {
        // 結果表示中なら表示をクリア
        if state == .showingResult {
            inputString = "0"
            state = .enteringNumber
        }
        
        // 演算子選択後なら表示をクリア
        if state == .operatorSelected {
            inputString = "0"
            state = .enteringNumber
        }
        
        // 最初の0を置き換える（小数点がある場合を除く）
        if inputString == "0" && digit != 0 && !decimalPointEntered {
            inputString = String(digit)
        }
        // それ以外の場合は数字を追加
        else if inputString != "0" || decimalPointEntered {
            // 最大桁数チェック
            if inputString.count < maxDigits {
                inputString += String(digit)
            }
        }
    }
    
    // 小数点ボタンが押された時の処理
    func inputDecimalPoint() {
        // すでに小数点がある場合はなにもしない
        if decimalPointEntered {
            return
        }
        
        // 結果表示中なら表示をクリア
        if state == .showingResult {
            inputString = "0"
            state = .enteringNumber
        }
        
        // 演算子選択後なら表示をクリア
        if state == .operatorSelected {
            inputString = "0"
            state = .enteringNumber
        }
        
        // 小数点を追加
        inputString += "."
        decimalPointEntered = true
    }
    
    // 演算子ボタンが押された時の処理
    func inputOperator(_ op: CalculatorOperator) {
        // 現在の入力値を取得
        let currentValue = Double(inputString) ?? 0
        
        // 演算子が連続で押された場合、最後の演算子で上書き
        if state == .operatorSelected {
            currentOperator = op
            updateExpressionString() // 式の表示を更新
            return
        }
        
        // 前回の計算結果がある場合はその値を使用
        if state == .showingResult {
            previousValue = displayValue
        } else {
            // 現在の入力値を使用して計算実行（前の演算子があれば）
            if currentOperator != .none {
                do {
                    displayValue = try performCalculation(previousValue, currentValue)
                    // 結果を入力文字列にセット
                    inputString = formatDoubleForDisplay(displayValue)
                } catch {
                    // エラー処理
                    inputString = error.localizedDescription
                    resetCalculator()
                    return
                }
            } else {
                // 初回の演算子入力時は現在値を保存
                displayValue = currentValue
            }
            previousValue = displayValue
        }
        // 演算子を設定
        currentOperator = op
        state = .operatorSelected
        decimalPointEntered = false
        
        // 式の表示を更新
        updateExpressionString()
    }
    
    // イコールボタンが押された時の処理
    func calculate() {
        // 現在の入力値を取得
        let currentValue = Double(inputString) ?? 0
        
        if currentOperator == .none {
            displayValue = currentValue
            state = .showingResult
            return
        }
        
        // 計算実行
        do {
            displayValue = try performCalculation(previousValue, currentValue)
            // 結果を入力文字列にセット
            inputString = formatDoubleForDisplay(displayValue)
        } catch {
            inputString = error.localizedDescription
            resetCalculator()
            return
        }
        
        //式の表示を更新（現在の式 ＋ ＝ ＋ 結果）
        exprettionString += " = " + inputString
        
        // 状態をリセット
        state = .showingResult
        currentOperator = .none
        decimalPointEntered = inputString.contains(".")
    }
    
    // ACボタンが押された時の処理
    func allClear() {
        resetCalculator()
    }
    
    // Cボタンが押された時の処理
    func clear(){
        inputString = "0"
        decimalPointEntered = false
        if state == .showingResult {
            resetCalculator()
        }
    }
    
    // バックスペースボタンが押された時の処理
    func backspace() {
        // 結果表示中は何もしない
        if state == .showingResult {
            return
        }
        
        // 一文字削除
        if inputString.count > 1 {
            let lastChar = inputString.removeLast()
            //小数点を削除した場合
            if lastChar == "." {
                decimalPointEntered = false
            }
        } else {
            // 1文字だけの場合は0にする
            inputString = "0"
        }
    }
    
    // 符号反転ボタン（+/-）が押された時の処理
    func toggleSign() {
        // 0の場合はなにもしない
        if inputString == "0" {
            return
        }
        
        // 結果表示中なら表示をクリア
        if state == .showingResult {
            state = .enteringNumber
        }
        
        // 符号を反転
        if inputString.hasPrefix("-") {
            inputString.removeFirst()
        } else {
            inputString = "-" + inputString
        }
    }
    
    // 内部で計算を実行する関数
    private func performCalculation(_ a: Double, _ b:Double) throws -> Double {
        switch currentOperator {
        case .none:
            return b
        case .add:
            return a + b
        case .subtract:
            return a - b
        case .multiply:
            return a * b
        case .divide:
            if b == 0 {
                throw CalculatorError.divisionByZero
            }
            return a / b
        }
    }
    
    // 計算機の状態をリセットする関数
    private func resetCalculator() {
        displayValue = 0
        previousValue = 0
        currentOperator = .none
        state = .enteringNumber
        inputString = "0"
        decimalPointEntered = false
        exprettionString = ""
    }
    
    // 式の状態を更新する関数
    private func updateExpressionString() {
        let operatorString: String
        switch currentOperator {
        case .none:
            operatorString = ""
        case .add:
            operatorString = "+"
        case .subtract:
            operatorString = "-"
        case .multiply:
            operatorString = "×"
        case .divide:
            operatorString = "÷"
        }
        
        // 式の更新
        exprettionString = inputString + operatorString
    }
    
    // 数値を表示用にフォーマットする関数
    private func formatDoubleForDisplay(_ value: Double) -> String {
        // 無限大や非数のチェック
        if value.isInfinite || value.isNaN {
            return "エラー"
        }
        
        // 大きすぎる、または小さすぎる数値のチェック
        if abs(value) > 1_000_000_000 || (abs(value) < 0.00000001 && value != 0) {
            // 科学表記法で表示
            let formatter = NumberFormatter()
            formatter.numberStyle = .scientific
            formatter.maximumFractionDigits = decimalPrecision
            formatter.exponentSymbol = "e"
            return formatter.string(from: NSNumber(value: value)) ?? "エラー"
        }
        
        // 通常の数値表示
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = decimalPrecision
        return formatter.string(from: NSNumber(value: value)) ?? String(value)
    }
    
    // 入力文字列を表示用にフォーマットする関数（桁区切りなど）
    private func formatNumber(_ numString: String) -> String {
        // エラーメッセージの場合はそのまま返す
        if numString == "エラー" || numString.contains("e") {
            return numString
        }
        
        // 小数点で分割
        let components = numString.split(separator: ".", maxSplits: 1)
        var integerPart = String(components[0])
        
        // 負の数の場合、マイナス記号を一時的に除去
        var isNegative = false
        if integerPart.hasPrefix("-") {
            isNegative = true
            integerPart.removeFirst()
        }
        
        // 整数部分に桁区切りを追加
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        let formattedInteger = formatter.string(from: NSNumber(value: Int(integerPart) ?? 0)) ?? integerPart
        
        // 結果を組み立て
        var result = isNegative ? "-" + formattedInteger : formattedInteger
        
        // 少数部分がある場合は追加
        if components.count > 1 {
            result += "." + components[1]
        }
        return result
    }
}

// 計算機のエラー定義
enum CalculatorError: Error, LocalizedError {
    case divisionByZero
    
    var errorDescription: String? {
        switch self {
        case .divisionByZero:
            return " ゼロ除算はできません "
        }
    }
}

