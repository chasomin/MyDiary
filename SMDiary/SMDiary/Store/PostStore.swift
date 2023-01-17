//
//  PostStore.swift
//  SMDiary
//
//  Created by 차소민 on 2023/01/10.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseCore
import FirebaseStorage
import SwiftUI



class PostStore: ObservableObject {
    @Published var posts: [Post] = []
//    @Published var currentUser: Firebase.User?

    let database = Firestore.firestore()

    init() {
       posts = []
    }

    // MARK: fetch 함수
    func fetchPost()  {
//        do {
          database.collection("Post")
                .order(by: "createdAt", descending: true)
//                .whereField("user", isEqualTo: AuthStore().currentUserData?.userEmail)
                .getDocuments { (snapshot, error) in
                    self.posts.removeAll()
                if let snapshot {
                        for document in snapshot.documents {
                            let id: String = document.documentID
                            
                            let docData = document.data()
                            
                            let user: String = docData["user"] as? String ?? ""
                            let diary: String = docData["diary"] as? String ?? ""
                            let createdAt: Timestamp = docData["createdAt"] as? Timestamp ?? Timestamp(date: Date())
                            let photos: [String] = docData["photos"] as? [String] ?? []
                            
                            let post: Post = Post(id: id, user: user, diary: diary, createdAt: createdAt, photos: photos)
                            
                            self.posts.append(post)

                        }
                    print("\(self.posts)")
                    }
                }
//        }
//        catch {
//            print(error)
//        }
    }
    
//    func addPost(_ post: Post, selectedImages: [UIImage?]) async throws {
//        //        guard let uid = Auth.auth().currentUser?.uid else { return }
//        do {
//
//            let uploadedPhotos = await uploadPhoto(selectedImages: selectedImages){ image in
//
//                self.database.collection("Post")
//                    .document(post.id)//
//                    .setData(["user": post.user,
//                              "diary": post.diary,
//                              "createdAt": post.createdAt,
//                              "photos": image
//                             ]){
//                        error in
//                        if error == nil {
//                            Task{
//                                await self.fetchPost()
//                            }
//                        }
//                    }
//
//            }
//        } catch {
//            print(error)
//        }
//        print("애드패치~~~~~~~~~~~")
//    }
        
    
    func addPost(_ post: Post, selectedImages: [UIImage?]) {
        database.collection("Post")
            .document(post.id)
            .setData(["user": post.user,
                      "diary": post.diary,
                      "createdAt": post.createdAt,
                      "photos": post.photos
                     ])
        
        // MARK: 스토리지 업로드, url추출
        storeImageToStorage(id: post.id, selectedImages: selectedImages)
    }
    
    
    
    func removePost(_ post: Post)  async throws {
        do {
            
            try await database.collection("Post")
                .document(post.id).delete()
             fetchPost()
        }
        catch {
            print(error)
        }
    }
    
    
    func storeImageToStorage(id:String, selectedImages: [UIImage?]) {
        //일단 랜덤값 넣음
        let uid = id
        var photos: [String] = []
        
        for selectedImage in selectedImages {
            
            let photoID = UUID().uuidString
            let ref = Storage.storage().reference(withPath: photoID)
            
            guard selectedImage != nil else {
                return
            }

            guard let imageData = selectedImage?.jpegData(compressionQuality: 0.5) else {
                return
            }
            
            ref.putData(imageData) { metadata, error in
                if let error = error {
                    print("\(error)")
                    return
                }
                
                ref.downloadURL() { url, error in //받아왔을때는 url추출. 스토리지 기본 함수
                    if let error = error {
                        print(error)
                        return
                    }
                    print(url?.absoluteString ?? "망함")
                    
                    guard let url = url else { return }
                    
                    photos.append(url.absoluteString)
                    postToStore(imageUrls: photos, uid: uid)
                }
            }
        }
        
        func postToStore(imageUrls: [String], uid: String)   {
                    
                    let uid = uid
                    
//                    //날짜 순서대로 정렬하려
//                    let dateFormatter: DateFormatter = {
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
//
//                        return dateFormatter
//                    }()

                    for url in imageUrls {
                        let postData = ["id": uid, "photos" : url]

                        Firestore.firestore().collection("Post").document(uid).updateData([
                            "photos" : FieldValue.arrayUnion([url])
                        ])
                            print("success")
                    }
                    //처음 배열이 왠지모르게 빔..이걸로 빼주기
                    Firestore.firestore().collection("Post").document(uid).updateData([
                        "photos" : FieldValue.arrayRemove([""])
                    ])
             fetchPost()
                }
            }

        
        
    
    
    // MARK: 스토리지 - 안됨.......
//    @Published private var selectedImage: UIImage?
    
//    func uploadPhoto(selectedImages: [UIImage?], completion: @escaping ([String]) -> Void) async  {
//        //이미지 프로퍼티가 nil인지 확인
//        var photos: [String] = []
//
//        for selectedImage in selectedImages {
//            guard selectedImage != nil else {
//                return
//            }
//
//            //storage ref 만듬
//            let storageRef = Storage.storage().reference().child(UUID().uuidString)
//            //이미지를 데이터로 전활할 수 있는지 확인
//            let imageData = selectedImage?.jpegData(compressionQuality: 0.5) //압축품질 0.8로
//
//            //이미지를 데이터로 전환할수 있는지 확인, 확인했으므로 밑에 putData는 !로 간편하게 언래핑
//            guard imageData != nil else {
//                return
//            }
//
//            //파일 경로, 이름 지정, image 폴더에 접근
////            let uuid = UUID().uuidString
////            let path = "image/\(uuid).jpg"
////
////            let fileRef = storageRef.child(path)
////            photos.append("https://firebasestorage.googleapis.com/v0/b/smdiary-ce374.appspot.com/o/image%2F\(uuid).jpg?alt=media")
//            storageRef.putData(imageData ?? Data()) { metadata, error in
//                           if let error = error {
//                               print("\(error)")
//                               return
//                           }
//
//                storageRef.downloadURL() { url, error in //받아왔을때는 url추출. 스토리지 기본 함수
//                               if let error = error {
//                                   print(error)
//                                   return
//                               }
//                               print(url?.absoluteString ?? "망함")
//
//                               guard let url = url else { return }
//
//                               photos.append(url.absoluteString)
//                           }
//                       }
//            print("포토 배열: \(photos)")///악악악악
//            // FIXME: 사진 추가해도 포토 배열: []로 나옴
//
//            //데이터 업로드
////            do{
////                let uploadTask = try await storageRef.putData(imageData ?? Data(), metadata: nil)
////            } catch {
////            }
//        }
//        completion(photos)
//
//    }
    
}
