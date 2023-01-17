//
//  LoginView.swift
//  SMDiary
//
//  Created by 차소민 on 2023/01/10.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLogin: Bool 

    @State var id: String = ""
    @State var password: String = ""
    @EnvironmentObject var authStore: AuthStore
    @Binding var isFirstLaunching: Bool
    
    @State var passwordSecure = true

    var body: some View {
        VStack(alignment: .leading) {
            Text("Diary")
                .font(.largeTitle.bold())
            Text("아이디")
                .font(.title3)
                .padding(.top)
            ZStack (alignment: .trailing) {
                TextField("아이디를 입력해주세요", text: $authStore.userEmail)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                .padding(.bottom)
                if !authStore.userEmail.isEmpty{
                    Image(systemName: "xmark.circle.fill")
                        .onTapGesture {
                            authStore.userEmail = ""
                        }
                }
            }
            
            Text("비밀번호")
                .font(.title3)
            HStack {
                if passwordSecure {
                    ZStack(alignment: .trailing) {
                        SecureField("비밀번호를 입력해주세요", text: $authStore.password)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                        if !authStore.password.isEmpty{
                            Image(systemName: "xmark.circle.fill")
                                .onTapGesture {
                                    authStore.password = ""
                                }
                        }
                    }
                    Button {
                        passwordSecure = false
                    } label: {
                        Image(systemName: "eye")
                    }.frame(height:30)
                } else {
                    ZStack(alignment: .trailing) {
                        TextField("비밀번호를 입력해주세요", text: $authStore.password)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                        if !authStore.password.isEmpty{
                            Image(systemName: "xmark.circle.fill")
                                .onTapGesture {
                                    authStore.password = ""
                                }
                        }
                    }
                    Button {
                        passwordSecure = true
                    } label: {
                        Image(systemName: "eye.slash")
                    }.frame(height:30)
                }
            }

            Spacer()
           
            .padding(.top)

            
            Button {
                isLogin = false
                Task {
                    
                    try await authStore.signIn()
                    isFirstLaunching = false
                }
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .frame(height: 60)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        }
                    Text("로그인")
                }
            }

        }
        .padding(.horizontal)
//        .navigationTitle(Text("Diary"))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            LoginView(isLogin: .constant(false), isFirstLaunching: .constant(false))
                .environmentObject(AuthStore())
        }
    }
}
