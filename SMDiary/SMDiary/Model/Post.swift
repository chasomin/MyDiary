//
//  Post.swift
//  SMDiary
//
//  Created by 차소민 on 2023/01/10.
//

import Foundation
import Firebase
import Photos

// TODO: Users 안에 Post 넣어서 유저별로 자기 글만 볼 수 있게 하기.
struct Post : Identifiable{
    var id: String
    var user: String
    var diary: String
    var createdAt: Timestamp
    var photos: [String]
}
