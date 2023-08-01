//
//  MyAccountView.swift
//  programprogram
//
//  Created by Paul Crews on 7/30/23.
//

import SwiftUI
import SwiftData

struct MyAccountView: View {
    @State var user: UserAuthModel = UserAuthModel()
    @AppStorage("is_user_signed_in") var is_user_signed_in : Bool = false
    @AppStorage("user_given_name") var user_given_name : String = ""
    @AppStorage("user_email") var user_email : String = ""
    @AppStorage("user_profile_pic") var user_profile_pic: String = ""
    
    @AppStorage("us_dark_mode") var dark_mode:Bool = false
    @AppStorage("us_color_scheme") var us_color_scheme: String = ""
    
    @State var color_scheme:Color = .cyan
    @State var m_events:[MyEvent] = []
    
    @Environment(\.modelContext) private var event_context
    @Query private var all_my_events: [MySDEvent]
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                HStack{
                    
                    AsyncImage(url: URL(string: user_profile_pic)) {
                        img in
                        img.image?
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                    .padding(5)
                    
                    Spacer()
                    VStack(alignment: .leading){
                        Text(user_given_name)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .padding(.bottom, 5)
                        Text("Events")
                        Spacer()
                    }
                    .foregroundStyle(.white)
                    .padding(5)
                    Spacer()
                }
                .padding(.horizontal, 5)
                .background(Color(color_scheme))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(5)
            .frame(width: 400, height: 150)
            .padding(.top, 10)
            HStack{
                Text("My Events \(all_my_events.count)")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Image(systemName: "square.stack.3d.down.right")
                List{
                    Section {
                        ForEach(all_my_events.indices){
                            my_event in
                            ZStack{
                                HStack{
                                    Spacer()
                                    Button {
                                        deleteItems(index: my_event)
                                    } label: {
                                        Image(systemName: "multiply")
                                    }
                                    .background(.red)
                                    .foregroundStyle(.white)

                                }
                                RoundedRectangle(cornerRadius: 10)
                                if !all_my_events.isEmpty {
                                    if all_my_events[my_event].images.count > 0 {
                                        Image(uiImage: UIImage(data: all_my_events[my_event].images.first!)!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(maxWidth: 300, maxHeight: 400)
                                    } else if all_my_events[my_event].main_image!.count > 0 {
                                        Image(uiImage: UIImage(data: all_my_events[my_event].main_image!)!)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(maxWidth: 300, maxHeight: 400)
                                    }
                                    
                                }
                                VStack{
                                    Spacer()
                                    VStack{
//                                        Text(my_event.description)
                                        Text("\(all_my_events[my_event].title)")
                                    }
                                }
                                .background(.white)
                            }
                        }
                    }
                }
                .refreshable {
                    print("SE \(all_my_events.first?.title)")
                }
            }
//            HStack{
//                Text("Settings")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                Spacer()
//                Image(systemName: "gear")
//            }
//            .foregroundStyle(.gray)
//            .padding()
//            List{
//                Toggle("Dark Mode", isOn: $dark_mode)
//                ColorPicker("Color Scheme", selection: $color_scheme)
//                
//                
//            }
//            .padding(.horizontal, 10)
            Spacer()
        }
    }
    
    private func deleteItems(index: Int) {
        withAnimation {
            event_context.delete(all_my_events[index])
        }
    }
}
