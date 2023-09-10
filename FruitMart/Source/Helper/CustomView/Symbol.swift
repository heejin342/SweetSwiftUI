//
//  Symbol.swift
//  FruitMart
//
//  Created by 김희진 on 2023/08/15.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

struct Symbol: View {
  let systemName: String
  let imageScale: Image.Scale
  let color: Color?
  
  init(
    _ systemName: String,
    scale imageScale: Image.Scale = .medium,
    color: Color? = nil
  ) {
    self.systemName = systemName
    self.imageScale = imageScale
    self.color = color
  }
  
  var body: some View {
    Image(systemName: systemName)
      .imageScale(imageScale)
      .foregroundColor(color)
  }
}


// MARK: - Previews
struct Symbol_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 20) {
      Symbol("heart.fill")
      Symbol("heart.fill", scale: .large)
      Symbol("heart.fill", scale: .large, color: .red)
      Symbol("heart", scale: .large, color: .red)
        .font(Font.system(size: 25, weight: .black))
    }
  }
}
