//
//  StatisticsView.swift
//  SnapStats
//
//  Created by Seth Rojas on 6/27/24.
//

import SwiftUI
import SwiftData

struct StatisticsView: View {
    @EnvironmentObject var router: Router
    var team: TeamModel
    let statArr = ["PTS", "AST", "REB" , "STL" , "BLK"]
    
    var body: some View {
        NavigationStack(path: $router.statsRouter) {
            GeometryReader{ geo in
                VStack {
                    
                    HStack {
                        Grid (verticalSpacing: 10){
                            Text("Leaders")
                                .font(.headline)
                                .foregroundStyle(.blue)
                            
                            Divider()
                                .overlay(.brightOrange)
                            ForEach(statArr, id: \.self) {stat in
                                statView(stat: stat)
                                Divider()
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        
                        Grid (verticalSpacing: 10){
                            Text("Averages")
                                .font(.headline)
                                .foregroundStyle(.blue)
                            
                            Divider()
                                .overlay(.brightOrange)
                            ForEach(statArr, id: \.self) {stat in
                                GridRow {
                                    HStack {
                                        Text(stat)
                                            .bold()
                                    }
                                    Text(team.getTeamAverageInStat(stat: stat).description)
                                }
                                Divider()
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    }
                    .padding(.top)
                    HStack {
                        VStack {
                            Button {
                                router.statsRouter.append(.teamstats(team.name))
                            } label: {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundStyle(.white)
                                    .overlay{
                                        HStack{
                                            VStack{
                                                Text("Team\nStats")
                                                    .font(.title2)
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(.blue)
                                                    .multilineTextAlignment(.leading)
                                            }
                                            .padding()
                                            .padding(.trailing, geo.size.width * 0.09)
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.black)
                                            Spacer()
                                            Spacer()
                                        }
                                    }
                                    .padding()
                            }
                            
                            Button {
                                router.statsRouter.append(.advancedStat)
                            } label: {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundStyle(.blue)
                                    .overlay{
                                        HStack{
                                            VStack{
                                                Text("Advanced\nStats")
                                                    .font(.title2)
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(.white)
                                                    .multilineTextAlignment(.leading)
                                                    .padding(.leading)
                                            }
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.orange)
                                            Spacer()
                                            Spacer()
                                        }
                                    }
                                    .padding()
                            }
                        }
                        
                        VStack {
                            Button {
                                router.statsRouter.append(.chartsAndVisuals)
                            } label: {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundStyle(.white)
                                    .opacity(0.25)
                                    .overlay{
                                        HStack{
                                            VStack{
                                                Text("Statistical\nCharts")
                                                    .font(.title2)
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(.white)
                                                    .multilineTextAlignment(.leading)
                                                    .padding(.leading)
                                            }
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.orange)
                                            Spacer()
                                            Spacer()
                                        }
                                    }
                                    .padding()
                            }
                            
                            Button {
                                router.statsRouter.append(.advancedStat)
                            } label: {
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundStyle(.brightOrange)
                                    .overlay{
                                        HStack{
                                            VStack{
                                                Text("Snap\nBot")
                                                    .font(.title2)
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(.white)
                                                    .multilineTextAlignment(.leading)
                                                    .padding(.leading)
                                            }
                                            .padding()
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundStyle(.blue)
                                            Spacer()
                                        }
                                    }
                                    .padding()
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: Router.StatsRoute.self, destination: { destination in
                switch destination {
                case .teamstats(let string):
                    TeamStatsView(team: team)
                case .advancedStat:
                    AdvancedStatsView()
                case .chartsAndVisuals:
                    Text("Charts and Visuals")
                }
            })
            .toolbarBackground(.blue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationTitle("Snap Stats")
        }
        .preferredColorScheme(.dark)

    }
    

    
    func statView(stat: String) -> some View {
        let calc = calculateStatLeader(stat: stat, team: team)
        return GridRow{
            HStack{
                Text(calc.1.name.abbreviatedName())
                    .lineLimit(1)
                Spacer()
            }
            HStack {
                Text(calc.0.description)
                    .underline()
                Text(stat)
                    .bold()
            }
        }
    }
    
}



#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TeamModel.self, configurations: config)
    
    let team = TeamModel(name: "Golden State Warriors", players: [Player(name: "Seth Rojas", number: 21, heightInch: 21, weightLbs: 21, position: .PG)])
    let stats: [UUID : PlayerStats] = [ team.players[0].id : PlayerStats(P2M: 2, P3M: 3)]
    team.games.append(Game(date: Date(), isUserHome: false, userPlayerBoxStats: stats, oppTeamName: "Goofies", oppPlayerBoxStats: [], gameLog: []))
    return StatisticsView(team: team)
        .modelContainer(container)
        .environmentObject(Router())
}
