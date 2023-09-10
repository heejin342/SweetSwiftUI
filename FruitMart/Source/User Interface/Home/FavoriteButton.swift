//
//  FavoriteButton.swift
//  FruitMart
//
//  Created by 김희진 on 2023/08/14.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

struct FavoriteButton: View {
    
    @EnvironmentObject private var store: Store
    let product: Product
    
    private var imageName: String {
        product.isFavorite ? "heart.fill" : "heart"
    }
    
    var body: some View {
        // 여기서 만약 버튼이 아닌 Image에 onTapGesture 수식어르 이용하는 방식으로 변경하면, 제스쳐는 네비게이션 링크, 버튼보다 터치이벤트에 대한 우선순위 높아 홈의 List 에 있는 cell에 하트버튼 클릭시 네비게이션이 아닌 toggle 이 우선적으로 일어날 수 있다.
        /*
        Button(action: {
            self.store.toggleFavorite(of: self.product) // 상품에 대한 즐겨찾기 설정 변경
        }) {
            Image(systemName: imageName)
                .imageScale(.large)
                .foregroundColor(.peach)
                .frame(width: 32, height: 32)
        }
        */
        
        // Image(systemName: imageName).imageScale(.large).foregroundColor(.peach)
        Symbol(imageName, scale: .large, color: .peach)
            .frame(width: 32, height: 32)
            .onTapGesture {
                // 하트 누를때 애니메이션
                withAnimation {
                    self.store.toggleFavorite(of: self.product)
                }
            }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(product: productSamples[0])
    }
}
