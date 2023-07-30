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
    @Environment(\.modelContext) private var modelContext
    
    @State var u_model:UserAuthModel = UserAuthModel()
    @State var new_event: MyEvent = MyEvent(
        title: "",
        main_image: Image(systemName: "person"),
        images: [],
        description: "",
        date: Date.now,
        segments: [placehoder_segment]
    )
    
    @State var events: [MyEvent] = []
    @State var event_segments: [EventSegment] = []
    @State var event_segment: EventSegment = EventSegment(title: "", index: 1, presenter: "")
    @State var errors: [String] = []
    @State var drag_item:EventSegment?
    
    @State private var selected_tems = [PhotosPickerItem]()
    @State private var selected_images = [Image]()
    
    @AppStorage("is_user_signed_in") var is_user_signed_in : Bool = false
    @AppStorage("user_given_name") var user_given_name : String = ""
    @AppStorage("user_email") var user_email : String = ""
    @AppStorage("user_profile_pic") var user_profile_pic: String = ""
    
    @State var p_title:String = ""
    @State var plus_btn_width:CGFloat = 0
    @State var plus_btn_height:CGFloat = 0
    @State var segment_list_height:CGFloat = 0
    @State var sort_dir: String = "a"
    @State var segment_editor: Int = 0
    @State var editing_segment: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center, content: {
                //           HEADER
                HStack{
                    Text("Digital Program")
                        .font(.title)
                        .fontWeight(.heavy)
                        .background(.orange)
                    Spacer()
                }
                //            GREETING
                HStack{
                    Text("Good evening, \(u_model.given_name == "" ? user_given_name : u_model.given_name)")
                        .font(.title)
                        .fontWeight(.heavy)
                        .background(.orange)
                    Spacer()
                    Button {
                        print("Add me ")
                    } label: {
                        Image(systemName: "plus")
                            .padding(.trailing, 10)
                    }
                }
                ScrollView{
                    ScrollViewReader{
                        svr in
                        if selected_tems.count > 0 {
                            HStack{
                                ScrollView(.horizontal){
                                    LazyHGrid(rows: [GridItem(.flexible())]) {
                                        ForEach(0..<selected_images.count, id:\.self){
                                            selection in
                                            selected_images[selection]
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 200, height: 200)
                                        }
                                    }
                                }
                            }
                        }
//                        FORM
                        VStack{
                            PhotosPicker("Select Image", selection: $selected_tems, matching: .images)
                            EventFormField(form_field: $new_event.title, form_title: "title")
                            EventFormField(form_field: $new_event.description, form_title: "description")
                            DatePicker("Event Date", selection: $new_event.date)
                                .frame(height: 35)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding([.horizontal], 3)
                                .cornerRadius(10)
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                                .padding([.horizontal], 14)
                            
                            if event_segments.count > 0 {
                                VStack{
                                    HStack{
                                        Text("Segments")
                                            .fontWeight(.semibold)
                                            .padding(.bottom, 10)
                                        Spacer()
                                        Button {
                                            withAnimation(.bouncy(duration: 0.8)){
                                                sort_dir = sort_dir == "a" ? "d" : "a"
                                            }
                                        } label: {
                                            Image(systemName: sort_dir == "a" ? "arrowtriangle.up" : "arrowtriangle.down")
                                        }
                                    }
                                    ScrollView{
                                        ForEach(event_segments.sorted(by: { a, b in
                                            sort_dir == "a" ? a.index < b.index : a.index > b.index
                                        })){
                                            seg in
                                            VStack(alignment:.leading){
                                                SegmentListItem(seg: seg, editing_segment: editing_segment, segment_editor: segment_editor, event_segments: event_segments)
                                            }
                                            .background(seg.index.isMultiple(of: 2) ? .blue.opacity(0.05) : .black.opacity(0.05))
                                        }
                                    }.frame(height: segment_list_height)
                                }
                                Spacer()
                            }
                            HStack{
                                SegmentEditor(
                                    event_segment: $event_segment,
                                    event_segments: $event_segments,
                                    plus_btn_width: $plus_btn_width,
                                    plus_btn_height: $plus_btn_height,
                                    segment_list_height: $segment_list_height)
                                
                                if event_segment.title.count > 3{
                                    Button {
                                        segment_list_height = 200
                                        updateSegment()
                                        
                                    } label: {
                                        Image(systemName: "plus")
                                    }
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(.green.opacity(0.75))
                                    .frame(width: plus_btn_width, height: plus_btn_height)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                }
                            }
                            .padding()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .background(.blue.opacity(0.035))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                        }
                        .padding(10)
                        Spacer()
                        if new_event.title != "" {
                            if new_event.description != "" {
                                Button {
                                    print("Added Event")
                                } label: {
                                    HStack{
                                        Image(systemName: "plus")
                                            .resizable()
                                            .frame(width: 15, height: 14, alignment: .center)
                                        Text("Add Event")
                                    }
                                }
                            }
                        }
                    }
                }
            })
            .toolbar {
                AsyncImage(url: URL(string: user_profile_pic)) {
                    img in
                    img.image?
                        .resizable()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                }
            }
            .onChange(of: selected_tems) { oldValue, newValue in
                Task {
                    selected_images.removeAll()
                    
                    for item in selected_tems {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data){
                                let image = Image(uiImage: uiImage)
                                if !selected_images.contains(image){
                                    selected_images.append(image)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func updateSegment(){
        event_segments.append(EventSegment(
            title: event_segment.title,
            index: event_segments.count,
            presenter: event_segment.presenter))
        event_segment.title = ""
        event_segment.presenter = ""
        withAnimation(.bouncy(duration: 0.8)){
            segment_list_height = 200
        }
    }
}
#Preview {
    ContentView()
}
