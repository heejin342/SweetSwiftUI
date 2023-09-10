//
//  ImageGallery.swift
//  FruitMart
//
//  Created by 김희진 on 2023/08/17.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

struct ImageGallery: View {
    static private let galleryImages: [String] = Store().products.map { $0.imageName }
    @State private var productImage: [String] = galleryImages
    @State private var spacing: CGFloat = 20
    @State private var scale: CGFloat = 0.020
    @State private var angle: CGFloat = 5
    @GestureState private var translation: CGSize = .zero

    var body: some View {
        VStack {
            Spacer()
            ZStack {
                backgroundCards
                frontCard // backgroundCards 중 가장 전면에 보이게 될 이미지
            }
            Spacer()
            controller
        }
        .edgesIgnoringSafeArea(.top)
    }
    
    var frontCard: some View {
        let dragGesture = DragGesture()
            .updating($translation) { (value, state, _) in
                state = value.translation
            }
        
        return FruitCard(productImage[0]) // 상품 목록의 첫 이미지
            .offset(translation)
            .shadow(radius: 4, x: 2, y: 2)
            .onLongPressGesture {
                // 길게 누르면 상품 목록의 첫 이미지를 가장 마지막으로 보낸다.
                // 두번쨰 이미지가 frontCard가 된다.
                self.productImage.append(self.productImage.removeFirst())
            }
            .simultaneousGesture(dragGesture)
    }
    
    var backgroundCards: some View {
        // frontCard 에서 보이는 첫번째 이미지 버리고 나머지 꺼꾸로 나열 ( 앞에있는 이미지가 위로 올라감)
        ForEach(productImage.dropFirst().reversed(), id: \.self) {
            self.backgroundCard(image: $0)
        }
    }
    
    var controller: some View {
        // 순서대로 간격, 크기, 각도에 대한 최소, 최대범위
        let title = ["간격", "크기", "각도"]
        let value = [$spacing, $scale, $angle]
        let ranges: [ClosedRange<CGFloat>] = [1.0...40.0, 0...0.05, -90.0...90.0]
        
        return VStack {
            ForEach(title.indices) { i in
                HStack {
                    Text(title[i])
                        .font(.system(size: 17))
                        .frame(width: 80)
                    Slider(value: value[i], in: ranges[i])
                        .accentColor(.gray.opacity(0.25))
                }
            }
        }
        .padding()
    }
    
    
    func backgroundCard(image: String) -> some View {
        let index = productImage.firstIndex(of: image)!
        let reponse = computeResponse(index: index)
        let animation = Animation.spring(response: reponse, dampingFraction: 0.68)
        
        return FruitCard(image)
            .shadow(color: .primaryShadow, radius: 2, x: 2, y: 2)
            .offset(computePosition(index: index))
            .scaleEffect(computeScale(index: index))
            .rotation3DEffect(computeAngle(index: index), axis: (0,0,1))
            .transition(AnyTransition.scale.animation(animation))
            .animation(animation)
    }
    
    // frontCard를 드래그했을때 움직인 거리와 상품의 인덱스, spacing프로퍼티의 값에 따라 카드의 위치로 결정하고 offset 수식어에 전달한다.
    func computePosition(index: Int) -> CGSize {
        let x = translation.width
        let y = translation.height - CGFloat(index) * spacing
        return CGSize(width: x, height: y)
    }
    
    func computeScale(index: Int) -> CGFloat {
        let cardScale = 1.0 - CGFloat(index) * (0.05 - scale)
        return max(cardScale, 0.1)
    }
    
    func computeAngle(index: Int) -> Angle {
        let degree = Double(index) *  Double(angle)
        return Angle(degrees: degree)
    }
    
    func computeResponse(index: Int) -> Double {
        max(Double(index) * 0.04, 0.2)
    }
}

struct ImageGallery_Previews: PreviewProvider {
    static var previews: some View {
        ImageGallery()
    }
}
