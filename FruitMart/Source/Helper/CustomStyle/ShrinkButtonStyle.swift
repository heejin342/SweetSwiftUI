//
//  ShrinkButtonStyle.swift
//  FruitMart
//
//  Created by 김희진 on 2023/08/15.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

struct ShrinkButtonStyle: ButtonStyle { // 버튼 pressed 상태를(isPressed) 알아야해서 ButtonStyle 프로토콜 사용
    // 버튼이 눌리고 있을때 변화할 크기와 투명도 지정
    var minScale: CGFloat = 0.9
    var minOpacity: Double = 0.6
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label // 기본 버튼 UI
            .scaleEffect(configuration.isPressed ? minScale : 1)
            .opacity(configuration.isPressed ? minOpacity : 1)
    }
}


// MARK: - Previews

struct ShrinkButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}) {
            Text("Button")
                .padding()
                .padding(.horizontal)
                .background(Capsule().fill(Color.yellow))
        }
        .buttonStyle(ShrinkButtonStyle())
    }
}
