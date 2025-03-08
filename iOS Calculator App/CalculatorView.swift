//
//  CalculatorView.swift
//  iOS Calculator App
//
//  Created by Takeshi Sakamoto on 2025/03/08.
//
import SwiftUI
import Foundation

struct CalculatorView: View {
    // 計算機モデルのインスタンス
    @StateObject private var calculator = CalculatorViewModel()
    
    // ボタンの配色
    let operatorColor = Color.orange
    let functionColor = Color(UIColor.lightGray)
    let numberColor = Color(UIColor.darkGray)
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            // 計算式表示エリア
            HStack {
                Spacer()
                Text(calculator.expressionText)
                    .font(.system(size: 24))
                    .foregroundColor(.gray)
                    .padding(.trailing, 20)
            }
            
            // 計算結果表示エリア
            HStack {
                Spacer()
                Text(calculator.displayText)
                    .font(.system(size: 70))
                    .fontWeight(.light)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.trailing, 20)
            }
            
            // ボタン配置エリア
            VStack(spacing: 12){
                HStack(spacing: 12){
                    CalculatorButton(
                        title: calculator.allClearTitle,
                        color: functionColor
                    ) {
                        calculator.allClear()
                    }
                    
                    CalculatorButton(
                        title: "+/-",
                        color: functionColor
                    ) {
                        calculator.toggleSign()
                    }
                    
                    CalculatorButton(
                        title: "⌫",
                        color: functionColor
                    ) {
                        calculator.backspace()
                    }
                    
                    CalculatorButton(
                        title: "÷",
                        color: operatorColor
                    ){
                        calculator.inputOperator(.divide)
                    }
                }
                
                HStack(spacing: 12){
                    CalculatorButton(
                        title: "7",
                        color: numberColor
                    ){
                        calculator.inputDigit(7)
                    }
                    CalculatorButton(
                        title: "8",
                        color: numberColor
                    ){
                        calculator.inputDigit(8)
                    }
                    CalculatorButton(
                        title: "9",
                        color: numberColor
                    ){
                        calculator.inputDigit(9)
                    }
                    CalculatorButton(
                        title: "×",
                        color: operatorColor
                    ){
                        calculator.inputOperator(.multiply)
                    }
                }
                
                HStack(spacing: 12){
                    CalculatorButton(
                        title: "4",
                        color: numberColor
                    ){
                        calculator.inputDigit(4)
                    }
                    CalculatorButton(
                        title: "5",
                        color: numberColor
                    ){
                        calculator.inputDigit(5)
                    }
                    CalculatorButton(
                        title: "6",
                        color: numberColor
                    ){
                        calculator.inputDigit(6)
                    }
                    CalculatorButton(
                        title: "-",
                        color: operatorColor
                    ){
                        calculator.inputOperator(.subtract)
                    }
                }
                
                HStack(spacing: 12){
                    CalculatorButton(
                        title: "1",
                        color: numberColor
                    ){
                        calculator.inputDigit(1)
                    }
                    CalculatorButton(
                        title: "2",
                        color: numberColor
                    ){
                        calculator.inputDigit(2)
                    }
                    CalculatorButton(
                        title: "3",
                        color: numberColor
                    ){
                        calculator.inputDigit(3)
                    }
                    CalculatorButton(
                        title: "+",
                        color: operatorColor
                    ){
                        calculator.inputOperator(.add)
                    }
                }
                
                HStack(spacing: 12){
                    CalculatorButton(
                        title: "0",
                        color: numberColor,
                        isWide: true
                    ){
                        calculator.inputDigit(0)
                    }
                    CalculatorButton(
                        title: ".",
                        color: numberColor
                    ){
                        calculator.inputDecimalPoint()
                    }
                    CalculatorButton(
                        title: "=",
                        color: operatorColor
                    ){
                        calculator.calculate()
                    }
                }
            }
            .padding()
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

// 計算機ボタンの共通コンポーネント
struct CalculatorButton: View {
    let title: String
    let color: Color
    let isWide: Bool
    let action: () -> Void
    
    init(title: String, color: Color, isWide: Bool = false, action: @escaping () -> Void){
        self.title = title
        self.color = color
        self.isWide = isWide
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 32))
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(
                    width: isWide ? buttonWidth * 2 + 12 : buttonWidth,
                    height: buttonHeight
                )
                .background(color)
                .cornerRadius(buttonHeight / 2)
        }
        .buttonStyle(CalculatorButtonStyle())
    }
    
    // ボタンのサイズ定数
    private var buttonWidth: CGFloat {
        return (UIScreen.main.bounds.width - 5 * 12) / 4
    }
    
    private var buttonHeight: CGFloat {
        return buttonWidth
    }
}

// ボタン押下時のスタイル変更
struct CalculatorButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
}
// プレビュー用
struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
