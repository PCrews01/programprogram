//
//  Data.swift
//  programprogram
//
//  Created by Paul Crews on 7/26/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct EventSegment {
    let id = UUID().uuidString
    var title: String
    var hour: Int?
    var minute: Int?
    var description: String?
    var index: Int
    var presenter: String
}
extension EventSegment:Identifiable{}
extension EventSegment:Hashable{
    static func == (lhs: EventSegment, rhs: EventSegment) -> Bool{
       return lhs.index > rhs.index
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(hour)
        hasher.combine(minute)
        hasher.combine(description)
        hasher.combine(index)
        hasher.combine(presenter)
    }
}
struct MyEvent {
    let id = UUID().uuidString
    var title: String
    var main_image: Image
    var images: [Image]
    var description: String
    var date: Date
    var segments: [EventSegment]
}
extension MyEvent:Identifiable{}
extension MyEvent:Hashable{
    static func == (lhs: MyEvent, rhs: MyEvent) -> Bool{
       return lhs.date < rhs.date
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(date)
        hasher.combine(segments)
    }
}

