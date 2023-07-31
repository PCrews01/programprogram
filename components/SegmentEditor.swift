//
//  SegmentEditor.swift
//  programprogram
//
//  Created by Paul Crews on 7/30/23.
//

import SwiftUI

struct SegmentEditor: View {
    @Binding var event_segment:EventSegment
    @Binding var event_segments:[EventSegment]
    @Binding var plus_btn_width:CGFloat
    @Binding var plus_btn_height:CGFloat
    @Binding var segment_list_height:CGFloat
    @State var show_presenter:Bool = true
    @State var segment_added:Bool = false
    @State var presenter_width:CGFloat = 250
    var body: some View {
            VStack(alignment:.leading){
                if segment_added{
                    HStack{
                        Spacer()
                        Text("Segment Added")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding()
                    .foregroundStyle(.white)
                    .background(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom, 10)
                    .onChange(of: show_presenter) { oldValue, newValue in
                        if newValue == true {
                            withAnimation(.bouncy(duration:0.8)){
                                presenter_width = 250
                            }
                        } else {
                            withAnimation(.bouncy(duration:0.8)) {
                                presenter_width = 0
                            }
                        }
                    }
                }
                Text("Add a Segment")
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                TextField("Segment", text: $event_segment.title)
                    .frame(height: 35)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 3)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                    .padding([.horizontal], 14)
                    .textContentType(.name)
                    .submitLabel(.next)
                    .onChange(of: event_segment.title) { old, new_val in
                        if event_segment.title.count > 3{
                            withAnimation((.bouncy(duration: 0.8))){
                                plus_btn_width = 30
                                plus_btn_height = 40
                            }
                        }
                    }

                HStack{
                if show_presenter {
                    TextField("Presenter", text: $event_segment.presenter)
                        .frame(width: presenter_width, height: 35)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.horizontal], 3)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                        .padding([.horizontal], 14)
                }
                    Toggle(!show_presenter ? "Presenter?" : "", isOn: $show_presenter)
                        .frame(width: show_presenter ? 60 : 300)
                }
                .frame(width: 350, height: 40)
            }.padding(.bottom, 10)
            .onChange(of: event_segment.title) { oldValue, newValue in
                if event_segments.contains(where: { segments in
                    segments.title == oldValue
                }){
                    withAnimation(.bouncy(duration:0.8)) {
                    segment_added.toggle()
                }
                    Timer.scheduledTimer(withTimeInterval: 0.9, repeats: false) { _ in
                        withAnimation(.bouncy(duration: 0.8)) {
                            segment_added.toggle()
                        }
                    }
                } else {
                    
                    withAnimation(.bouncy(duration: 1.6)){
                        segment_added = false
                    }
                }
                
            }

    }
}
