//
//  FavoriteProductScrollView.swift
//  FruitMart
//
//  Created by 김희진 on 2023/08/15.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

struct FavoriteProductScrollView: View {
    
    @EnvironmentObject private var store: Store
    @Binding var showingImage: Bool // 즐겨찾기 상품 이미지 표시 여부
    
    var body: some View {
        VStack(alignment: .leading) {
            title
            if showingImage {
                products
            }
        }
        .padding()
        .transition(.slide)
    }
    
    var title: some View {
        HStack(alignment: .top, spacing: 5) {
            Text("즐겨찾는 상품")
                .font(.headline)
                .fontWeight(.medium)
            
            // 화살표 버튼을 누르면 180도 회전시키는 애니메이션
            Symbol("arrowtriangle.up.square")
                .padding(4)
                .rotationEffect(Angle(radians: showingImage ? .pi : 0))
            
            Spacer()
        }
        .padding(.bottom, 8)
        .onTapGesture {
            // showingImage값이 바뀌면 애니메이션이 발생한다.
            withAnimation {
                self.showingImage.toggle()
            }
        }
    }
    
    // 여기서부터 코드 보기
    var products: some View {
        let favoriteProducts = store.products.filter { $0.isFavorite }
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(favoriteProducts) { product in
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        self.eachProduct(product)
                    }
                }
            }
        }
        .animation(.spring(dampingFraction: 0.78))
    }
    
    func eachProduct(_ product: Product) -> some View {
        GeometryReader { g in // 스크롤 내에서 위치정보를 받아와서 크게 보이게 하기위해 사용
            ResizedImage(product.imageName, renderingMode: .original)
                .clipShape(Circle())
                .frame(width: 90, height: 90)
                .scaleEffect(self.scaledValue(from: g))
                .frame(width: 105, height: 105)
        }
        .frame(width: 105, height: 105)
    }
    
    // MARK: Computed Values
    
    func scaledValue(from geometry: GeometryProxy) -> CGFloat {
        let xOffset = geometry.frame(in: .global).minX - 16 // 글로벌 좌표계로 각 상품의 x값을 구한다. 그래서 그 값에서 스크롤의 좌측 여백인 16만큼을 뺴주면 스크롤 뷰를 기준으로 x offset을 알 수 있듬
        
        // 상품별로 contentOffset x 좌표가 0일때 최대 크기인 1.1배, 화면의 너비와 같은 값을 가지는 위치에 있을때 0.9배가 되도록 한다.
        let minSize: CGFloat = 0.9
        let maxSize: CGFloat = 1.1
        let delta: CGFloat = maxSize - minSize // 변화폭 0.2
        // 최대범위를 maxSize, 최소범위를 maxSize 로 설정
        let size = minSize + delta * (1 - xOffset / UIScreen.main.bounds.width)
        return max(min(size, maxSize), minSize)
    }
}

struct FavoriteProductScrollView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteProductScrollView(showingImage: .constant(true))
            .environmentObject(Store())
    }
}
