//
//  GameSummaryView.swift
//  SnapStats
//
//  Created by Seth Rojas on 7/16/24.
//

import SwiftUI
import SwiftData

struct GameSummaryView: View {
    var game: Game
    var team: TeamModel
    var playerNamesAndID: [ (name: String , id: UUID)]?
    @State private var selectedTab: GameTabView = .boxscore
    
    var body: some View {
        GeometryReader {geo in
            VStack (alignment: .center) {
                HStack {
                    if let data = team.image, let ui = UIImage(data: data) {
                        Image(uiImage: ui)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: geo.size.width * 0.125)
                            .padding(.leading)
                        
                    } else {
                        Image("UnknownPersonHeadshot")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .frame(width: geo.size.width * 0.125)
                            .padding(.leading)
                    }
                    VStack {
                        Text(game.totalUserPoints(team: team).description)
                            .font(.largeTitle)
                            .bold()
                        Text(team.name.abbrievateString())
                            .lineLimit(1)
                    }
                    .frame(width: 65)
                    
                    
                    Text("FINAL")
                        .padding(.horizontal)
                    
                    VStack {
                        Text(game.totalOppPoints().description)
                            .bold()
                            .font(.largeTitle)
                            .opacity(0.5)
                        Text(game.oppTeamName.abbrievateString())
                    }
                    .frame(width: 65)
                    
                    Image("appIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.125)
                        .padding(.trailing)
                    
                }
                .padding(.leading)
                .frame(width: geo.size.width)
                .padding(.bottom)
                .background(.ultraThinMaterial)
                
                Picker("", selection: $selectedTab) {
                    Text("Summary")
                        .tag(GameTabView.summary)
                    Text("Box Score")
                        .tag(GameTabView.boxscore)
                    Text("Play-by-Play")
                        .tag(GameTabView.playbyplay)
                    Text("Team Stats")
                        .tag(GameTabView.teamstats)

                }
                .pickerStyle(SegmentedPickerStyle())
                
                TabView(selection: $selectedTab) {
                    SummaryTab(team: team, game: game)
                        .tag(GameTabView.summary)
                    BoxTab(team: team, game: game)
                        .tag(GameTabView.boxscore)
                    Text("Play-by-Play")
                        .tag(GameTabView.playbyplay)
                    Text("Team Stats")
                        .tag(GameTabView.teamstats)
                }
            }

        }
        .navigationTitle("Game Summary")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                
            } label: {
                Image(systemName: "square.and.arrow.up")
                
            }
        }
        .tint(.brightOrange)
        .preferredColorScheme(.dark)

    }
}

