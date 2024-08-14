//
//  SettingsView.swift
//  SnapStats
//
//  Created by Seth Rojas on 7/10/24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @EnvironmentObject var userSaved: UserSaved
    @Environment(\.modelContext) var context
    var team: TeamModel
    var body: some View {
        Button("Delete team") {
            withAnimation {
                team.games.removeAll()
                context.delete(team)
                userSaved.userTeamID = nil
            }
        }
            .preferredColorScheme(.dark)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TeamModel.self, configurations: config)
    
    let team = TeamModel(name: "Golden State Warriors", players: [Player(name: "Seth Rojas", number: 21, heightInch: 70, weightLbs: 151, position: .SG)])
    return SettingsView(team: team)
        .environmentObject(UserSaved())
        .modelContainer(container)
}
