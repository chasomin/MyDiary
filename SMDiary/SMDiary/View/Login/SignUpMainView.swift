//
//  SignUpMainView.swift
//  SMDiary
//
//  Created by 차소민 on 2023/01/10.
//

import SwiftUI

struct SignUpMainView: View {
    @State var isLogin: Bool = false
    @State var isSignUp: Bool = false
    @Binding var isFirstLaunching: Bool

    var body: some View {
        VStack(alignment: .leading){
            Text("하루끝.")
                .font(.largeTitle.bold())
            Text("Diary")

            Spacer()
            
            //TODO: 앱 로고 넣기
            HStack {
                Spacer()
                Image(systemName: "circle.fill")
                        .resizable()
                    .frame(width: 250, height: 250)
                Spacer()
            }

            Spacer()
            Button {
                isLogin.toggle()
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .frame(height: 60)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        }
                    Text("이메일 로그인하기")
                }
            }

            
            Button {
                isSignUp.toggle()
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .frame(height: 60)
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        }
                    Text("회원가입하기")
                }
            }
        }
        .padding(.horizontal)

        .sheet(isPresented: $isSignUp) {
            TermsView(isSignUp: $isSignUp)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)

        }

        .fullScreenCover(isPresented: $isLogin){
            LoginView(isLogin: $isLogin, isFirstLaunching: $isFirstLaunching)
        }
    }
}

struct SignUpMainView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpMainView(isFirstLaunching: .constant(false))
    }
}
