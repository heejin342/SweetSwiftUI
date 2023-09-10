//
//  OrderRow.swift
//  FruitMart
//
//  Created by 김희진 on 2023/09/07.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

struct OrderRow: View {
    let order: Order
    
    var body: some View {
        HStack {
            ResizedImage(order.product.imageName)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .padding()
            
            VStack(alignment: .leading, spacing: 10) {
                Text(order.product.name)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text("w\(order.price) | \(order.quantity)개")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .frame(height: 100)
    }
}

struct OrderRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderRow(order: Order(id: 0, product: Store().products[0], quantity: 1))
    }
}
