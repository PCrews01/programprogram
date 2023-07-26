//
//  programprogramApp.swift
//  programprogram
//
//  Created by Paul Crews on 7/25/23.
//

import SwiftUI
import SwiftData

@main
struct programprogramApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
