//
//  TeamStatsView.swift
//  SnapStats
//
//  Created by Seth Rojas on 7/4/24.
//

import SwiftUI
import SwiftData

struct TeamStatsView: View {
    var team: TeamModel
    let leaderStatAbbrev = ["PTS", "REB" ,"AST", "STL" , "BLK"]
    let leaderStatFull = ["Points" , "Rebounds" , "Assists" , "Steals" , "Blocks"]
    let playerStatsAbrev = ["PTS", "OREB" , "DREB" , "REB" , "AST" ,"STL" , "BLK" ,"TOV" ,"PF"]
    let shootingStatsAbrev = ["FGM" , "FGA" , "FG%" , "3PM" , "3PA" , "3P%" , "FTM" , "FTA" , "FT%" , "2PM" , "2PA" , "2P%"]
    
    var body: some View {
        ScrollView {
            VStack {
                
                VStack (alignment: .leading) {
                    Text("Team Leaders")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    Divider()
                    ScrollView(.horizontal) {
                        LazyHStack (){
                            ForEach(leaderStatAbbrev.indices, id: \.self) {index in
                                showStatLeaderWithImage(statName: leaderStatAbbrev[index], leaderStatFull[index], team: team)
                            }
                        }
                    }
                    .frame(height: 175)
                    
                    Divider()
                }
                
                
                ScrollView(.horizontal) {
                    Grid(horizontalSpacing: 15) {
                        HStack {
                            Text("Player Stats")
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        GridRow {
                            Text("Name")
                            Text("GP")
                            ForEach(playerStatsAbrev, id: \.self) {statName in
                                Text(statName)
                            }
                            Text("AST/TO")
                        }
                        .bold()
                        .underline()
                        
                        ForEach(team.players) {player in
                            GridRow {
                                Text(player.name)
                                Text(team.games.count.description) //GP
                                ForEach(playerStatsAbrev, id: \.self) {val in
                                    Text("\( team.getPlayerAverageInStat(stat: val, id: player.id), specifier: "%.1f")")
                                }
                                Text( (team.getPlayerAverageInStat(stat: "AST", id: player.id) / team.getPlayerAverageInStat(stat: "TOV", id: player.id)).description )
                                
                            }
                        }
                        
                        HStack {
                            Text("Shooting Stats")
                                .font(.title2)
                                .bold()
                            Spacer()
                        }
                        
                        GridRow {
                            Text("Name")
                            ForEach(shootingStatsAbrev, id: \.self) {shootingStat in
                                Text(shootingStat)
                            }
                        }
                        .bold()
                        .underline()
                        
                        ForEach(team.players) {player in
                            GridRow {
                                Text(player.name)
                                ForEach(shootingStatsAbrev, id: \.self) {val in
                                    Text("\( team.getPlayerShootingStatAverage(stat: val, id: player.id) * 100, specifier: "%.1f")")
                                }
                            }
                        }
                    }
                    
                }
                .padding()
            }
        }
        .toolbarBackground(.brightOrange, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationTitle(team.name)
        .preferredColorScheme(.dark)
    }
    
//    func showStatLeaderWithImage(statName: String, _ stat: String) -> some View {
//        let calc = calculateStatLeader(stat: statName, team: team)
//        let player = calc.1
//        let highestValue = calc.0
//        
//        return HStack {
//            VStack (alignment: .leading) {
//                Text(stat)
//                    .font(.title3)
//                    .bold()
//                HStack {
//                    if let data = player.image, let uiImage = UIImage(data: data) {
//                        
//                    } else {
//                        Image("UnknownPersonHeadshot")
//                            .resizable()
//                            .scaledToFill()
//                            .clipShape(Circle())
//                            .frame(width: 75, height: 75)
//                    }
//                    VStack (alignment: .leading) {
//                        HStack {
//                            Text(player.name.abbreviatedName())
//                                .lineLimit(1)
//                            Text(player.position.rawValue)
//                                .opacity(0.5)
//                        }
//                        
//                        Text(highestValue.description)
//                            .font(.title)
//                            .bold()
//                        
//                    }
//                    .padding(.leading, 5)
//                    
//                }
//            }
//        }
//        .padding()
//        .frame(width: 225)
//        .background(.ultraThinMaterial)
//        .clipShape(RoundedRectangle(cornerRadius: 25.0))
//    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TeamModel.self, configurations: config)
    
    let team = TeamModel(name: "Catalina Foothills", players: [])
    
    var idPB = [UUID : PlayerStats]()
    for i in 0..<10 {
        var id = UUID()
        idPB[id] = PlayerStats(FTA : Int.random(in: 0...3), FTM: Int.random(in: 0...3), P2M: Int.random(in: 0...3), P2A: Int.random(in: 0...3), P3M: Int.random(in: 0...3), P3A: Int.random(in: 0...3), AST: Int.random(in: 0...3), DREB: Int.random(in: 0...3), OREB: Int.random(in: 0...3), STL: Int.random(in: 0...3), BLK: Int.random(in: 0...3), TOV: Int.random(in: 0...3))
        team.players.append(Player(id: id,name: "Seth Rojas", number: 21, heightInch: 70, weightLbs: 150, position: .SG))
    }
    team.games.append(Game(date: Date(), isUserHome: false, userPlayerBoxStats: idPB, oppTeamName: "Bad Team", oppPlayerBoxStats: [PlayerStats(FTA : Int.random(in: 0...3), FTM: Int.random(in: 0...3), P2M: Int.random(in: 0...3), P2A: Int.random(in: 0...3), P3M: Int.random(in: 0...3), P3A: Int.random(in: 0...3), AST: Int.random(in: 0...3), DREB: Int.random(in: 0...3), OREB: Int.random(in: 0...3), STL: Int.random(in: 0...3), BLK: Int.random(in: 0...3), TOV: Int.random(in: 0...3))], gameLog: []))
    team.games.append(Game(date: Date(), isUserHome: false, userPlayerBoxStats: idPB, oppTeamName: "Bad Team", oppPlayerBoxStats: [], gameLog: []))
    team.games.append(Game(date: Date(), isUserHome: false, userPlayerBoxStats: idPB, oppTeamName: "Bad Team", oppPlayerBoxStats: [], gameLog: []))
    team.games.append(Game(date: Date(), isUserHome: false, userPlayerBoxStats: idPB, oppTeamName: "Bad Team", oppPlayerBoxStats: [], gameLog: []))
    return TeamStatsView(team: team)
        .modelContainer(container)
}
