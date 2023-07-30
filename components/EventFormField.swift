//
//  EventFormField.swift
//  programprogram
//
//  Created by Paul Crews on 7/30/23.
//

import SwiftUI

struct EventFormField: View {
    @Binding var form_field:String
    @State var form_title:String
    var body: some View {
        TextField("Event \(form_title)", text: $form_field)
            .padding(.horizontal, 5)
            .frame(height: 35)
            .textFieldStyle(PlainTextFieldStyle())
            .padding([.horizontal], 3)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
            .padding([.horizontal], 14)
    }
}
