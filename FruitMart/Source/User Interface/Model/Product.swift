//
//  Product.swift
//  FruitMart
//
//  Created by 김희진 on 2023/09/10.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import Foundation

struct Product: Codable, Identifiable, Equatable {
    let id: UUID = UUID() //identifiable 프로토콜 준수를 위한 id프로퍼티 추가
    // var id: String { name } //이렇게 해주면 list를 쓸때 id 파라미터를 추가해줘야한다.
    let name: String
    let imageName: String
    let price: Int
    let description: String
    var isFavorite: Bool = false
    
    // 구조체에서는 자동으로 해주기떄문에 필요없지만, Equatable를 채택한 클래스에서는 구현 필요
    // public static func == (lhs: Self, rhs: Self) -> Bool {
    //    return lhs.id == rhs.id
    // }
}

let productSamples: [Product] = [
    Product(name: "나는야 무화과", imageName: "fig", price: 3100, description: "소화가 잘되고 변비에 좋은 달달한국내상 무화과에요. 고기와 찰떡궁합!"),
    Product(name: "유기농 아보카도", imageName: "avocado", price: 3100, description: "소화가 잘되고 변비에 좋은 달달한국내상 무화과에요. 고기와 찰떡궁합!"),
    Product(name: "나는야 무화과", imageName: "banana", price: 3100, description: "소화가 잘되고 변비에 좋은 달달한국내상 무화과에요. 고기와 찰떡궁합!", isFavorite: true),
    Product(name: "나는야 무화과", imageName: "pineapple", price: 3100, description: "소화가 잘되고 변비에 좋은 달달한국내상 무화과에요. 고기와 찰떡궁합!"),
    Product(name: "나는야 무화과", imageName: "watermelon", price: 3100, description: "소화가 잘되고 변비에 좋은 달달한국내상 무화과에요. 고기와 찰떡궁합!", isFavorite: true),
    Product(name: "나는야 무화과", imageName: "blueberry", price: 3100, description: "소화가 잘되고 변비에 좋은 달달한국내상 무화과에요. 고기와 찰떡궁합!", isFavorite: true)
]
