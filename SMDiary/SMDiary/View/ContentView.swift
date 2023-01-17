//
//  ContentView.swift
//  SMDiary
//
//  Created by 차소민 on 2023/01/10.
//

import SwiftUI

struct ContentView: View {
    @StateObject var postStore: PostStore = PostStore()
    @State var showingAddingSheet: Bool = false

    var body: some View {
        TabView {
            NavigationStack {
                PostView()
            }.tabItem {
                Image(systemName: "book.fill")
                Text("내 일기")
            }
            NavigationStack {
                MyPageView()
            }.tabItem {
                Image(systemName: "person.fill")
                Text("마이")
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