struct SummaryTab: View {
    var team: TeamModel
    var game: Game
    @State var selection: SummaryTabTabs = .Points
    let ptsRebAst: [SummaryTabTabs] = [.Points, .Rebounds, .Assist]
    var body: some View {
        VStack {
            Grid {
                GridRow {
                    Text("")
                    Text("1")
                        .opacity(0.5)
                    Text("2")
                        .opacity(0.5)
                    Text("3")
                        .opacity(0.5)
                    Text("4")
                        .opacity(0.5)
                    Text("T")
                        .bold()
                }
                Divider()
                
                GridRow {
                    HStack {
                        if let data = team.image, let uiImage = UIImage(data: data) {
                            
                        } else {
                            Image("UnknownPersonHeadshot")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .padding(.trailing)
                            Text(team.name.abbrievateString())
                                .bold()
                        }
                    }
                    
                    Text(game.userEndOfQuarterScore[0].description)
                        .opacity(0.5)
                    ForEach(0..<3, id: \.self) {_ in
                        Text(Int.random(in: 0...25).description)
                    }
                    .opacity(0.5)
                    Text(Int.random(in: 0...100).description)
                }
                
                GridRow {
                    HStack {
                        Image("appIcon")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .padding(.trailing)
                        Text(game.oppTeamName.abbrievateString())
                            .bold()
                    }
                    
                    Text(game.oppEndOfQuarterScore[0].description)
                        .opacity(0.5)
                    ForEach(0..<3, id: \.self) {_ in
                        Text(Int.random(in: 0...25).description)
                    }
                    .opacity(0.5)
                    Text(Int.random(in: 0...100).description)
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.ultraThinMaterial)
            }
            
            Grid {
                Text("Game Leaders")
                    .bold()
                Divider()
                
                Picker("", selection: $selection) {
                    ForEach(ptsRebAst, id: \.self) {name in
                        Text(name.rawValue)
                        
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                TabView(selection: $selection) {
                    DisplayStatLeader(mainStat: "PTS")
                        .tag(SummaryTabTabs.Points)
                    DisplayStatLeader(mainStat: "REB")
                        .tag(SummaryTabTabs.Rebounds)
                    DisplayStatLeader(mainStat: "AST")
                        .tag(SummaryTabTabs.Assist)
                }
                .padding(.vertical)
                .toolbar(.hidden, for: .tabBar)
                .tabViewStyle(PageTabViewStyle())

                
                
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(.ultraThinMaterial)
            }
            

            
            
        }
    }
    
    func calculateStatLeader(stat: String) -> (Int, Player) {
        var highest = 0
        var firstPlayer: Player = team.players.first!
        
        for player in team.players {
            let id = player.id
            if stat == "PTS" {
                let curr = getPlayerPointsInGame(game: game, id: id)
                if curr > highest {
                    firstPlayer = player
                    highest = curr
                }
            } else if stat == "AST" {
                if let curr = game.userPlayerBoxStats[id]?.AST {
                    if curr > highest {
                        firstPlayer = player
                        highest = curr
                    }
                }
            } else if stat == "REB" {
                let curr = getPlayerReboundsInGame(game: game, id: id)
                if curr > highest {
                    firstPlayer = player
                    highest = curr
                }
            } else if stat == "STL" {
                if let curr = game.userPlayerBoxStats[id]?.STL {
                    if curr > highest {
                        firstPlayer = player
                        highest = curr
                    }
                }
            } else if stat == "BLK" {
                if let curr = game.userPlayerBoxStats[id]?.BLK {
                    if curr > highest {
                        firstPlayer = player
                        highest = curr
                    }
                }
            }
        }
        return (highest, firstPlayer)
    }
    
    func DisplayStatLeader(mainStat: String) -> some View{
        let calc = calculateStatLeader(stat: mainStat)
        let highestStat = calc.0
        let player = calc.1
        
        return VStack {
            HStack {
                  
                HStack {
                    if let data = player.image, let uiImage = UIImage(data: data) {
                        
                    } else {
                        Image("UnknownPersonHeadshot")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    
                    VStack (alignment: .leading){
                        HStack {
                            Text(player.name.abbreviatedName() + ",")
                            Text(player.position.rawValue + " - " + team.name.abbrievateString())
                                .opacity(0.5)
                        }
                        
                        HStack {
                            VStack (alignment: .center) {
                                Text(highestStat.description)
                                    .statSummaryModifer()
                                Text(mainStat)
                                    .opacity(0.5)
                            }
                            Spacer()
                            VStack (alignment: .center){
                                if mainStat == "PTS" {
                                    Text(getFG(game: game, id: player.id))
                                        .statSummaryModifer()
                                } else if mainStat == "REB" {
                                    Text(game.userPlayerBoxStats[player.id]?.DREB.description ?? "0")
                                        .statSummaryModifer()
                                } else {
                                    Text(game.userPlayerBoxStats[player.id]?.TOV.description ?? "0")
                                        .statSummaryModifer()
                                }
                                if mainStat == "PTS" {
                                    Text("FG")
                                        .opacity(0.5)
                                } else if mainStat == "REB" {
                                    Text("DREB")
                                        .opacity(0.5)
                                } else {
                                    Text("TOV")
                                        .opacity(0.5)
                                }
                            }
                            
                            Spacer()
                            
                            VStack (alignment: .center) {
                                if mainStat == "PTS" {
                                    Text(getFTFG(game: game, id: player.id))
                                        .statSummaryModifer()
                                } else if mainStat == "REB" {
                                    Text(game.userPlayerBoxStats[player.id]?.OREB.description ?? "0")
                                        .statSummaryModifer()
                                } else {
                                    Text("31")
                                        .statSummaryModifer()
                                }
                                if mainStat == "PTS" {
                                    Text("FT")
                                        .opacity(0.5)
                                } else if mainStat == "REB" {
                                    Text("OREB")
                                        .opacity(0.5)
                                } else {
                                    Text("MIN")
                                        .opacity(0.5)
                                }
                            }
                            .padding(.horizontal)
                            
                        }
                    }
                }
                .padding(.leading, 5)
            }
            Divider()
        }

    }
    
    enum SummaryTabTabs: String {
        case Points, Rebounds, Assist
    }
}

extension Text {
    func statSummaryModifer() -> some View {
        self
            .bold()
            .font(.title3)
    }
}

struct BoxTab: View {
    var team: TeamModel
    var game: Game
    var body: some View {
        ScrollView(.horizontal) {
            VStack {
                
                Grid (horizontalSpacing: 15, verticalSpacing: 5){
                    HStack {
                        if let data = team.image, let ui = UIImage(data: data) {
                            Image(uiImage: ui)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 50)
                        } else {
                            Image("UnknownPersonHeadshot")
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                                .frame(width: 50)
                        }
                        Text(team.name)
                            .font(.largeTitle)
                            .padding(.leading, 5)
                            .foregroundStyle(team.avgColorFromTeamImage)
                        Spacer()
                    }
                    .padding(.leading, 5)
                    .padding()
                    
                    .background(.ultraThinMaterial)
                    
                    //Need to add starters and bench
                    GridRow {
                        Text("Players")
                        Text("FG")
                        Text("3PT")
                        Text("FT")
                        Text("PTS")
                        Text("AST")
                        Text("OREB")
                        Text("DREB")
                        Text("STL")
                        Text("BLK")
                        Text("TO")
                        Text("PF")
                    }
                    .bold()
                    Divider()
                    
                    ForEach(0..<game.userPlayerBoxStats.count, id: \.self) {index in
                        GridRow {
                            HStack {
                                Text(team.players[index].name)
                                Text(team.players[index].position.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            }
                            Text(getFG(game: game, id: team.players[index].id))
                            Text(get3PTFG(game: game, id: team.players[index].id))
                            Text(getFTFG(game: game, id: team.players[index].id))
                            Text(getPlayerPointsInGame(game: game, id: team.players[index].id).description)
                            Text((game.userPlayerBoxStats[team.players[index].id]?.AST.description)!)
                            Text((game.userPlayerBoxStats[team.players[index].id]?.OREB.description)!)
                            Text((game.userPlayerBoxStats[team.players[index].id]?.DREB.description)!)
                            Text((game.userPlayerBoxStats[team.players[index].id]?.STL.description)!)
                            Text((game.userPlayerBoxStats[team.players[index].id]?.BLK.description)!)
                            Text((game.userPlayerBoxStats[team.players[index].id]?.TOV.description)!)
                            Text(Int.random(in: 0...3).description)
                        }
                    }
                    .padding(.leading)
                    GridRow {
                        Text("TEAM")
                        Text(getTeamFG(game: game, team: team).0)
                        Text(getTeam3PT(game: game, team: team).0)
                        Text(getTeamFTFG(game: game, team: team).0)
                        Text(getTeamsStatSingleGame(game: game, team: team, statName: "PTS").description)
                        Text(getTeamsStatSingleGame(game: game, team: team, statName: "AST").description)
                        Text(getTeamsStatSingleGame(game: game, team: team, statName: "OREB").description)
                        Text(getTeamsStatSingleGame(game: game, team: team, statName: "DREB").description)
                        Text(getTeamsStatSingleGame(game: game, team: team, statName: "STL").description)
                        Text(getTeamsStatSingleGame(game: game, team: team, statName: "BLK").description)
                        Text(getTeamsStatSingleGame(game: game, team: team, statName: "TOV").description)
                        Text(Int.random(in: 0...3).description)
                    }
                    .bold()
                    .foregroundStyle(team.avgColorFromTeamImage)
                    .padding(.leading)
                    
                    GridRow {
                        Text("")
                        Text("\(getTeamFG(game: game, team: team).1 * 100, specifier: "%.1f")%")
                        Text("\(getTeam3PT(game: game, team: team).1 * 100, specifier: "%.1f")%")
                        Text("\(getTeamFTFG(game: game, team: team).1 * 100, specifier: "%.1f")%")
                    }
                    .bold()
                    .foregroundStyle(team.avgColorFromTeamImage)
                    .padding(.leading)
                    
                    HStack {
                        Image("appIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                        Text(game.oppTeamName)
                            .font(.largeTitle)
                        Spacer()
                    }
                    .padding()
                    .padding(.leading, 5)
                    .background(.ultraThinMaterial)
                    
                    statHeader()
                    
                    GridRow {
                        Text("TEAM")
                        Text("\(game.oppPlayerBoxStats[0].P2M + game.oppPlayerBoxStats[0].P3M) - \(game.oppPlayerBoxStats[0].P2A + game.oppPlayerBoxStats[0].P3A)")
                        Text("\(game.oppPlayerBoxStats[0].P3M) - \(game.oppPlayerBoxStats[0].P3A)")
                        Text("\(game.oppPlayerBoxStats[0].FTM) - \(game.oppPlayerBoxStats[0].FTA)")
                        Text("\(game.oppPlayerBoxStats[0].P2M * 2 + game.oppPlayerBoxStats[0].P3M * 3 + game.oppPlayerBoxStats[0].FTM)")
                        Text("\(game.oppPlayerBoxStats[0].AST)")
                        Text("\(game.oppPlayerBoxStats[0].OREB)")
                        Text("\(game.oppPlayerBoxStats[0].DREB)")
                        Text("\(game.oppPlayerBoxStats[0].STL)")
                        Text("\(game.oppPlayerBoxStats[0].BLK)")
                        Text("\(game.oppPlayerBoxStats[0].TOV)")
                    }
                    .bold()
                    .foregroundStyle(.brightOrange)
                    .padding(.leading)
                    
                    GridRow {
                        Text("")
                        Text("\( (Double(game.oppPlayerBoxStats[0].P2M + game.oppPlayerBoxStats[0].P3M) / Double(game.oppPlayerBoxStats[0].P2A + game.oppPlayerBoxStats[0].P3A) * 100), specifier: "%.1f")%")
                        Text("\( Double(game.oppPlayerBoxStats[0].P3M) / Double(game.oppPlayerBoxStats[0].P3A) * 100, specifier: "%.1f")%")
                        Text("\( Double(game.oppPlayerBoxStats[0].FTM) / Double(game.oppPlayerBoxStats[0].FTA) * 100, specifier: "%.1f")%")
                    }
                    .bold()
                    .foregroundStyle(.blue)
                    .padding(.leading)
                    
                    
                }
            }
            
        }
    }
    
    func statHeader() -> some View {
        GridRow {
            Text("Players")
            Text("FG")
            Text("3PT")
            Text("FT")
            Text("PTS")
            Text("AST")
            Text("OREB")
            Text("DREB")
            Text("STL")
            Text("BLK")
            Text("TO")
            Text("PF")
        }
        .bold()
    }
}

enum GameTabView {
    case summary, boxscore, playbyplay, teamstats
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
    return GameSummaryView(game: team.games[0], team: team)
        .modelContainer(container)
}
