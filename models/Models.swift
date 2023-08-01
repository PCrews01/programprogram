//
//  Data.swift
//  programprogram
//
//  Created by Paul Crews on 7/26/23.
//

import SwiftUI
import UniformTypeIdentifiers
import SwiftData

class EventSegment: Codable {
    let id = UUID().uuidString
    var title: String
    var hour: Int?
    var minute: Int?
    var details: String?
    var index: Int
    var presenter: String
    init(title: String, hour: Int? = nil, minute: Int? = nil, details: String? = nil, index: Int, presenter: String) {
        self.title = title
        self.hour = hour
        self.minute = minute
        self.details = details
        self.index = index
        self.presenter = presenter
    }
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
        hasher.combine(details)
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
struct EventDate {
    let id : String = UUID().uuidString
    var month : String
    var day : Int
    var year : Int
}
extension EventDate:Identifiable{}
extension EventDate:Hashable{
    static func == (lhs: EventDate, rhs: EventDate) -> Bool {
        return lhs.month > rhs.month
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(month)
        hasher.combine(day)
        hasher.combine(year)
    }
}
@Model
final class MySDEvent {
    @Attribute(.unique) var id:String = UUID().uuidString
    var title: String
    var main_image: Data?
    var images: [Data]
    var caption: String
    var date: Date? = Date.now
    var segments: [EventSegment]
    
    init(id: String, title: String, main_image: Data, images: [Data], caption: String, date: Date, segments: [EventSegment]) {
        self.id = id
        self.title = title
        self.main_image = main_image
        self.images = images
        self.caption = caption
        self.date = date
        self.segments = segments
    }
}
extension MySDEvent:Identifiable{}
extension MySDEvent:Hashable{
    static func == (lhs: MySDEvent, rhs: MySDEvent) -> Bool{
        return Int(lhs.date!.timeIntervalSince1970) < Int(rhs.date!.timeIntervalSince1970)
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(caption)
        hasher.combine(date)
        hasher.combine(segments)
    }
}
