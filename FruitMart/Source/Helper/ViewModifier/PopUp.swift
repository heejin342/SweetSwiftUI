//
//  PopUp.swift
//  FruitMart
//
//  Created by 김희진 on 2023/08/15.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

enum PopupStyle {
    case none
    case blur
    case dimmed
}

struct GetHeightModifier: ViewModifier {
    @Binding var height: CGFloat

    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geo -> Color in
                DispatchQueue.main.async {
                    height = geo.size.height
                }
                return Color.clear
            }
        )
    }
}

fileprivate struct Popup<Message: View>: ViewModifier {
    let size: CGSize? // 팝업창의 크가
    let style: PopupStyle
    let message: Message // 팝업창에 나타낼 메세지
    
    init(
        size: CGSize? = nil,
        style: PopupStyle = .none,
        message: Message
    ) {
        self.size = size
        self.style = style
        self.message = message
    }
    
    func body(content: Content) -> some View {
        content // 팝업창을 띄운 뷰 (뒷배경 그리기)
            .blur(radius: style == .blur ? 2 : 0) // 블러스타일 경우에만 적용
            .overlay(Rectangle().fill(Color.black.opacity(style == .dimmed ? 0.4 : 0))) // dimmed 스타일인 경우에만 적용
            .overlay(popupContent) // 팝업창으로 보일 뷰
    }

    private var testView: some View {
        GeometryReader {_ in
            VStack { self.message }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private var popupContent: some View {
        GeometryReader {
            VStack { self.message } // 두개이상의 뷰가 포함되어 있으면 세로방향으로 나오도록 VStack안에 넣어줌
                // 팝업을 만들때 크기를 지정하지 않으면 뷰 너비의 0.6배, 높이의 0.25배 크기로 설정
                .frame(width: self.size?.width ?? $0.size.width * 0.6,
                       height: self.size?.height ?? $0.size.height * 0.2525)
                .background(Color.primary.colorInvert())
                .cornerRadius(12)
                .shadow(color: .primaryShadow, radius: 15, x: 5, y: 5)
                .overlay(self.checkCircleMark, alignment: .top)
                .position(x: $0.size.width / 2, y: $0.size.height / 2)
        }
    }
    
    private var checkCircleMark: some View {
        Symbol("checkmark.circle.fill", color: .peach)
            .font(Font.system(size: 60).weight(.semibold))
            .background(Color.white.scaleEffect(0.6)) // 체크마크 심볼의 색을 흰색으로 지정
            .offset(x: 0, y: -30) // 팝업 창 상단에 걸치도록 원래 위치보다 위로 가도록 설정
    }
}


fileprivate struct PopupToggle: ViewModifier { // 팝업창이 띄워졌을 때 다른 버튼이 눌리는 것을 방지하고 팝업창을 닫는 역할을 수행한다.
    @Binding var isPresented: Bool // true일 때만 팝업창 띄움
    
    func body(content: Content) -> some View {
        content
            .disabled(isPresented) // UIKit의 isUerInteractionEnabled와 같은 역할
            .onTapGesture { self.isPresented.toggle() }
    }
}

fileprivate struct PopupItem<Item: Identifiable>: ViewModifier {
    @Binding var item: Item? // nil이 아니면 팝업표시
    func body(content: Content) -> some View {
        content
            .disabled(item != nil) // 팝업이 떠있는 동안 다른 뷰에 대한 상호작용 비활성화
            .onTapGesture { self.item = nil } // 팝업 제거
    }
}


// MARK: - View Extension

extension View {
    func popup<Content: View>(
        isPresented: Binding<Bool>, // 팝업창 표시 여부에 대한 상태 관리는 팝업창을 띄우는 뷰 한곳에서 해야한다. 그래서 Binding타입을 사용해 뷰에서 전달하는 원천자료와 연동할 수 있게한다.
        size: CGSize? = nil,
        style: PopupStyle = .none,
        @ViewBuilder content: () -> Content
    ) -> some View {
        if isPresented.wrappedValue { // Binding 타입의 변수는 바로 그 값을 사용 못하고, wrappedValue를 사용해야한다.
            let popup = Popup(size: size, style: style, message: content())
            let popupToggle = PopupToggle(isPresented: isPresented)
            let modifiedContent = self.modifier(popup) // UI담당. self는 이 popup 커스텀 모디파이어를 사용한뷰
                .modifier(popupToggle) //터치 담당
            return AnyView(modifiedContent)
        } else {
            return AnyView(self) // 반환타입이 동일한 타입이여야 해서 AnyView타입으로 통일했음
        }
    }
    
    func popup<Content: View, Item: Identifiable>(
        item: Binding<Item?>,
        size: CGSize? = nil,
        style: PopupStyle = .none,
        @ViewBuilder content: (Item) -> Content
    ) -> some View {
        if let selectedItem = item.wrappedValue { // nil이 아닐때만 팝업창 띄우기
            let content = content(selectedItem)
            let popup = Popup(size: size, style: style, message: content)
            let popupItem = PopupItem(item: item)
            let modifiedContent = self.modifier(popup)
                .modifier(popupItem)
            return AnyView(modifiedContent)
        } else {
            return AnyView(self)
        }
    }
    
    func popupOverContext<Item: Identifiable, Content: View>(
        item: Binding<Item?>,
        size: CGSize? = nil,
        style: PopupStyle = .none,
        ignoringEdges edges: Edge.Set = .all,
        @ViewBuilder content: (Item) -> Content
    ) -> some View  {
        let isNonNil = item.wrappedValue != nil
        return ZStack { //현재 가장 상위뷰를 덮는 ZStack View
            self
                .blur(radius: isNonNil && style == .blur ? 2 : 0) // 블러 효과는 팝업이아니라 상위뷰에 적용되어야 한다.
            
            if isNonNil {
                Color.black
                    .luminanceToAlpha() // black에 luminanceToAlpha() 하면 clear랑 같은 효과. 하지만 clear과 다르게 상호작용 가능
                    .popup(item: item, size: size, style: style, content: content)
                    .edgesIgnoringSafeArea(edges) // 안전영역을 현재 컨텍스트에 영향을 주지 않고 원하는대로 설정
            }
        }
    }
}
