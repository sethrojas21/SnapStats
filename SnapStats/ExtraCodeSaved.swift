//
//  ExtraCodeSaved.swift
//  SnapStats
//
//  Created by Seth Rojas on 6/26/24.
//

import Foundation

protocol BoxStats {
    var P2M: Int {get set}
    var P2A: Int {get set}
}

struct GamePlayer: BoxStats, Identifiable, Codable {
    var id = UUID()
    
    var name: String
    
    var P2M: Int = 0
    
    var P2A: Int = 0
}

//    @State var game = Game(homeTeam: GameTeam(teamName: "Tucson Spartans", roster: homeRoster) , awayTeam: GameTeam(teamName: "Tucson Lightning", roster: awayRoster))

//NavigationStack{
//    VStack{
//        HStack{
//            VStack{
//                Text(game.homeTeam.teamName)
//                ForEach(game.homeTeam.roster.indices, id: \.self) { index in
//                    Button(action: {
//
//                        game.homeTeam.roster[index].P2M += 1
//                    }) {
//                        HStack {
//                            Text(game.homeTeam.roster[index].name)
//                            Text("\(game.homeTeam.roster[index].P2M)")
//                        }
//                    }
//                }
//            }
//
//            VStack{
//                Text(game.awayTeam.teamName)
//                ForEach(game.awayTeam.roster.indices, id: \.self) { index in
//                    Button(action: {
//
//                        game.awayTeam.roster[index].P2M += 1
//                    }) {
//                        HStack {
//                            Text(game.awayTeam.roster[index].name)
//                            Text("\(game.awayTeam.roster[index].P2M)")
//                        }
//                    }
//                }
//            }
//        }
//
//        NavigationLink(destination: ShowFInalGameView(finalGame: FinalGame(homeTeam: game.homeTeam, awayTeam: game.awayTeam, date: Date()))) {
//            Text("Finish")
//                .foregroundStyle(.red)
//        }
//    }
//}
