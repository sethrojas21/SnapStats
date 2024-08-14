//
//  GameSummaryTab.swift
//  SnapStats
//
//  Created by Seth Rojas on 7/16/24.
//

import SwiftUI
import SwiftData


struct GameSummaryTab: View {
    var team: TeamModel
    var game: Game
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TeamModel.self, configurations: config)
    
    let team = TeamModel(name: "Catalina Foothills", players: [])
    
    var idPB = [UUID : PlayerStats]()
    for i in 0..<10 {
        var id = UUID()
        idPB[id] = PlayerStats()
        team.players.append(Player(id: id,name: "Seth Rojas", number: 21, heightInch: 70, weightLbs: 150, position: .SG))
    }
    team.games.append(Game(date: Date(), isUserHome: false, userPlayerBoxStats: idPB, oppTeamName: "Bad Team", oppPlayerBoxStats: [], gameLog: []))
    team.games.append(Game(date: Date(), isUserHome: false, userPlayerBoxStats: idPB, oppTeamName: "Bad Team", oppPlayerBoxStats: [], gameLog: []))
    team.games.append(Game(date: Date(), isUserHome: false, userPlayerBoxStats: idPB, oppTeamName: "Bad Team", oppPlayerBoxStats: [], gameLog: []))
    team.games.append(Game(date: Date(), isUserHome: false, userPlayerBoxStats: idPB, oppTeamName: "Bad Team", oppPlayerBoxStats: [], gameLog: []))
    return GameSummaryTab(team: team, game: team.games[0])
        .modelContainer(container)
}
