//
//  AuthModel.swift
//  programprogram
//
//  Created by Paul Crews on 7/25/23.
//

import SwiftUI
import GoogleSignIn

class UserAuthModel: ObservableObject{
    
    @Published var given_name: String = ""
    @Published var profile_img: String = ""
    @Published var is_logged_in: Bool = false
    @Published var error_message: String = ""
    @Published var email: String = ""
    
    @AppStorage("is_user_signed_in") var is_user_signed_in : Bool = false
    @AppStorage("user_given_name") var user_given_name : String = ""
    @AppStorage("user_email") var user_email : String = ""
    @AppStorage("user_profile_pic") var user_profile_pic: String = ""
    
    init(){
        check()
    }
    
    func checkStatus(){
        if(GIDSignIn.sharedInstance.currentUser != nil){
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else { return }
            let given_name = user.profile?.givenName
            let profile_image = user.profile?.imageURL(withDimension: 100)!.absoluteString
            let email = user.profile?.email
            self.given_name = given_name ?? ""
            self.profile_img = profile_image!
            self.is_logged_in = true
            self.email = email ?? ""
            is_user_signed_in = true
            user_email = email ?? ""
            user_given_name = given_name ?? ""
            user_profile_pic = profile_img
        } else {
            self.is_logged_in = false
            self.given_name = "Not Logged In"
            self.profile_img = ""
            self.email = ""
            is_user_signed_in = false
            user_email = ""
            user_given_name = ""
            user_profile_pic = ""
        }
    }
    
    func check(){
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                self.error_message = "error: \(error.localizedDescription)"
            }
            self.checkStatus()
        }
    }
    
    func signIn(){
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        
        let sign_in_config = GIDConfiguration.init(clientID: "999981480769-chq34gahnpgkk42t0i4902pudjsif9ql.apps.googleusercontent.com ")
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { user, error in
            if let error = error {
                self.error_message = "error: \(error.localizedDescription)"
            }
            self.checkStatus()
        }
        is_logged_in = true
    }
    
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
        is_logged_in = false
//        is_user_signed_in = false
//        is_user_signed_in = false
//        user_email = ""
//        user_given_name = ""
//        user_profile_pic = ""
        self.checkStatus()
    }
    
    
}
