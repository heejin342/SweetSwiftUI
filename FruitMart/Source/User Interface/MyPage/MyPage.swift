//
//  MyPage.swift
//  FruitMart
//
//  Created by 김희진 on 2023/08/23.
//  Copyright © 2023 Giftbot. All rights reserved.
//

import SwiftUI

struct MyPage: View {
    
    @EnvironmentObject var store: Store // 앱 설정에 접근하기 위해 추가
    @State private var pickedImage: Image = Image(systemName: "person.crop.circle")
    @State private var nickname: String = ""
    @State private var isPickerPresented: Bool = false {
        didSet {
            print(isPickerPresented)
        }
    }
    
    private let prickerDataSourece: [CGFloat] = [140, 150, 160]
    
    var body: some View {
        NavigationView {
            VStack {
                userInfo
                Form {
                    orderInfoSection
                    appSettingSection
                }
            }
            .navigationBarTitle("마이페이지")
        }
        .sheet(isPresented: $isPickerPresented) {
            ImagePickerView(pickedImage: self.$pickedImage)
        }
    }
    
    var userInfo: some View { // 프로필사진과 닉네임이 들어갈 컨테이너
        VStack {
            profileImage
            nicknameTextField
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .background(Color.background)
    }
    
    var profileImage: some View {
        pickedImage
            .resizable().scaledToFill()
            .clipShape(Circle())
            .frame(width: 100, height: 100)
            .overlay(pickImageButton.offset(x: 8, y: 0), alignment: .bottomTrailing) //bottomTrailing 보다 조금더 우측에 위치하도록 offset을 준다.
    }
    
    var pickImageButton: some View {
        Button(action: {
            self.isPickerPresented = true
        }) {
            Circle()
                .fill(Color.white)
                .frame(width: 32, height: 32)
                .shadow(color: .primaryShadow, radius: 2, x: 2, y: 2)
                .overlay(Image("pencil").renderingMode(.template).foregroundColor(.red))
        }
    }
    
    var nicknameTextField: some View {
        TextField("닉네임", text: $nickname)
            .font(.system(size: 25, weight: .medium))
            .textContentType(.nickname)
            .multilineTextAlignment(.center)
            .autocapitalization(.none)
    }

    var productHeightPicker: some View {
        VStack(alignment: .leading) {
            Text("삼품 이미지 높이 조절")
            
            // 피커에서 선택한 값을 productRowHeight와 연동
            Picker("", selection: $store.appSetting.productRowHeight) {
                ForEach(prickerDataSourece, id: \.self) {
                    Text(String(format: "%.0f", $0)).tag($0) // 소숫점 제거
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .frame(height: 72)
    }
    
    var appSettingSection: some View {
        Section(header: Text("앱 설정").fontWeight(.medium)) {
            Toggle("즐겨찾는 상품 표시", isOn: $store.appSetting.showFavoriteList)
                .frame(height: 44)
            productHeightPicker
        }
    }
    
    var orderInfoSection: some View {
        Section(header: Text("주문정보").fontWeight(.medium)) {
            NavigationLink(destination: OrderListView()) {
                Text("주문목록")
            }
            .frame(height: 44)
        }
    }
}

struct MyPage_Previews: PreviewProvider {
    static var previews: some View {
        MyPage()
            .environmentObject(Store())
            .onAppear {
                UITableView.appearance().separatorStyle = .singleLine
            }
    }
}
