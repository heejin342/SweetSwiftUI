//
//  QuantitySelector.swift
//  FruitMart
//
//  Created by 김희진 on 2023/08/14.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

struct QuantitySelector: View {
    @Binding var quantity: Int // @Binding을 사용해 상위뷰가 전달해 준 숫자를 표기하고 변경한 값을 다시 원천 자료와 동기화한다. 값을 직접 소유할 필요가 없어서 State 대신 Binding을 이용하고 있다.
    var range: ClosedRange<Int> = 1...20
    
    // UIKit에서 제공하는 기능. 근데 스유는 UIKit 클래스를 포함하고 있어서 이런게 가능하다.
    private let softFeedBack = UIImpactFeedbackGenerator(style: .soft)
    private let rigidFeedBack = UIImpactFeedbackGenerator(style: .rigid)


    var body: some View {
        HStack {
            Button(action: { self.changeQuantity(-1) }) {
                //Image(systemName: "minus.circle.fill").imageScale(.large).padding()
                Symbol("minus.circle.fill", scale: .large, color: .yellow).padding()
            }
            .foregroundColor(Color.gray.opacity(0.5))
            
            Text("\(quantity)") // 현재 수량
                .bold()
                .font(Font.system(.title, design: .monospaced)) // .monospaced 는 숫자가 바뀌어도 일관된 크기를 유지한다.
                .frame(minWidth: 40, maxWidth: 60)
            
            Button(action: { self.changeQuantity(+1) }) {
                // Image(systemName: "plus.circle.fill").imageScale(.large).padding()
                Symbol("plus.circle.fill", scale: .large, color: .yellow).padding()
            }
        }
    }
  
    private func changeQuantity(_ num: Int) {
        if range ~= quantity + num { //우변의 값이 좌변의 값에 포함되어있는지를 판단한다. 수량은 최대 20까지만 올릴 수 있다
            quantity += num
            softFeedBack.prepare() // 진동 지연 시간을 줄일 수 있도록 미리 준비시키는 메서드
            softFeedBack.impactOccurred(intensity: 0.8)
        } else {
            rigidFeedBack.prepare()
            rigidFeedBack.impactOccurred()
        }
    }
}


struct QuantitySelector_Previews: PreviewProvider {
    @State private var quantity = 0
    static var previews: some View {
        return Group {
            // 프리뷰에서 바인딩 타입에 값을 전달할 떄는 constant이용. constant 가 전달한 값을 Binding 으로 바꿔서 전달한다.
            // QuantitySelector(quantity: $quantity) // -> 에러
            QuantitySelector(quantity: .constant(1))
            QuantitySelector(quantity: .constant(10))
            QuantitySelector(quantity: .constant(20))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
