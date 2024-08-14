//
//  SnapStatsApp.swift
//  SnapStats
//
//  Created by Seth Rojas on 6/20/24.
//

import SwiftUI
import SwiftData

@main
struct SnapStatsApp: App {
    @StateObject var userSaved = UserSaved()
    @StateObject var router = Router()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environmentObject(userSaved)
        .environmentObject(router)
        .modelContainer(for: TeamModel.self)

    }
}
