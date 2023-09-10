//
//  ProductRow.swift
//  FruitMart
//
//  Created by 김희진 on 2023/08/12.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

struct ProductRow: View {
    let product: Product
    @EnvironmentObject var store: Store // 빠른 주문 후 주문 내역 저장하는데 사요
    @Binding var quickOrder: Product? // 뻐른 주문한 상품명을 표시하기 위해 저장. 홈에서 관리하는 데이터기 떄문에 Binding으로 사용
    @State private var willAppear: Bool = false
    
    var body: some View {
        HStack {
            productImage
            productDescription
        }
        .frame(height: 150)
        .background(Color.primary.colorInvert()) // .primary 는 다크모드에서 지원해주는 컬러다
        .cornerRadius(6)
        .shadow(color: Color.primaryShadow, radius: 4, x: 10, y: 12)
        .padding(.vertical, 8)
        // product가 화면이 나타날 때다 onAppear {} 의 상태를 true로 변경한다. 그럼 opacity 가 변경되는데, 여기에 애니메이션 효과가 적용된다.
        // 리스트에서는 뷰가 재사용되므로 화면에서 사라졌다가 다시 나타날때 willAppear의 상태는 reset 되어서 false로 시작한다. 그래서 굳이
        // .onDisappear { self.willAppear = true } 해주지 않아도 된다.
        .opacity(willAppear ? 1 : 0)
        .animation(.easeOut(duration: 0.4))
        .onAppear { self.willAppear = true }
        .contextMenu { contextMenu } // 상태에 따라 다르게 나와야 하기때문에 contextMenu 라고 한거같다.
        .frame(height: store.appSetting.productRowHeight)
    }
    
    var contextMenu: some View {
        VStack {
            Button(action: { self.toggleFavorite() }) { // 즐겨찾기 여부 변경
                Text("Toggle Favorite")
                Symbol(self.product.isFavorite ? "heart.fill" : "heart")
            }
            Button(action: { self.orderProduct() }) { // 빠른주문
                Text("Order Product")
                Symbol("Cart")
            }
        }
    }
    
    func toggleFavorite() {
        store.toggleFavorite(of: product)
    }
}

private extension ProductRow {
    
    var productImage: some View {
        //body는 세로가 길어서, 가로 140에 스크린전체높이의 이미지가됨
        // Image(product.imageName).resizable().scaledToFill().frame(width: 140).clipped()
        ResizedImage(product.imageName, contentMode: .fill)
            .frame(width: 140)
            .clipped()
    }

    var productDescription: some View {
        VStack(alignment: .leading) {
            Text(product.name)
                .font(.headline)
                .fontWeight(.medium)
                .padding(.bottom, 6)
            
            Text(product.description)
                .font(.footnote)
                .foregroundColor(Color.secondaryText)
            
            Spacer()
            
            footerView
        }
        //.padding([.top, .bottom])은 .padding(.vertical) 과 동일
        //.padding([.leading, .trailing])은 .padding(.horizontal) 과 동일
        //.padding() == .padding(.all) == .padding([.vertical, .horizontal])
        .padding([.leading, .bottom], 12)
        .padding([.top, .trailing])
    }

    var footerView: some View {
        HStack(spacing: 0) {
            Text("W")
                .font(.footnote)
            + Text("\(product.price)")
                .font(.headline)
            
            Spacer()
            
            FavoriteButton(product: product)
            
            Symbol("cart", color: .peach)
                .frame(width: 32, height: 32)
                .onTapGesture {
                    self.orderProduct()
                }
//            Image(systemName: "cart").imageScale(.medium).foregroundColor(Color.peach)
//                .frame(width: 32, height: 32)
        }
    }
    
    func orderProduct() {
        quickOrder = product // 주문 상품을 홈의 @State변수에 저장한다. 이걸로 홈에서 팝업창을 출력한다.
        store.placeOrder(product: product, quantity: 1)
    }
}

struct ProductRow_Previews: PreviewProvider {
    static var previews: some View {
        ProductRow(product: productSamples[3], quickOrder: .constant(nil)) // @Binding 데이터를 프리뷰에섲 전달할때는 .constant 사용필요
            .environmentObject(Store())
    }
}
