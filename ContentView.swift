//
//  ContentView.swift
//  programprogram
//
//  Created by Paul Crews on 7/25/23.
//

import SwiftUI
import SwiftData
import AuthenticationServices
import PhotosUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State var selection:Int = 0
    @State var u_model:UserAuthModel = UserAuthModel()
    @AppStorage("is_user_signed_in") var is_user_signed_in : Bool = false
    @AppStorage("user_given_name") var user_given_name : String = ""
    @AppStorage("user_email") var user_email : String = ""
    @AppStorage("user_profile_pic") var user_profile_pic: String = ""
    
    var body: some View{
        GeometryReader{ geo in
            NavigationStack{
                TabView(selection: $selection) {
                    HomeView()
                        .tag(0)
                        .tabItem {
                            Image(systemName: "house")
                        }
                    NewEventView()
                        .tag(1)
                        .tabItem {
                            Image(systemName: "square.stack.3d.down.right")
                        }
                    MyAccountView()
                        .tag(2)
                        .tabItem {
                            Image(systemName: "person.circle")
                        }
                }
            }
            .toolbar {
                HStack{
                    Text("Digital Program")
                        .font(.title)
                        .fontWeight(.black)
                    Spacer()
                    
                    AsyncImage(url: URL(string: user_profile_pic)) {
                        img in
                        img.image?
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    }
                    .onTapGesture {
                        withAnimation(.bouncy(duration:0.8)){
                            selection = 2
                        }
                    }
                    
                }
                .padding(.horizontal, 10)
                .frame(width: geo.size.width)
            }
        }
    }
    
}
#Preview {
    ContentView()
}

extension UIImage {
    var base_64: String? {
        self.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}
extension String {
    var image_from_base_64: UIImage? {
        guard let image_data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: image_data)
    }
}
