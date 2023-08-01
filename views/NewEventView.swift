//
//  NewEventView.swift
//  programprogram
//
//  Created by Paul Crews on 7/30/23.
//

import SwiftUI
import SwiftData
import AuthenticationServices
import PhotosUI
import UniformTypeIdentifiers

struct NewEventView: View {
    
    @State var u_model:UserAuthModel = UserAuthModel()
    @State var event_date : String = "July 22,2023"
    @State var new_event: MySDEvent = MySDEvent(
        id: "",
        title: "",
        main_image: (UIImage(systemName: "person")?.jpegData(compressionQuality: 1))!,
        images: [],
        caption: "",
        date: Date.now,
        segments: [placehoder_segment]
    )
    
    @State var events: [MySDEvent] = []
    @State var event_segments: [EventSegment] = []
    @State var event_segment: EventSegment = EventSegment(title: "", index: 1, presenter: "")
    @State var errors: [String] = []
    @State var drag_item:EventSegment?
    
    @State private var selected_tems = [PhotosPickerItem]()
    @State private var selected_images = [Data]()
    
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
    
    @State var show_form:Bool = false
    
    @Environment(\.modelContext) private var event_context
    @Query private var all_my_events: [MySDEvent]
    
    @State var months : [String] = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
    ]
    let thirty_one_months = [ "January", "March", "May", "July", "August", "October", "December" ]
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .center, content: {
                HStack{
                    Text("New Event")
                        .font(.title3)
                        .fontWeight(.heavy)
                        .foregroundStyle(.cyan)
                    Spacer()
                    
                    if new_event.title != "" {
//                        if new_event.caption != "" {
                            Button {
                                events.append(new_event)
                                event_context.insert(new_event)
                                
                                withAnimation(.bouncy(duration: 0.8)){
                                    new_event.title = ""
                                    new_event.caption = ""
                                    new_event.segments = []
                                    new_event.images = []
                                    event_segments = []
                                    event_segment.title = ""
                                    event_segment.presenter = ""
                                    event_segment.index = 0
                                    selected_images = []
                                    selected_tems = []
                                }
                            } label: {
                                VStack{
                                    Image(systemName: "square.and.arrow.down")
                                    Text("Save Event")
                                        .font(.caption2)
                                }
                                .padding(.trailing, 10)
                            }
                    }
                }
                .padding(.horizontal, 10)
                ScrollView{
                    if selected_images.count > 0 {
                        Text("YUP")
                        HStack{
                            ScrollView(.horizontal){
                                LazyHGrid(rows: [GridItem(.flexible())]) {
                                    ForEach(0..<selected_images.count, id:\.self){
                                        image_data in
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .background(Material.ultraThinMaterial)
                                            //                                            UIImage(data: image_data)
                                            Image(uiImage: UIImage(data: selected_images[image_data])!)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    PhotosPicker("+ Add Image", selection: $selected_tems, matching: .images)
                        .onChange(of: selected_images) { o, n in
                            new_event.images = n
                            new_event.main_image = n.first
                            print("N \(n)")
                        }
                        .foregroundStyle(.white)
                        .padding(5)
                        .padding(.trailing, 5)
                        .background(.cyan)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.vertical, 5)
                    EventFormField(form_field: $new_event.title, form_title: "title")
                    EventFormField(form_field: $new_event.caption, form_title: "caption")
                    
                    
                    Button {
                        show_form.toggle()
                    } label: {
                        HStack{
                            Image(systemName: "plus")
                            Text("Segment")
                        }
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                    }
                    .padding(5)
                    .padding(.trailing, 5)
                    .background(.cyan)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.vertical, 5)
                    
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
                                    HStack{
                                        Text("Sort")
                                            .font(.caption)
                                        
                                        Image(systemName: sort_dir == "a" ? "arrowtriangle.up" : "arrowtriangle.down")
                                    }
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
                    
                }
//                ScrollView{
//                    ScrollViewReader{
//                        svr in
//                        if selected_tems.count > 0 {
//                            HStack(alignment:.center){
//                                ScrollView(.horizontal){
//                                    LazyHGrid(rows: [GridItem(.flexible())], alignment:.center) {
//                                        ForEach(0..<selected_images.count, id:\.self){
//                                            selection in
//                                            ZStack{
//                                                RoundedRectangle(cornerRadius: 10)
//                                                    .backgroundStyle(Material.ultraThinMaterial)
//                                                selected_images[selection]
//                                                    .resizable()
//                                                    .scaledToFill()
//                                                    .frame(maxWidth: 200, maxHeight: 200)
//                                            }
//                                            .frame(maxWidth: 200, maxHeight: 200)
//                                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                                        }
//                                    }
//                                }
//                            }
//                            .padding(.leading, 10)
//                        }
////                        FORM
//                        VStack{
//                            
//                            PhotosPicker("+ Add Image", selection: $selected_tems, matching: .images)
//                                .onChange(of: selected_images) { o, n in
////                                    new_event.images = n
//                                    print("N \(n)")
//                                }
//                                .foregroundStyle(.white)
//                                .padding(5)
//                                .padding(.trailing, 5)
//                                .background(.cyan)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                                .padding(.vertical, 5)
//                            EventFormField(form_field: $new_event.title, form_title: "title")
//                            EventFormField(form_field: $new_event.description, form_title: "description")
//                            DatePicker("Event Date", selection: $new_event.date)
//                                .frame(height: 35)
//                                .textFieldStyle(PlainTextFieldStyle())
//                                .padding([.horizontal], 3)
//                                .cornerRadius(10)
//                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
//                                .padding([.horizontal], 14)
//                            
//                            Button {
//                                show_form.toggle()
//                            } label: {
//                                HStack{
//                                    Image(systemName: "plus")
//                                    Text("Segment")
//                                }
//                                .foregroundStyle(.white)
//                                .fontWeight(.semibold)
//                            }
//                            .padding(5)
//                            .padding(.trailing, 5)
//                            .background(.cyan)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                            .padding(.vertical, 5)
//
//                            
//                            if event_segments.count > 0 {
//                                VStack{
//                                    HStack{
//                                        Text("Segments")
//                                            .fontWeight(.semibold)
//                                            .padding(.bottom, 10)
//                                        Spacer()
//                                        Button {
//                                            withAnimation(.bouncy(duration: 0.8)){
//                                                sort_dir = sort_dir == "a" ? "d" : "a"
//                                            }
//                                        } label: {
//                                            HStack{
//                                                Text("Sort")
//                                                    .font(.caption)
//                                                
//                                                Image(systemName: sort_dir == "a" ? "arrowtriangle.up" : "arrowtriangle.down")
//                                            }
//                                        }
//                                    }
//                                    ScrollView{
//                                        ForEach(event_segments.sorted(by: { a, b in
//                                            sort_dir == "a" ? a.index < b.index : a.index > b.index
//                                        })){
//                                            seg in
//                                            VStack(alignment:.leading){
//                                                SegmentListItem(seg: seg, editing_segment: editing_segment, segment_editor: segment_editor, event_segments: event_segments)
//                                            }
//                                            .background(seg.index.isMultiple(of: 2) ? .blue.opacity(0.05) : .black.opacity(0.05))
//                                        }
//                                    }.frame(height: segment_list_height)
//                                }
//                                Spacer()
//                            }
//                        }
//                        .padding(10)
//                        Spacer()
//                    }
//                }
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
                            try await selected_images.append(item.loadTransferable(type: Data.self)!)
                        }
                    }
                }
            }
            .sheet(isPresented: $show_form) {
                VStack{
                    HStack{
                        Spacer()
                        Button {
                            show_form.toggle()
                        } label: {
                            Image(systemName: "multiply")
                        }
                        .foregroundStyle(.red)
                        .padding()
                        .frame(width: 35, height: 35)
                    }
                    
                    HStack{
                        SegmentEditor(
                            event_segment: $event_segment,
                            event_segments: $event_segments,
                            plus_btn_width: $plus_btn_width,
                            plus_btn_height: $plus_btn_height,
                            segment_list_height: $segment_list_height)
                        
                        if event_segment.title.count > 3{
//                            event creation
                            Button {
                                var passing_event : MySDEvent = MySDEvent(
                                    id: UUID().uuidString,
                                    title: new_event.title,
                                    main_image: (UIImage(systemName: "person")?.jpegData(compressionQuality: 1))!,
                                    images: selected_images,
                                    caption: new_event.caption,
                                    date: Date.now,
                                    segments: event_segments)
                                
                                segment_list_height = 200
                                updateSegment(passed_segment: event_segment)
//                                my_events.append(MyEvent(
//                                    title: new_event.title,
//                                    main_image: selected_images.first ?? Image(systemName: "square.stack.3d.down.right"),
//                                    images: selected_images,
//                                    description: new_event.description,
//                                    date: new_event.date,
//                                    segments: event_segments))
//                                event_context.insert(object: new_event)
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
                    
                    VStack{
                        HStack{
                            Image(systemName: "info.circle.fill")
                                .resizable()
                                .frame(width: 20, height: 20, alignment: .center)
                            Text("Use this form to add a segment to your event. If there is no presenter you can click the button next to the presenter field to toggle off the presenter field.")
                        }
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .padding()
                        .background(.gray.opacity(0.25))
                        .frame(width: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    Spacer()
                }
            }
        }
    }
    func updateSegment(passed_segment: EventSegment){
        withAnimation(.bouncy(duration: 0.8)){
            segment_list_height = 200
            self.event_segment.title = ""
            self.event_segment.presenter = ""
            self.event_segment.index = 0
            self.event_segment.hour = 0
            self.event_segment.minute = 0
//            show_form.toggle()
        }
        event_segments.append(EventSegment(
            title: passed_segment.title,
            index: event_segments.count,
            presenter: passed_segment.presenter))
        
    }
}

#Preview {
    NewEventView()
}
