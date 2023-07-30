//
//  SegmentListItem.swift
//  programprogram
//
//  Created by Paul Crews on 7/30/23.
//

import SwiftUI

struct SegmentListItem: View {
    @State var seg : EventSegment
    @State var editing_segment: Bool
    @State var segment_editor : Int
    @State var event_segments:[EventSegment]
    
    @State var open_btn_width:CGFloat = 30
    @State var open_btn_height:CGFloat = 30
    @State var open_list_height:CGFloat = 250
    var body: some View {
        HStack{
            HStack{
                Text("\(seg.index + 1))")
                    .padding(.trailing, 5)
                if editing_segment{
                    SegmentEditor(
                        event_segment: $seg,
                        event_segments: $event_segments,
                        plus_btn_width: $open_btn_width,
                        plus_btn_height: $open_btn_height,
                        segment_list_height: $open_list_height)
                    
                } else {
                    Text("\(seg.title) presented by \(seg.presenter)")
                }
                Spacer()
            }
            .tag(seg.title)
            .padding()
            Spacer()
            HStack{
                Button {
                    editing_segment.toggle()
                    segment_editor = seg.index
                } label: {
                    Image(systemName: "pencil")
                }
                .padding()
                .foregroundColor(.white)
                .background(.green.opacity(0.75))
                .frame(width: 30, height: 30)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
                Button {
                    print("delete me")
                } label: {
                    Image(systemName: "multiply")
                }
                .padding()
                .foregroundColor(.white)
                .background(.red.opacity(0.75))
                .frame(width: 30, height: 30)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                
            }
        }
    }
}
