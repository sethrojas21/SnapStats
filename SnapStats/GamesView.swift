//
//  GamesView.swift
//  SnapStats
//
//  Created by Seth Rojas on 6/27/24.
//

import SwiftUI
import SwiftData

struct GamesView: View {
    @Environment(\.modelContext) var context
    @EnvironmentObject var userSaved: UserSaved
    @EnvironmentObject var router: Router
    
    var team: TeamModel
    var date = Date()
    
    var body: some View {
        NavigationStack(path: $router.gamesRouter) {
            GeometryReader { geo in
                ZStack {
                    VStack{

                        if team.games.isEmpty {
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(.gray)
                                .frame(height: geo.size.height * 0.25)
                                .overlay {
                                    Text("No recent games")
                                        .foregroundStyle(.blue)
                                }
                                .padding()
                            Spacer()
                        } else {
//                            LazyVStack {
                                ScrollView {
                                    ForEach(team.games.reversed()) {game in
                                        Button {
                                            router.gamesRouter.append(.seeSingleGameSummary(game))
                                        } label: {
                                            SingleGameUII(team, game, geo, size: 0.275)
                                                .padding(.top)
                                        }
                                        .buttonStyle(PlainButtonStyle())


                                         

                                    }
//                                }
                            }
                            
                        }
                    }
                    
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            
                            Button {
                                router.gamesRouter.append(.gameSettings)
                            } label: {
                                Circle()
                                    .frame(width: geo.size.width * 0.2)
                                    .foregroundStyle(.brightOrange)
                                    .padding()
                                    .overlay {
                                        Image(systemName: "plus")
                                            .foregroundStyle(.black)
                                            .font(.title)
                                    }
                            }
                            
                        }
                    }
                }
            }
            .navigationDestination(for: Router.GamesRoute.self, destination: { destination in
                switch destination {
                case .gameSettings:
                    GameSettingsView(team: team)
                case .starters(let inputGameObject):
                    StartersView(team: team, gameObject: inputGameObject)
                case .pregame(let inputGameObject):
                    PreGameView(inputGameObject: inputGameObject, team: team)
                case .playgame(let inputGameObject):
                    PlayGameView(inputGameObject: inputGameObject, team: team)
                case .logstat(let game, let statName, let playersPlayingID):
                    LogStatView(game: game, statName: statName, playersPlayingID: playersPlayingID, team: team)
                case .seeSingleGameSummary(let game):
                    GameSummaryView(game: game, team: team)
                }
            })
            .toolbarBackground(Color.brightOrange, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationTitle("Games")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }
                }
            }
            .tint(.blue)
        }
        .preferredColorScheme(.dark)
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
    
    return GamesView(team: team)
        .modelContainer(container)
        .environmentObject(UserSaved())
        .environmentObject(Router())
}
