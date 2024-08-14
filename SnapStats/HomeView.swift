//
//  HomeView.swift
//  SnapStats
//
//  Created by Seth Rojas on 6/26/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject var userSaved: UserSaved
    @EnvironmentObject var router: Router
    
    var team: TeamModel
    @Binding var selectedTab: Tab
    @State var game: Game
    
    let statName = ["PTS", "AST" ,"REB"]
    
    init(team: TeamModel, selection: Binding<Tab>){
        self.team = team //set team
        self._selectedTab = selection
        
        var playerArr = [UUID : PlayerStats]() //make dictionary of player ids and stats
        for player in team.players{
            playerArr[player.id] = PlayerStats()
        }
        
        //Make me state game object
        self.game = Game(date: Date(), isUserHome: true, userPlayerBoxStats: playerArr, oppTeamName: "Lightning", oppPlayerBoxStats: [], gameLog: [])
    }
    
    
    func updateItem(_ team: TeamModel){
        team.name = "Dragons"
        try? context.save()
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader{geo in
                
                VStack{
                    TeamHeaderView(team: team, geo: geo, selectedPhoto: .constant(.none))
                    
                    
                    VStack{
                        Text("Latest Game")
                            .font(.caption)
                            .foregroundStyle(.blue)
                            .padding(.bottom, geo.size.height * -0.025)
                        
                        Button {
                            selectedTab = .games
                        } label: {
                            if let lastGame = team.games.last {
                                SingleGameUII(team, lastGame, geo)
                            } else {
                                RoundedRectangle(cornerRadius: 10.0)
                                    .stroke(.gray)
                                    .frame(height: geo.size.height * 0.2)
                                    .overlay {
                                        Text("No recent games")
                                            .foregroundStyle(.blue)
                                    }
                                    .padding()
                            }
                            
                            
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        VStack (alignment: .leading){
                            Text("Team Leaders")
                                .padding(.horizontal)
                                .font(.title2)
                                .foregroundStyle(.brightOrange)
                            Divider()
                            
                            ScrollView (.horizontal) {
                                HStack {
                                    ForEach(statName, id: \.self) {stat in
                                        showStatLeaderWithImage(statName: stat, stat, team: team)
                                    }
                                }
                            }
                        }

                        
                        Spacer()                        

                    }
                    
                }
                
            }
        }
        .preferredColorScheme(.dark)
    }
    
    
    
    func SingleGameUI(_ geo: GeometryProxy) -> some View{
        RoundedRectangle(cornerRadius: 10.0)
            .stroke(.gray)
            .frame(height: geo.size.height * 0.25)
            .overlay{
                VStack{
//                    HStack{
//                        Text("July 5th, 2022")
//                            .padding([.leading, .bottom])
//                            .font(.system(size: 12))
//                        Spacer()
//                    }
                    HStack{
                        
                        VStack{
                            Image("GSWLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.2, height: geo.size.height * 0.1)
                            
                            Text("GSW")
                        }
                        
                        Text("70")
                            .font(.title)
                            .bold()
                            .padding(.trailing)
                        
                        Text("FINAL")
                            .padding(.bottom, 10)
                            .font(.caption)
                        
                        Text("94")
                            .font(.title)
                            .bold()
                            .padding(.leading)
                        
                        VStack{
                            Image("appIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geo.size.width * 0.2, height: geo.size.height * 0.1)
                            
                            Text("SS")
                        }
                        
                    }
                    
                    Text("July 5th, 2022")
                        .font(.title3)
                        .padding(.top)
                }
            }
            .padding()

    }
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
    return HomeView(team: team, selection: .constant(.home))
        .modelContainer(container)
}
