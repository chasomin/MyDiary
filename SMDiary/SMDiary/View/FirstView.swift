//
//  FirstView.swift
//  SMDiary
//
//  Created by 차소민 on 2023/01/10.
//

import SwiftUI

struct FirstView: View {
    @EnvironmentObject var authStore: AuthStore

    var body: some View {
        if authStore.currentUser != nil {
            ContentView()
                .onAppear {
                    authStore.fetchUserList()
                }
        } else {
            SignUpMainView(isFirstLaunching: .constant(false))
                .onAppear {
                    authStore.fetchUserList()
                }
        }

    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
            .environmentObject(AuthStore())
    }
}
