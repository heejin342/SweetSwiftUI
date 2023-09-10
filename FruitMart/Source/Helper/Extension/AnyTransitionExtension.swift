//
//  AnyTransitionExtension.swift
//  FruitMart
//
//  Created by 김희진 on 2023/08/17.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

extension AnyTransition {
    static func stripes() -> AnyTransition {
        func stripesModifier(
            stripes: Int = 30,
            insertion: Bool = true,
            ratio: CGFloat
        ) -> some ViewModifier {
            let shape = Stripes(stripes: stripes, insertion: insertion, ratio: ratio)
            return ShapeClipModifier(shape: shape)
        }
        
        let insertion = AnyTransition.modifier(
            active: stripesModifier(ratio: 0),
            identity: stripesModifier(ratio: 1)
        )
        let removal = AnyTransition.modifier(
            active: stripesModifier(insertion: false, ratio: 0),
            identity: stripesModifier(insertion: false, ratio: 1)
        )
        // 뷰가 나타날 때와사라질 때 각각다른 효과 적용
        return AnyTransition.asymmetric(insertion: insertion, removal: removal)
    }
}
