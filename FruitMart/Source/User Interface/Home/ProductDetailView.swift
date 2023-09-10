//
//  ProductDetailView.swift
//  FruitMart
//
//  Created by 김희진 on 2023/08/13.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

struct ProductDetailView: View {
    @State private var quantity: Int = 1
    @State private var showingAlert: Bool = false
    @State private var showingPopUp: Bool = false
    @State private var willAppear: Bool = false
    
    @EnvironmentObject private var store: Store
    
    let product: Product
    
    var body: some View {
        VStack(spacing: 0) {
            if willAppear {
                productImage
            }
            orderView
        }
        //.modifier(Popup(size: CGSize(width: 200, height: 200), style: .dimmed, message: Text("팝업2"))) -> View Extension으로 뺴서 아래처럼 사용가능
        .popup(isPresented: $showingPopUp, style: .dimmed, content: { OrderCompleteMessage() })
        .edgesIgnoringSafeArea([.top, .bottom]) // 이 앞에 modifier 팝업을 추가해야 팝업자체도 safeArea를 무시한다.
        .alert(isPresented: $showingAlert) {
            confirmAlert
        }
        .onAppear { self.willAppear = true } // 화면이 나타나는 시점에 productImage가 보이도록 표현
    }
    
    var productImage: some View {
        let effect =  AnyTransition.scale.combined(with: .opacity)
                        .animation(Animation.easeInOut(duration: 0.4).delay(0.05))
        
        // productImage에서 직접 사용하지는 않지만, productImage랑 아래 orderView의 최상위 뷰가 각각 지오메트리 리더가 되어 1:1 비율로 높이를 할당받아 고정높이가 유지된다.
        return GeometryReader { _ in
            //Image(self.product.imageName).resizable().scaledToFill()
            ResizedImage(self.product.imageName)
        }
        .transition(effect)
    }
    
    var orderView: some View { // 하단 하얀색 정보 뷰 전체
        GeometryReader {
            VStack(alignment: .leading) {
                self.productDescription
                Spacer()
                self.priceInfo
                self.placeOrderButton
            }
            .padding(.bottom, 50)
            .padding([.top, .leading, .trailing], 32)
            .frame(height: $0.size.height + 10)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.4), radius: 10, x: 0, y: -5)
        }
    }
    
    var productDescription: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(product.name)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                Spacer()
                
                FavoriteButton(product: product)
            }
            
            Text(splitText(product.description))
                .foregroundColor(.secondaryText)
                .fixedSize() // 뷰의 크기가 작아져도 텍스트가 생략되지 않고 온전이 표현되도록 함
        }
    }
    
    var priceInfo: some View {
        let totalPrice = quantity * product.price
        
        return HStack {
            (Text("w")
             + Text("\(totalPrice)")
                .font(.title)
            ).fontWeight(.medium)

            Spacer()
            
            QuantitySelector(quantity: $quantity)
            
//            Stepper(onIncrement: {
//                print("+1")
//            }, onDecrement: {
//                print("-1")
//            }) {
//                Text("Test")
//            }
            }.foregroundColor(.black)
    }
    
    var placeOrderButton: some View {
        Button(action: {
            self.showingAlert = true
        }) {
          Text("주문하기")
                .foregroundColor(.white)
                .font(.system(size: 20))
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, minHeight: 30, maxHeight: 55)
                .background(Capsule().fill(Color.peach))
        }
        .buttonStyle(ShrinkButtonStyle())
        .padding(.bottom, 60)
        
//            Capsule()
//                .fill(Color.peach)
//                .frame(maxWidth: .infinity, minHeight: 30, maxHeight: 55)
//                .overlay(Text("주문하기")
//                    .font(.system(size: 20))
//                    .fontWeight(.medium)
//                    .foregroundColor(Color.white)
//                )
//                .padding(.bottom, 34)
    }
    
    
    func splitText(_ text: String) -> String {
        guard !text.isEmpty else { return text }
        let centerIdx = text.index(text.startIndex, offsetBy: text.count / 2)
        let centerSpaceIdx = text[..<centerIdx].lastIndex(of: " ")
                                ?? text[centerIdx...].firstIndex(of: " ")
                                ?? text.index(before: text.endIndex)
        let afterSpaceIdx = text.index(after: centerSpaceIdx)
        let lhsString = text[..<afterSpaceIdx].trimmingCharacters(in: .whitespaces)
        let rhsString = text[afterSpaceIdx...].trimmingCharacters(in: .whitespaces)
        return lhsString + "\n" + rhsString
    }
    
    // 알림창에 표시할내용
    var confirmAlert: Alert {
        Alert(title: Text("주문 확인"),
              message: Text("\(product.name)을(를) \(quantity)개 구매하겠습니까?"),
              primaryButton: .default(Text("확인"), action: {
                  self.placeOrder()
              }),
              secondaryButton: .cancel(Text("취소"))
        )
    }
    
    // 상품과 수량 정보를 placeOder 메서드에 인수로 전달
    func placeOrder() {
        store.placeOrder(product: product, quantity: quantity)
        self.showingPopUp = true
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: productSamples[4])
    }
}
