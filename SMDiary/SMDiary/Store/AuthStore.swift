//
//  AuthStore.swift
//  SMDiary
//
//  Created by 차소민 on 2023/01/10.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class AuthStore: ObservableObject {
    let database = Firestore.firestore()

    @Published var userEmail = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var currentUser: Firebase.User?
    @Published var userList: [Users] = []
    @Published var currentUserData: Users?

    @Published var currentUserPosts : [Post] = []

    init() {
        currentUser = Auth.auth().currentUser
        userList = []
    }
    
    // MARK: 유저리스트 fetch
    func fetchUserList() {
        database.collection("UserList")
            .getDocuments { (snapshot, error) in
                self.userList.removeAll()
                
                if let snapshot {
                    for document in snapshot.documents {
                        let id: String = document.documentID
                        let docData = document.data()
                        let userEmail: String = docData["userEmail"] as? String ?? ""
                        
                        let nowUser: Users = Users(id: id, userEmail: userEmail)
                        
                        self.userList.append(nowUser)
                    }
                }
            }
    }
    
    //MARK: 유저리스트에 추가하기
    func addUserList(_ nowUser: Users) {
        database.collection("UserList")
            .document(nowUser.id)
            .setData(["userEmail": nowUser.userEmail
                     ])
        fetchUserList()
    }
    
    
    //MARK: 현재 로그인된 유저의 데이터를 가져옴
    func fetchCurrentUser(completion: @escaping () -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
            
            Firestore.firestore()
                .collection("UserList")
                .document(uid)
                .getDocument { (snapshot, error) in
                    if let snapshot {
                        
                        let docData = snapshot.data()
                        let id: String = docData?["id"] as? String ?? ""
                        let userEmail: String = docData?["userEmail"] as? String ?? ""
                        
                        let user: Users = Users(id: id, userEmail: userEmail)
                        
                        self.currentUserData = user
                    }
                    completion()
                }
        }

    
    
    
    
    
    
    
    
    
    //MARK: 체크용 - 이메일 형식 맞는지
    func checkAuthFormat() -> Bool {
        let emailRegex = #"^[a-zA-Z0-9+-\_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]{2,3}+$"#
        return userEmail.range(of: emailRegex, options: .regularExpression) != nil
        
    }
    
    // MARK: 체크용 - 비밀번호 형식 맞는지, 두 개 동일한지
    func checkPasswordFormat() -> Bool {
        let passwordRegex = "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&()_+=-]).{8,50}$"
        return password.range(of: passwordRegex, options: .regularExpression) != nil
        
        if password != confirmPassword {
            return false
        }else {
            return password.range(of: passwordRegex, options: .regularExpression) != nil
        }
        
    }

    
    
    
    //MARK: 로그인
    func signIn() async throws {
        
        try await Auth.auth().signIn(withEmail: userEmail, password: password) { result, error in
            if let error = error {
                print("Failed to login user:", error)
                return
            }
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            self.currentUser = result?.user
        }
    }
    
    
    //MARK: 로그아웃
    func signOut() {
        self.currentUser = nil
        try? Auth.auth().signOut()
    }
    
    
    //MARK: 회원가입
    func signUp() async -> Bool {
        if checkPasswordFormat() && checkAuthFormat(){
            
            do {
                try await Auth.auth().createUser(withEmail: userEmail, password: password)
                return true
            }
            catch {
                print(error)
                return false
                
            }
            
        } else {
            print("password: \(password), confirmPassword: \(confirmPassword), email: \(userEmail)")
            return false
        }
        
    }
    
    
}
