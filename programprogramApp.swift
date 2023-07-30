//
//  programprogramApp.swift
//  programprogram
//
//  Created by Paul Crews on 7/25/23.
//

import SwiftUI
import SwiftData

@main
struct programprogramApp: App {
    @State var user_auth: UserAuthModel = UserAuthModel()
    @AppStorage("is_user_signed_in") var is_user_signed_in: Bool = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                if is_user_signed_in{
                    ContentView()
                } else {
                    LoginView(vm: user_auth, signed_out: is_user_signed_in)
                }
            }
            .onAppear{
                user_auth.checkStatus()
                
                print("Auth : \(user_auth.given_name) is \(user_auth.is_logged_in)")
            }
            .environmentObject(user_auth)
        }
    }
}
