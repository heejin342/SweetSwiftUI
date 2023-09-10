//
//  OrderListView.swift
//  FruitMart
//
//  Created by 김희진 on 2023/09/07.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

struct OrderListView: View {
    @EnvironmentObject var store: Store
    @Environment(\.editMode) var editMode // EditButton() 없이 이걸로도 편집여부 확인할 수 있음
    
    var body: some View {
        ZStack {
            if store.orders.isEmpty {
                emptyOrders
            } else {
                orderList
            }
        }
        .navigationBarTitle("주문 목록")
        .navigationBarItems(trailing: editButton)
    }
    
    var editButton: some View {
        // 주문 내역이 있을때는 수정 버튼을, 주문 내역이 없을때는 빈 뷰를 리턴한다. EditButton는 스유에서 제공하는 뷰임..!
        !store.orders.isEmpty ? AnyView(EditButton()) : AnyView(EmptyView())
    }
    
    var emptyOrders: some View {
        VStack(spacing: 25) {
            Image("box")
                .renderingMode(.template)
                .foregroundColor(Color.gray.opacity(0.4)) //.template 으로 이미지 원래의 색을 무시하고 색을 입힌다.
            Text("주문 내역이 없습니다.")
                .font(.headline)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background)
    }
    
    var orderList: some View {
        List {
            ForEach(store.orders) {
                OrderRow(order: $0)
            }
            .onDelete(perform: store.deleteOrder(at:))
            .onMove(perform: store.moveOrder(from:to:))
        }
    }
}

struct OrderListView_Previews: PreviewProvider {
    static var previews: some View {
        OrderListView()
    }
}
