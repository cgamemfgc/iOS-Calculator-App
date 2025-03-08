import Foundation
import SwiftUI

// 計算機のViewModelクラス
class CalculatorViewModel: ObservableObject {
    // 計算機モデル
    private let model = CalculatorModel()
    
    // 表示テキスト（UIに表示される）
    @Published var displayText: String = "0"
    
    // 式のテキスト（計算式の表示）
    @Published var expressionText: String = ""
    
    // ACボタンのタイトル（AC/Cの切り替え）
    @Published var allClearTitle: String = "AC"
    
    // 表示テキストの更新
    private func updateDisplayText() {
        displayText = model.displayString
        expressionText = model.expression
        
        // ACボタンのタイトル更新
        allClearTitle = displayText == "0" && expressionText.isEmpty ? "AC" : "C"
    }
    
    // 数字入力
    func inputDigit(_ digit: Int) {
        model.inputDigit(digit)
        updateDisplayText()
    }
    
    // 小数点入力
    func inputDecimalPoint() {
        model.inputDecimalPoint()
        updateDisplayText()
    }
    
    // 演算子入力
    func inputOperator(_ op: CalculatirOperator) {
        model.inputOperator(op)
        updateDisplayText()
    }
    
    // イコールボタン
    func calculate() {
        model.calculate()
        updateDisplayText()
    }
     // 全消去（AC）
    func allClear() {
        if allClearTitle == "AC" {
            model.allClear()
        } else {
            model.clear()
            allClearTitle = "AC"
        }
        updateDisplayText()
    }
    
    // バックスペース
    func backspace() {
        model.backspace()
        updateDisplayText()
    }
    
    // 符号反転
    func toggleSign() {
        model.toggleSign()
        updateDisplayText()
    }
}
