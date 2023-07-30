//
//  LoginView.swift
//  programprogram
//
//  Created by Paul Crews on 7/25/23.
//

import SwiftUI
import GoogleSignIn

struct LoginView: View {
    @State var vm: UserAuthModel
    @AppStorage("is_user_signed_in") var is_user_signed_in:Bool = false
    @State var signed_out: Bool = false
    
    fileprivate func SignInButton() -> Button<Text>{
        Button(action: {
            vm.signIn()
        }, label: {
            Text("Sign In")
        })
    }
    
    fileprivate func SignOutButton() -> Button<Text>{
        Button(action: {
            vm.signOut()
        }, label: {
            Text("SignOut")
        })
    }
    
    fileprivate func ProfilePic() -> some View {
        AsyncImage(url: URL(string: vm.profile_img)) { img in
            img.image?
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
        }
    }
    
    fileprivate func UserInfo() -> Text {
        return Text(vm.given_name)
    }
    var body: some View {
//        if is_user_signed_in{
            VStack{
                if is_user_signed_in{
                    UserInfo()
                    ProfilePic()
                }
                if is_user_signed_in {
                    SignOutButton()
                        .padding()
                        .foregroundColor(.white)
                        .background(.red.opacity(0.75))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    SignInButton()
                        .padding()
                        .foregroundColor(.white)
                        .background(.green.opacity(0.75))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
//                if vm.error_message.count > 3{
//                    Text(vm.error_message)
//                }
            }
            .onAppear {
                is_user_signed_in = false
                let x = Timer(timeInterval: 1.0, repeats: false) { timer in
                    signed_out = true
                    print(" SH \(is_user_signed_in) and \(timer)")
                }
                print(" EX \(x.timeInterval) -- \(is_user_signed_in)")
            }
            .toolbar(content: {
                Button{
                    if is_user_signed_in{
                        vm.signOut()
                    } else {
                        vm.signOut()
                    }
                } label:{
                    Text(is_user_signed_in ? "Sign Out" : "Login")
                }
            })
//        } else {
//            ContentView()
//        }
    }
}
