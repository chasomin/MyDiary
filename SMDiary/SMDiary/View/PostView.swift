//
//  PostView.swift
//  SMDiary
//
//  Created by 차소민 on 2023/01/10.
//

import SwiftUI
import Firebase
import SDWebImageSwiftUI

//TODO: 1/12 노션 참고해서 수정, 삭제하기 변경하기

struct PostView: View {
    @EnvironmentObject var authStore: AuthStore
    
    @StateObject var postStore: PostStore = PostStore()
    @State var showingAddingSheet: Bool = false
    
    //    @State var userID: String = ""
    @State var userID: String = ""
    
    //수정, 삭제 가능하게
    @State var isEdit: Bool = false
    
    
    var body: some View {
        NavigationStack {
            List{
                ForEach(postStore.posts.filter{$0.user == authStore.currentUserData?.userEmail.components(separatedBy: "@")[0]}) { post in
                    ZStack(alignment:.trailingFirstTextBaseline){
                        HStack{
                            if isEdit{
                                //                        Button {
                                //                            //수정은 어케 함;;;;;;;;;;;;;;
                                //                        } label: {
                                //                            Image(systemName: "pencil.circle")
                                //                                .font(.title3)
                                //                                .fontWeight(.thin)
                                //                        }
                                Button {
                                    Task{
                                        try await postStore.removePost(post)
                                    }
                                } label: {
                                    Image(systemName: "minus.circle")
                                        .font(.title3)
                                        .fontWeight(.thin)
                                    
                                }
                            }
                        }
                        NavigationLink {
                            DiaryDetailView(post: post)
                        } label: {
                            PostDetailView(post: post)
                        }

                        
                    }
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    
                    Button {
                        isEdit.toggle()
                    } label: {
                        Text(isEdit ? "Done" : "Edit")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        showingAddingSheet.toggle()
                    } label: {
                        Image(systemName: "plus")

                    }
//                    NavigationLink {
//                        PlusView(postStore: postStore, showingSheet: $showingAddingSheet, userID: $userID)
//                    } label: {
//                        Image(systemName: "plus")
//
//                    }

                }
                
                ToolbarItem(placement: .navigationBarLeading){
                    Text("My Diary")
                        .bold()
                    
                }
            }
            .fullScreenCover(isPresented: $showingAddingSheet) {
                PlusView(postStore: postStore, showingSheet: $showingAddingSheet, userID: $userID)
            }
        }
        .onAppear {
//            Task{
//                try await Task.sleep(nanoseconds: 2_000_000_000)
            authStore.fetchCurrentUser{}
            postStore.fetchPost()
//            }
        }
        .refreshable {
                postStore.fetchPost()
        }
        .onChange(of: showingAddingSheet) { newShow in
            if newShow == false {
                print("newShow\(newShow)")
//                Task{
                    postStore.fetchPost()
//                }
            }

        }
    }
}


struct PostDetailView: View {
    var post: Post
    @EnvironmentObject var authStore: AuthStore    
    
//    var user: Users {
//        get {
//            if authStore.currentUser?.uid != nil {
//                return authStore.userList.filter { $0.userEmail == String(authStore.currentUser!.uid) }.first!
//            } else {
//                return Users(id: "", userEmail: "")
//            }
//        }
//    }
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                Text(post.user)
                    .font(.footnote)
                
                
                //TODO: ScrollView 대신에 LazyHStack을 사용하면 바로바로 로딩 될지도?
                ScrollView(.horizontal) {
                    HStack{
                        ForEach(post.photos, id: \.self) { photos in
                            //                        AsyncImage(url: URL(string: photos)) { image in
                            //                            image
                            //                                .resizable()
                            //                        } placeholder: {
                            //                            ProgressView()
                            //                        }
                            //                        .frame(width:90, height: 90)
                            
                            
                            //                        AsyncImage(url: URL(string: photos)) { phase in
                            //                                        switch phase {
                            //                                        case .empty:
                            //                                            ProgressView()
                            //                                        case .success(let image):
                            //                                            image.resizable()
                            //                                                .frame(maxWidth: 100, maxHeight: 100)
                            //                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            //                                        case .failure:
                            //                                            RoundedRectangle(cornerRadius: 10)
                            //                                                .frame(height: 100)
                            //                                                .foregroundColor(.mint)
                            //                                        @unknown default:
                            //                                            EmptyView()
                            //                                        }
                            //                                    }
                            
                            
                            WebImage(url: URL(string: photos))
                                .resizable()
                                .frame(width:100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                
                Text(post.diary)
                    .padding(.bottom)
                
                HStack{
                    
                    Text("\(TimestampToString.dateString2(post.createdAt))")
                        .font(.footnote)
                    Spacer()
                    Text("\(TimestampToString.dateString3(post.createdAt))")
                        .font(.footnote)
                    //                Text("\(post.createdAt.dateValue())")
                    
                    //                Text("\(TimestampToString.dateString(post.createdAt)) 전") // 작성시간
                    //                    .font(.footnote)
                }
                
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
