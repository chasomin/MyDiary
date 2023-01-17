//
//  SMDiaryApp.swift
//  SMDiary
//
//  Created by 차소민 on 2023/01/10.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct SMDiaryApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    @AppStorage("_isFirstLaunching") var isFirstLaunching: Bool = true

    var body: some Scene {
        WindowGroup {
            FirstView()
                .environmentObject(AuthStore())
//            ContentView()
//                .fullScreenCover(isPresented: $isFirstLaunching) {
//                                SignUpMainView(isFirstLaunching: $isFirstLaunching)
//                            }
//                .environmentObject(AuthStore())
        }
    }
}
