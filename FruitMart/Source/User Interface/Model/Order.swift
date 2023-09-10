//
//  Order.swift
//  FruitMart
//
//  Created by 김희진 on 2023/09/10.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import Foundation

struct Order: Identifiable, Codable { // 식별을 위한 Identifiable 채택
//    static var orderSequence = sequence(first: 1) { $0 + 1 } // 주문이 들어올때마다 1씩 증가되도록 구현. 초기값은 1이고, 다음번에 올 값은 이전보다 1 크도록 구현
    static var orderSequence = sequence(first: lastOrderID + 1) {
        $0 &+ 1
    }
    static var lastOrderID: Int {
        get {
            UserDefaults.standard.integer(forKey: "LastOrderID")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LastOrderID")
        }
    }
    let id: Int
    let product: Product
    let quantity: Int
    var price: Int {
        product.price * quantity
    }
}
