//
//  PhotoView.swift
//  SMDiary
//
//  Created by 차소민 on 2023/01/17.
//

import SwiftUI
import SDWebImageSwiftUI

struct PhotoView: View {
    @Binding var pickphoto: String
    @Binding var isPickphoto: Bool

    var body: some View {
        if isPickphoto {
            VStack(alignment: .leading){
                Button {
                    isPickphoto.toggle()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title.bold())
                }

                Spacer()
                
                WebImage(url: URL(string: pickphoto))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

//struct PhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoView(post: Post(id: "", user: "", diary: "", createdAt: Timestamp(), photos: []))
//    }
//}
