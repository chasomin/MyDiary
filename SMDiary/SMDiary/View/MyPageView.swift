//
//  MyPageView.swift
//  SMDiary
//
//  Created by 차소민 on 2023/01/10.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var authStore: AuthStore
    @State var isPresented: Bool = false


    var body: some View {
        VStack(alignment:.leading){
            Text("\(authStore.currentUserData?.userEmail.components(separatedBy: "@")[0] ?? "")님의 마이페이지")
                .font(.title2)
            Divider()
                .padding(.vertical)
            Button {
                if authStore.currentUser != nil {
                    authStore.signOut()
                }
            } label: {
                if authStore.currentUser != nil {
                    HStack {
                        Image(systemName: "person.crop.circle.badge.minus.fill")
                        Text("로그아웃")
                    }
                }
            }
        }
        .padding(.horizontal)
        
        .fullScreenCover(isPresented: $isPresented) {
            SignUpMainView(isFirstLaunching: $isPresented)
        }
        
        .onAppear {
            authStore.fetchCurrentUser{
                guard let currentUser = authStore.currentUserData else { return }
            }
                }
            }
            
        }

   

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
