//
//  ColorExtension.swift
//  FruitMart
//
//  Created by 김희진 on 2023/08/12.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

extension Color {
    static let peach = Color("peach") // 앱에서 사용할 메인색
    static let primaryShadow = Color.primary.opacity(0.2) // 그림자에 사용할 색
    static let secondaryText = Color(hex: "#6e6e6e")
    static let background = Color(UIColor.systemGray6) // UIColor를 Color 로 변경
    
    init(hex: String) {
        let scanner = Scanner(string: hex) // 문자열 자르는 역할의 클래스
        _ = scanner.scanString("#") // # 문자  제거
        
        var rgb: UInt64 = 0 // 문자열을 Int64 타입으로 변환해 rgb 변수에 저장. 변환할 수 없다면 0을 반환
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >>  8) & 0xFF) / 255.0
        let b = Double((rgb >>  0) & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}
