//
//  FruitCard.swift
//  FruitMart
//
//  Created by 김희진 on 2023/08/17.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

struct FruitCard: View {
    let imageName: String
    let size: CGSize
    let cornerRadius: CGFloat
  
    init(_ imageName: String, size: CGSize = CGSize(width: 240, height: 200), cornerRadius: CGFloat = 14) {
        self.imageName = imageName
        self.size = size
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        ResizedImage(imageName)
            .frame(width: size.width, height: size.height)
            .cornerRadius(cornerRadius)
    }
}

struct FruitCard_Previews: PreviewProvider {
    static var previews: some View {
        FruitCard("apple")
    }
}
