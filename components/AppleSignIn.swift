//
//  AppleSignIn.swift
//  programprogram
//
//  Created by Paul Crews on 7/25/23.
//

import SwiftUI
import AuthenticationServices

struct AppleSignIn: View {
    var body: some View {
        
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result{
                case .success(let auth_result):
                    print("Auth success. Result: \(auth_result)")
                case .failure(let error):
                    print("Auth failed. Result \(error.localizedDescription)")
                }
            }
            .frame(width: 200, height: 40, alignment: .center)
    }
}

#Preview {
    AppleSignIn()
}
