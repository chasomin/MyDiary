//
//  TermsView.swift
//  SMDiary
//
//  Created by 차소민 on 2023/01/10.
//

import SwiftUI

struct TermsView: View {
        // 약관동의 체크박스를 위한
        @State var isAllCheck = false
        @State var isCheck1 = false
        @State var isCheck2 = false
        @State var isCheck3 = false
        @State var isCheck4 = false
        @State var isCheck5 = false
        @State var isCheck6 = false
        
        // 회원가입 완료버튼으로 화면 내리기 위한
        @Binding var isSignUp: Bool
        
        var body: some View {
            NavigationStack {
                Group {
                    VStack(alignment:.leading){

                        HStack{
                            Button {
                                isAllCheck.toggle()
                                if isAllCheck {
                                    isCheck1 = true
                                    isCheck2 = true
                                    isCheck3 = true
                                    isCheck4 = true
                                    isCheck5 = true
                                    isCheck6 = true
                                } else {
                                    isCheck1 = false
                                    isCheck2 = false
                                    isCheck3 = false
                                    isCheck4 = false
                                    isCheck5 = false
                                    isCheck6 = false
                                }
                            } label: {
//                                Image(systemName: isAllCheck ? "checkmark.square.fill" : "checkmark.square.fill")
//                                    .foregroundColor(isAllCheck ? .black : .gray)
                                Image(systemName: isCheck1 && isCheck2 && isCheck3 && isCheck4 && isCheck5 && isCheck6 ? "checkmark.square.fill" : "checkmark.square.fill")
                                    .foregroundColor(isCheck1 && isCheck2 && isCheck3 && isCheck4 && isCheck5 && isCheck6 ? .black : .gray)
                                // 다른 약관 하나라도 풀면 전체선택 풀리게 함.
                            }
                            Text("전체동의")
                        }
                        Divider()
                        Group{
                            HStack{
                                Button {
                                    isCheck1.toggle()
                                } label: {
                                    Image(systemName: isCheck1 ? "checkmark.square.fill" : "checkmark.square.fill")
                                        .foregroundColor(isCheck1 ? .black : .gray)

                                }
                                HStack {
                                    Text("서비스 이용 약관")
                                    Text("(필수)")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.bottom)
                            HStack{
                                Button {
                                    isCheck2.toggle()
                                } label: {
                                    Image(systemName: isCheck2 ? "checkmark.square.fill" : "checkmark.square.fill")
                                        .foregroundColor(isCheck2 ? .black : .gray)
                                }
                                HStack {
                                    Text("개인 정보 수집 및 이용 동의")
                                    Text("(필수)")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.bottom)

                            HStack{
                                Button {
                                    isCheck3.toggle()
                                } label: {
                                    Image(systemName: isCheck3 ? "checkmark.square.fill" : "checkmark.square.fill")
                                        .foregroundColor(isCheck3 ? .black : .gray)
                                }
                                HStack {
                                    Text("개인정보 제 3자 제공 동의")
                                    Text("(필수)")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.bottom)



                            HStack{
                                Button {
                                    isCheck5.toggle()
                                } label: {
                                    Image(systemName: isCheck5 ? "checkmark.square.fill" : "checkmark.square.fill")
                                        .foregroundColor(isCheck5 ? .black : .gray)
                                }
                                Text("개인정보 수집 및 이용 동의 (선택)")
                            }
                            .padding(.bottom)

                            HStack{
                                Button {
                                    isCheck6.toggle()
                                } label: {
                                    Image(systemName: isCheck6 ? "checkmark.square.fill" : "checkmark.square.fill")
                                        .foregroundColor(isCheck6 ? .black : .gray)
                                }
                                Text("이벤트/마케팅 수신 동의(선택)")
                            }
                        }

                    }
                    .padding(.bottom, 40)
                    
                    
                    // 버튼, 필수 약관 체크 되어있어야지 활성화
                    VStack(alignment: .center){
                        Spacer()
                        if isCheck1 && isCheck2 && isCheck3 && isCheck4 {
                            NavigationLink(destination: SignUpView(isSignUp: $isSignUp)){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.white)
                                        .frame(height: 60)
                                        .overlay{
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.black, lineWidth: 1)
                                        }
                                    Text("다음")
                                }
                            }
                        }else{
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white)
                                    .frame(height: 60)
                                    .overlay{
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 1)
                                    }
                                Text("다음")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.top, 30)
                }
                .navigationTitle(Text("가입약관"))
                .padding(.horizontal)
                .padding(.top)
            }

        }
    
}

struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView(isSignUp :.constant(false))
    }
}
