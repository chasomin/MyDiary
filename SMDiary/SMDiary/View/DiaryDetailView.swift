//
//  DiaryDetailView.swift
//  SMDiary
//
//  Created by 차소민 on 2023/01/17.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct DiaryDetailView: View {
    var post: Post
    @EnvironmentObject var authStore: AuthStore
    @State var pickphoto: String = ""
    @State var isPickphoto: Bool = false
    
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading){
                    if !post.photos.isEmpty{
                        TabView{
                            ForEach(post.photos, id: \.self) { photos in
                                Button {
                                    pickphoto = photos
                                    isPickphoto = true
                                } label: {
                                    WebImage(url: URL(string: photos))
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                .padding(.top)
                            }
                        }
                        .frame(width: 400,height: 300)
                        .tabViewStyle(.page)
                    }
                    
                    Text(post.diary)
                        .padding(.vertical)
                    
                    HStack{
                        
                        Text("\(TimestampToString.dateString2(post.createdAt))")
                            .font(.footnote)
                        Spacer()
                        Text("\(TimestampToString.dateString3(post.createdAt))")
                            .font(.footnote)
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
            .fullScreenCover(isPresented: $isPickphoto, content:{
                PhotoView(pickphoto: $pickphoto, isPickphoto: $isPickphoto)
            })
        }
    }


struct DiaryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DiaryDetailView(post: Post(id: "", user: "", diary: "", createdAt: Timestamp(), photos: []))
    }
}
