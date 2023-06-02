//
//  PlusView.swift
//  SMDiary
//
//  Created by 차소민 on 2023/01/10.
//

import SwiftUI
import Firebase
import PhotosUI

struct PlusView: View {
    @StateObject var postStore: PostStore
    @State var diary: String = ""
    @Binding var showingSheet: Bool
    @Binding var userID: String
    
    //사진 여러장 불러오기 위한
    @State var selectedItems: [PhotosPickerItem] = []
    @State var selectedPhotosData: [UIImage] = []

    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Spacer()
                Button {
                    showingSheet.toggle()
                } label: {
                    Text("취소")
                    
                }
            }
            Text("오늘의 일기")
                .font(.largeTitle.bold())
            
            
            if selectedItems ==  [] {
                PhotosPicker(selection: $selectedItems, maxSelectionCount: 5, matching: .images) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                        HStack{
                            Image(systemName: "plus")
                            Image(systemName: "photo")
                        }
                    }
                    .frame(width: 90, height: 90)
                }
                .padding(.bottom)
            } else {
                HStack{
                    Spacer()
                    PhotosPicker(selection: $selectedItems, maxSelectionCount: 5, matching: .images) {
                            Label("사진 다시 고르기", systemImage: "chevron.right")
                                .font(.caption)
                    }
                }
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(selectedPhotosData, id: \.self) { photoData in
//                            if let image = photoData {
                                Image(uiImage: photoData)
                                    .resizable()
                                    .frame(width:90, height: 90)
//                            }
//                            if let image = UIImage(data: photoData) {
//                                Image(uiImage: image)
//                                    .resizable()
//                                    .frame(width:90, height: 90)
//                            }
                        }
                    }
                }
                .padding(.bottom)
            }
            
            
            Divider()
                .padding(.bottom, 8)
            
            TextField("이 곳에 일기를 작성해주세요", text: $diary, axis: .vertical)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
            
            Spacer()
            Button {
                Task{                    
                    let post: Post = Post(id: UUID().uuidString, user: String(Auth.auth().currentUser?.email?.components(separatedBy: "@")[0] ?? ""), diary: diary, createdAt: Timestamp(), photos: [])
                    
                    postStore.addPost(post, selectedImages: selectedPhotosData)
                    

                    selectedPhotosData = []
                                        
                    showingSheet.toggle()
                    postStore.fetchPost()
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
                    Text("작성하기")
                        .foregroundColor(.black)
                }
            }
        }
        .padding(.horizontal)
        .onChange(of: selectedItems) { newItems in
            for newItem in newItems {
                Task {
                    selectedPhotosData = [] // 이거 없으면 사진 다시 고를때 누적됨.
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        selectedPhotosData.append(UIImage(data: data) ?? UIImage())
//                        selectedPhotosData.append(data)

                    }
                }
         
            }
        }

    }
}

struct PlusView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            PlusView(postStore: PostStore(), showingSheet: .constant(false), userID: .constant(""))
        }
    }
}
