//
//  RecipeView.swift
//  FruitMart
//
//  Created by 김희진 on 2023/08/17.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

struct RecipeView: View {
    @State private var currentIndex = 0
    private let recipes = recipeSamples
    
    var body: some View {
        VStack(alignment: .leading) {
            title
            Spacer()
            recipePicker
            Spacer()
            recipeName
            recipeIndicator
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .padding(.bottom, 30)
        .padding(.top, 80)
        .background(backgroundGradient)
        .edgesIgnoringSafeArea(.top)
    }

    var title: some View {
        VStack {
            Text("과일을 활용한\n신나는 요리")
                .font(.system(size: 42))
                .fontWeight(.thin)
                .padding(.vertical)
            
            Text("토마토와 함께하는 금주의 레시피")
                .font(.headline)
                .fontWeight(.thin)
                .foregroundColor(.white)
        }
    }
    
    var recipePicker: some View {
        HStack {
            Button(action: { self.changeIndex(-1) }) {
                Text("<")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }

            Spacer()

            ResizedImage(recipes[currentIndex].imageName, contentMode: .fit)
                .padding(.horizontal)
                .transition(.stripes())
                // 뷰 전환 효과는 뷰 계층구조에 뷰가 추가되거나, 제거되는 순간에 발생하는데, 이미지만 바뀌기 때문에 이거 없으면 애니메이션이 적용안된다.
                // id 수식어는 Hashable 타입의 값을 전달받아 이걸로 뷰를 식별한다. 그리고 아이디가 달라지면 그 아이디의 뷰를 초기화한다. 그래서 뷰 계층구조가 변하니, 애니메이션 전환효과를 볼 수 있는것임!
                .id(currentIndex)
            
            Spacer()

            Button(action: { self.changeIndex(1) }) {
                Text(">")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }
    }
    
    var recipeName: some View {
        Text(recipes[currentIndex].name)
            .font(.headline)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .animation(nil) // 레시피가 변경될때 이미지가 아닌 텍스트 변경에는 애니베이션 비활성화
    }
    
    var recipeIndicator: some View {
        GeometryReader {
            Rectangle()
                .fill(Color.white.opacity(0.4))
                .frame(width: $0.size.width)
                .overlay(self.currentIndicator(proxy: $0),
                         alignment: .leading
                )
        }
        .frame(height: 2) // 인디케이터 높이
        .padding(.top)
        .padding(.bottom, 32)
        .animation(.easeOut(duration: 0.6))
    }
        
    var backgroundGradient: some View {
        let colors = [Color(hex: "#f56161"), Color(hex: "#fc9c79")]
        let gradient = Gradient(colors: colors)

        return LinearGradient (
            gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing
        ) // 배경색이 좌상단에서 우하단으로 그라이데이션이 들어가게 된다.
    }
    
    func currentIndicator(proxy: GeometryProxy) -> some View {
        let pastelYellow = Color(hex: "#fffa77")
        let width = proxy.size.width / CGFloat(recipes.count)
        
        return pastelYellow
                .frame(width: width)
                .offset(x: width * CGFloat(currentIndex), y: 0) // 현재 인덱스를 기반으로 위치 이동
    }
    
    func changeIndex(_ num: Int) {
        withAnimation(.easeInOut(duration: 0.6)) {
            currentIndex = (currentIndex + recipes.count + num) % recipes.count
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView()
    }
}
