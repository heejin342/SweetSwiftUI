//
//  MainTabView.swift
//  FruitMart
//
//  Created by 김희진 on 2023/08/15.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    
    private enum Tabs {
        case home
        case recipe
        case gallery
        case myPage
    }
    
    @State private var selectedTab: Tabs = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Group {
                home
                recipe
                imageGallery
                myPage
            }
            .accentColor(.primary) // 콘텐츠들의 accentColor 는 primary
        }
        .accentColor(.peach) // TabView 의 accentColor 는 peach
        .edgesIgnoringSafeArea(.top)
        .statusBar(hidden: selectedTab == .recipe) // 레시피 탭일떄는 상태표시바 없음
    }
}

private extension MainTabView {
    var home: some View {
        Home()
            .tag(Tabs.home)
            .tabItem(image: "house", text: "홈")
    }
    
    var recipe: some View {
        RecipeView()
            .tag(Tabs.recipe)
            .tabItem(image: "book", text: "레시피")
    }

    var imageGallery: some View {
        ImageGallery()
            .tag(Tabs.gallery)
            .tabItem(image: "photo.on.rectangle", text: "갤러리")
    }

    var myPage: some View {
        MyPage()
            .tag(Tabs.myPage)
            .tabItem(image: "person", text: "마이페이지")
    }
}

fileprivate extension View {
    func tabItem(image: String, text: String) -> some View {
        self.tabItem {
            Symbol(image, scale: .large)
                .font(Font.system(size: 17, weight: .light))
            Text(text)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
