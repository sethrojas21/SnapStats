//
//  PlayGameView.swift
//  SnapStats
//
//  Created by Seth Rojas on 7/15/24.
//

import SwiftUI
import SwiftData

struct PlayGameView: View {
    @EnvironmentObject var router: Router
    var inputGameObject: InputGameObject
    var team: TeamModel
    
    @State var game: Game
    @State var duration = "---"
    var timeRemaining: Date
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var playersPlaying: [UUID]
    
    
    init(inputGameObject: InputGameObject, team: TeamModel) {
        self.inputGameObject = inputGameObject
        self.team = team
        var playerUsedBoxStat: [UUID : PlayerStats] = [ : ]
        for player in team.players {
            playerUsedBoxStat[player.id] = PlayerStats()
        }
        let initOppPlayerBoxStats = [PlayerStats()] //need to add multiple players for a team
        self._game = State(initialValue: Game(date: Date(),
                                              isUserHome: inputGameObject.isHome,
                                              userPlayerBoxStats: playerUsedBoxStat,
                                              oppTeamName: inputGameObject.oppName,
                                              oppPlayerBoxStats: initOppPlayerBoxStats,
                                              gameLog: []))
        self.timeRemaining = Calendar.current.date(byAdding: .minute, value: inputGameObject.periodLength, to: Date())!
        self._playersPlaying = State(initialValue: inputGameObject.playersPlaying)
        
    }
    
    let greenPoints = (arr: ["FTM" , "P2M" , "P3M"], color: Color.green)
    let redPoints = (arr: ["FTA" , "P2A" , "P3A"], color: Color.red)
    let drebTovAst = (arr: ["DREB" , "TOV" , "AST"], color: Color.white)
    let orebStlBlk = (arr: ["OREB", "BLK" , "STL"], color: Color.white)
    
    let circleWidthMultipler = 0.2
    let circleFont: Font = .title2
    
    
    var body: some View {
        GeometryReader {geo in
            HStack {
                VStack {
                    StatButtonLabel(label: greenPoints, geo: geo)
                    Button {
                        team.games.append(game)
                        router.gamesRouter.removeAll()
                    } label: {
                        Image(systemName: "text.justify")
                            .font(circleFont)
                            .foregroundStyle(.white)
                            .frame(height: geo.size.height * circleWidthMultipler)
                        
                    }
                }
                
                VStack {
                    StatButtonLabel(label: redPoints, geo: geo)
                    Button {
                        //delete last item
                    } label: {
                        Image(systemName: "arrow.uturn.left")
                            .font(circleFont)
                            .foregroundStyle(.brightOrange)
                            .frame(height: geo.size.height * circleWidthMultipler)
                        
                    }
                }
                
                VStack {
                    HStack {
                        Text(team.name)
                            .padding(.horizontal)
                            .lineLimit(1)
                            .bold()
                        Spacer()
                        Text(game.totalUserPoints(team: team).description)
                            .padding(.horizontal)
                            .font(.title)
                    }
                    HStack {
                        Text(inputGameObject.oppName)
                            .padding(.horizontal)
                            .lineLimit(1)
                            .bold()
                        Spacer()
                        Text(game.totalOppPoints().description)
                            .padding(.horizontal)
                            .font(.title)
                    }
                    
                    VStack {
                        ForEach(game.gameLog) {log in
                            Text(log.action)
                        }
                        
                        
                    }
                    
                    
                    
                    HStack {
                        Text("Q1")
                            .underline(color: .blue)
                            .padding()
                        
                        Rectangle()
                            .stroke(.brightOrange)
                            .foregroundStyle(.clear)
                            .frame(width: geo.size.width * 0.125, height: geo.size.height * 0.1)
                            .overlay {
                                Text(duration)
                                    .onReceive(timer, perform: { _ in
                                        var delta = timeRemaining.timeIntervalSince(Date())
                                        if delta <= 0 {
                                            delta = 0
                                            game.userEndOfQuarterScore[0] = game.totalUserPoints(team: team)
                                            game.oppEndOfQuarterScore[0] = game.totalOppPoints()
//                                            game.endOfQuarterScore[0][0] = game.totalUserPoints(team: team)
                                            timer.upstream.connect().cancel()
                                        }
                                        duration = durationFormatter.string(from: delta) ?? "---"
                                    })
                            }

                    }
                        
                }
                .frame(width: geo.size.width * 0.475, height: geo.size.height)
                .background(.ultraThinMaterial)
                .padding(.horizontal)
                
                VStack {
                    StatButtonLabel(label: drebTovAst, geo: geo)
                    Button {
                        //sub
                    } label: {
                        Capsule()
                            .stroke(.blue)
                            .foregroundStyle(.clear)
                            .frame(width: geo.size.height * circleWidthMultipler, height: geo.size.height * circleWidthMultipler / 1.75)
                            .overlay {
                                Text("SUB")
                                    .bold()
                                    
                            }
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(height: geo.size.height * circleWidthMultipler)
                }
                
                VStack {
                    StatButtonLabel(label: orebStlBlk, geo: geo)
                    Button {
                        router.gamesRouter.append(.logstat($game, "PF", playersPlaying))
                    } label: {
                        Capsule()
                            .stroke(.red)
                            .foregroundStyle(.clear)
                            .frame(width: geo.size.height * circleWidthMultipler, height: geo.size.height * circleWidthMultipler / 1.75)
                            .overlay {
                                Text("FOUL")
                                    .bold()
                                    
                            }
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                    .frame(height: geo.size.height * circleWidthMultipler)
                }
                
                
            }
        }
        .persistentSystemOverlays(.hidden)
        .navigationBarBackButtonHidden()
        .preferredColorScheme(.dark)
    }
    
    func StatButtonLabel (label: (arr: [String], color: Color),geo: GeometryProxy) -> some View {
        VStack {
            ForEach (label.arr.indices, id: \.self) {index in
                Button {
                    router.gamesRouter.append(.logstat($game, label.arr[index], playersPlaying))
                } label: {
                    Circle()
                        .stroke(label.color)
                        .frame(width: geo.size.height * circleWidthMultipler)
                        .overlay {
                            Text(label.arr[index])
                                .font(circleFont)
                                .foregroundStyle(.white)
                                .bold()
                        }
                        .padding(5)
                }
            }
        }
    }
    
    var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .dropLeading
        return formatter
    }()
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TeamModel.self, configurations: config)
    
    let team = TeamModel(name: "Catalina Foothills High School", players: [])
    return PlayGameView(inputGameObject: InputGameObject(oppName: "Salpointe Catholic", isHome: true, periodSections: 2, periodLength: 20, playersPlaying: []), team: team)
        .environmentObject(Router())
}
