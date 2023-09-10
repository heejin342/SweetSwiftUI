//
//  OrderCompleteMessage.swift
//  FruitMart
//
//  Created by 김희진 on 2023/08/15.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

struct OrderCompleteMessage: View {
    var body: some View {
        Text("주문 완료")
            .font(.system(size: 24))
            .bold()
            .kerning(2) // 자간
    }
}

struct OrderCompleteMessage_Previews: PreviewProvider {
    static var previews: some View {
        OrderCompleteMessage()
    }
}
