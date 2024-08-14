//
//  LogStatView.swift
//  SnapStats
//
//  Created by Seth Rojas on 7/15/24.
//

import SwiftUI
import SwiftData

struct LogStatView: View {
    @EnvironmentObject var router: Router
    @Binding var game: Game
    var statName: String
    var playersPlayingID: [UUID]
    var team: TeamModel
    
    var body: some View {
        GeometryReader {geo in
            LazyHGrid(rows: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(playersPlayingID, id: \.self) {id in
                    Button {
                        if statName == "P2A" {
                            game.userPlayerBoxStats[id]?.P2A += 1
                        } else if statName == "P2M" {
                            game.userPlayerBoxStats[id]?.P2M += 1
                            game.userPlayerBoxStats[id]?.P2A += 1
                        } else if statName == "P3A" {
                            game.userPlayerBoxStats[id]?.P3A += 1
                        } else if statName == "P3M" {
                            game.userPlayerBoxStats[id]?.P3M += 1
                            game.userPlayerBoxStats[id]?.P3A += 1
                        } else if statName == "FTA" {
                            game.userPlayerBoxStats[id]?.FTA += 1
                        } else if statName == "FTM" {
                            game.userPlayerBoxStats[id]?.FTM += 1
                            game.userPlayerBoxStats[id]?.FTA += 1
                        } else if statName == "DREB" {
                            game.userPlayerBoxStats[id]?.DREB += 1
                        } else if statName == "OREB" {
                            game.userPlayerBoxStats[id]?.OREB += 1
                        } else if statName == "TOV" {
                            game.userPlayerBoxStats[id]?.TOV += 1
                        } else if statName == "AST" {
                            game.userPlayerBoxStats[id]?.AST += 1
                        } else if statName == "STL" {
                            game.userPlayerBoxStats[id]?.STL += 1
                        } else if statName == "BLK" {
                            game.userPlayerBoxStats[id]?.BLK += 1
                        } else if statName == "PF" {
                            game.userPlayerBoxStats[id]?.PF += 1
                        }
                         router.gamesRouter.removeLast()
                    } label: {
                        RoundedRectangle(cornerRadius: 25.0)
                            .stroke(.brightOrange)
                            .fill(.ultraThinMaterial)
                            .opacity(0.5)
                            .frame(width: geo.size.width / 3)
                            .overlay {
                                HStack {
                                    VStack {
                                        if let data = team.players.first(where: {$0.id == id})!.image, let uiImage = UIImage(data: data) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(Circle())
                                                .background {
                                                    Circle()
                                                        .stroke(.white, lineWidth: 2.5)
                                                
                                                }
                                            
                                        } else {
                                            Image("UnknownPersonHeadshot")
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(Circle())
                                                .background {
                                                    Circle()
                                                        .stroke(.white, lineWidth: 2.5)
                                                
                                                }
                                        }
                                        
                                        Text(team.players.first(where: {$0.id == id})!.name)
                                            .font(.title)
                                            .lineLimit(2)
                                            .padding(.bottom)
                                            .foregroundStyle(.white)
                                    }
                                    .padding(.leading)
                                    
                                    VStack {
                                        Text(team.players.first(where: {$0.id == id})!.numberFormatted)
                                            .font(.title2)
                                            .minimumScaleFactor(0.5)
                                        Text(team.players.first(where: {$0.id == id})!.position.rawValue)
                                            .font(.title3)
                                            .foregroundStyle(.brightOrange)
                                    }
                                    .padding(.trailing)
                                }
                            }

                    }
                }
                
                Button {
                    if statName == "P2A" {
                        game.oppPlayerBoxStats[0].P2A += 1
                    } else if statName == "P2M" {
                        game.oppPlayerBoxStats[0].P2M += 1
                        game.oppPlayerBoxStats[0].P2A += 1
                    } else if statName == "P3A" {
                        game.oppPlayerBoxStats[0].P3A += 1
                    } else if statName == "P3M" {
                        game.oppPlayerBoxStats[0].P3M += 1
                        game.oppPlayerBoxStats[0].P3A += 1
                    } else if statName == "FTA" {
                        game.oppPlayerBoxStats[0].FTA += 1
                    } else if statName == "FTM" {
                        game.oppPlayerBoxStats[0].FTM += 1
                        game.oppPlayerBoxStats[0].FTA += 1
                    } else if statName == "DREB" {
                        game.oppPlayerBoxStats[0].DREB += 1
                    } else if statName == "OREB" {
                        game.oppPlayerBoxStats[0].OREB += 1
                    } else if statName == "TOV" {
                        game.oppPlayerBoxStats[0].TOV += 1
                    } else if statName == "AST" {
                        game.oppPlayerBoxStats[0].AST += 1
                    } else if statName == "STL" {
                        game.oppPlayerBoxStats[0].STL += 1
                    } else if statName == "BLK" {
                        game.oppPlayerBoxStats[0].BLK += 1
                    } else if statName == "PF" {
                        game.oppPlayerBoxStats[0].PF += 1
                    }
                    router.gamesRouter.removeLast()
                } label: {
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke(.brightOrange)
                        .fill(.ultraThinMaterial)
                        .opacity(0.5)
                        .frame(width: geo.size.width / 3)
                        .overlay {
                            VStack {
                                Image("appIcon")
                                    .resizable()
                                    .scaledToFit()
                                    .offset(y: -20)
                                    .padding(25)
                                Text(game.oppTeamName)
                                    .font(.title)
                                    .foregroundStyle(.brightOrange)
                                    .padding(.top, -50)
                                    .bold()

                            }
                            
                        }
                }

                
            }
        }
        .persistentSystemOverlays(.hidden)
        .preferredColorScheme(.dark)
    }
    
}

#Preview {
    var id = [UUID]()
    var idPB = [UUID : PlayerStats]()
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TeamModel.self, configurations: config)
    
    let team = TeamModel(name: "Catalina Foothills High School", players: [])
    for _ in 0..<5 {
        let iden = UUID()
        id.append(iden)
        idPB[iden] = PlayerStats()
 
        team.players.append(Player(id: iden, name: "Seth Rojas", number: 21, heightInch: 70, weightLbs: 150, position: .SG))
        
    }
    

    
    return LogStatView(game: .constant(Game(date: Date(), isUserHome: false, userPlayerBoxStats: idPB, oppTeamName: "Bad Team", oppPlayerBoxStats: [], gameLog: [])), statName: "P2M", playersPlayingID: id, team: team)
        .environmentObject(Router())
}
