//
//  Home.swift
//  FruitMart
//
//  Created by Giftbot on 2020/03/02.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import SwiftUI

struct Home: View {
    //  let store: Store
    @EnvironmentObject private var store: Store // 앱 처음 켜질때 데이터가 들어옴
    @State private var quickOrder: Product?
    @State private var showingFavoriteImage: Bool = true
    
    var body: some View {
        NavigationView {
    //            List(store.products, id: \.name) { product in
    //                ProductRow(product: product)
    //            } -> UUID id 가 없을때는 이렇게 해야하지만, 추가후에는 Product 에서 UUID 라는 식별자를 제공하고 있어 아래처럼 하면 된다.
                
            VStack {
                if showFavorite {
                    favoriteProducts
                }
                darkDivider
                productList
            }
        }
    }

    var favoriteProducts: some View {
        FavoriteProductScrollView(showingImage: $showingFavoriteImage)
            .padding(.top, 24)
            .padding(.bottom, 8)
    }
    
    var darkDivider: some View {
        Color.primary
            .opacity(0.3)
            .frame(maxWidth: .infinity, maxHeight: 1)
    }

    /*
    var productList: some View {
        List(store.products) { product in
            // disclosure indicator 제거
            ZStack {
                NavigationLink(destination: ProductDetailView(product: product)) {
                    EmptyView()
                }
                .opacity(0)
                ProductRow(product: product, quickOrder: self.$quickOrder)
            }
            
            
            /*
            // 네비게이션 링크 추가하면 > 버튼이 자동으로 생겨서 맘에 안들기 떄문에 위처럼 바꾼다.
            NavigationLink(destination: ProductDetailView(product: product)) {
                ProductRow(product: product, quickOrder: $quickOrder)
            }
            .buttonStyle(PlainButtonStyle()) // 네비게이션 링크에 buttonStyle 수식어를 생략했거나, 명시적으로 DefaultButtonStyle을 사용했다면, 자식 뷰에서 구현된 버튼보다 내비게이션링크가 상호작용에 대한 우선권을 가진다. 하지만 PlainButtonStyle() 를 해주면, view 내부의 버튼이 네비게이션보다 우선적으로 동작한다.
            */
            
        }
        .popupOverContext(item: $quickOrder, style: .dimmed, content: popupMessage(product:))
        .listStyle(PlainListStyle())
        .navigationBarTitle("과일마트")
    }
    */
    
    var productList: some View {
        List {
            ForEach(store.products) { product in
                ZStack {
                    NavigationLink(destination: ProductDetailView(product: product)) {
                        EmptyView()
                    }
                    .opacity(0)
                    ProductRow(product: product, quickOrder: self.$quickOrder)
                }
            }.listRowBackground(Color.background)
        }
        .background(Color.background)
        .popupOverContext(item: $quickOrder, style: .dimmed, content: popupMessage(product:))
        .listStyle(PlainListStyle())
        .navigationBarTitle("과일마트")
    }
    
    func popupMessage(product: Product) -> some View {
        let name = product.name.split(separator: " ").last!
        return VStack {
            Text(name)
                .font(.title).bold().kerning(3)
                .foregroundColor(.peach)
                .padding()
            
            OrderCompleteMessage()
        }
    }
    
    var showFavorite: Bool { // 즐겨찾는 상품 유무 확인
        !store.products.filter { $0.isFavorite }.isEmpty && store.appSetting.showFavoriteList
    }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
      Home().environmentObject(Store())
      // Home(store: Store())
  }
}
