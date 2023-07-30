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
    
    var body: some View {
            VStack(alignment:.leading){
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
                
                TextField("Presenter", text: $event_segment.presenter)
                    .frame(height: 35)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 3)
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                    .padding([.horizontal], 14)
                    .onChange(of: event_segment.presenter) { old, new_val in
                        if new_val.count > 3 && event_segment.presenter != "" {
                            withAnimation((.bouncy(duration: 0.8))){
                                plus_btn_width = 30
                                plus_btn_height = 40
                            }
                        }
                    }
                
            }.padding(.bottom, 10)

    }
}
