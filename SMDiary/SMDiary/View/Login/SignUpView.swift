//
//  SignUpView.swift
//  SMDiary
//
//  Created by 차소민 on 2023/01/10.
//

import SwiftUI

struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
    // 정규식
    var emailRegex = #"^[a-zA-Z0-9+-\_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]{2,3}+$"#
    var passwordRegex = "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&()_+=-]).{8,50}$"
    
    @Binding var isSignUp: Bool
    @EnvironmentObject var authStore: AuthStore
    
    // 비밀번호 가리기, 보여주기
    @State var passwordSecure: Bool = true

    var body: some View {
        VStack(alignment: .leading){
            
            Group{
                Text("아이디")
                    .font(.title3.bold())
                    .padding(.top)
                
                ZStack (alignment: .trailing) {
                    TextField("이메일 전체를 입력해주세요", text: $email)
                        .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    if !email.isEmpty{
                        Image(systemName: "xmark.circle.fill")
                            .onTapGesture {
                                email = ""
                            }
                    }
                }
                Text(!email.isEmpty && !(email.range(of: emailRegex, options: .regularExpression) != nil) ? "이메일 형식이 맞지 않습니다" : " ")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.bottom,3)
                
            }
            
            Group{
                Text("비밀번호")
                    .font(.title3.bold())
                HStack {
                    if passwordSecure {
                        ZStack (alignment: .trailing){
                            SecureField("영문 숫자 특수기호 포함 8자 이상", text: $password)
                                .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            if !password.isEmpty{
                                Image(systemName: "xmark.circle.fill")
                                    .onTapGesture {
                                        password = ""
                                    }
                            }
                        }
                        Button {
                            passwordSecure = false
                        } label: {
                            Image(systemName: "eye")
                        }.frame(height:30)
                        
                    } else{
                        ZStack (alignment: .trailing) {
                            TextField("영문 숫자 특수기호 포함 8자 이상", text: $password)
                                .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            if !password.isEmpty{
                                Image(systemName: "xmark.circle.fill")
                                    .onTapGesture {
                                        password = ""
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
                Text(!password.isEmpty && !(password.range(of: passwordRegex, options: .regularExpression) != nil) ? "비밀번호 형식이 맞지 않습니다" : " ")
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.bottom,3)
            }
            
            Group{
                Text("비밀번호 재확인")
                    .font(.title3.bold())
                if passwordSecure{
                    HStack {
                        ZStack (alignment: .trailing) {
                            SecureField("비밀번호를 한 번 더 입력해주세요", text: $confirmPassword)
                                .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            if !confirmPassword.isEmpty{
                                Image(systemName: "xmark.circle.fill")
                                    .onTapGesture {
                                        confirmPassword = ""
                                    }
                            }
                        }
                        Button {
                            passwordSecure = false
                        } label: {
                            Image(systemName: "eye")
                        }.frame(height:30)
                    }
                }else {
                    HStack {
                        ZStack (alignment: .trailing){
                            TextField("비밀번호를 한 번 더 입력해주세요", text: $confirmPassword)
                                .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            if !confirmPassword.isEmpty{
                                Image(systemName: "xmark.circle.fill")
                                    .onTapGesture {
                                        confirmPassword = ""
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
                Text(!confirmPassword.isEmpty && password != confirmPassword ? "비밀번호가 다릅니다" : "")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            // 아이디랑 비밀번호가 정규식에 맞고, 비밀번호와 비밀번호재확인이 일치해야지 버튼 활성화.
            if email.range(of: emailRegex, options: .regularExpression) != nil && password.range(of: passwordRegex, options: .regularExpression) != nil && password == confirmPassword {
                Button {
                    isSignUp = false
                    Task{
                        authStore.userEmail = self.email
                        authStore.password = self.password
                        authStore.confirmPassword = self.confirmPassword
                        await authStore.signUp()
                        try await authStore.signIn()
                        let userUID = String(AuthStore().currentUser!.uid)
                        try await authStore.addUserList(Users(id: userUID, userEmail: self.email))
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
                        Text("회원가입")
                    }
                }
            } else {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .frame(height: 60)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        }
                    Text("회원가입")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.horizontal)
        .navigationTitle(Text("회원가입"))
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SignUpView(isSignUp: .constant(false))
                .environmentObject(AuthStore())

        }
    }
}
