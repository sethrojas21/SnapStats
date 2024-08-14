//
//  IndividualPlayerView.swift
//  SnapStats
//
//  Created by Seth Rojas on 7/3/24.
//

import SwiftUI
import SwiftData

struct IndividualPlayerView: View {
    var team: TeamModel
    var player: Player
    
    let statName = ["PTS", "AST" ,"REB" ,"FG%"]
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        //Image
                        if let data = player.image, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .profileImage(size: 200)
                        } else {
                            Image("UnknownPersonHeadshot")
                                .profileImage(size: 150)
                        }
                        
                        Spacer()
                        
                        VStack (alignment: .leading) {
                            Text(player.name.split(separator: " ").first?.description ?? "")
                            Text(player.name.split(separator: " ").last?.description ?? "")
                                .bold()
                            
                            HStack {
                                Text(player.numberFormatted)
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 5))
                                Text(player.position.rawValue)
                            }
                            .font(.headline)
                            
                            HStack {
                                Text(player.heightDoubleToMeasurement, format: player.measurementFormatted)
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 5))
                                Text(player.weightLbs.description + "lb")
                            }
                            .font(.headline)
                        }
                        .padding(.leading)
                        .font(.largeTitle)
                        Spacer()
                    }
                    
                    
                    RoundedRectangle(cornerRadius: 25.0)
                        .stroke()
                        .frame(height: 100)
                        .overlay {
                            VStack {
                                RoundedTopRectangle(cornerRadius: 25.0)
                                    .frame(height: 25)
                                    .overlay {
                                        Text("SEASON STATS")
                                            .foregroundStyle(.blue)
                                            .font(.subheadline)
                                            .bold()
                                    }
                                
                                Spacer()
                                HStack (spacing: 50) {
                                    ForEach(statName, id: \.self) {stat in
                                        VStack {
                                            Text(stat)
                                                .opacity(0.5)
                                                .font(.subheadline)
                                            Text(calculateStatLeader(stat: stat, team: team).0.description)
                                            
                                        }
                                    }
                                }
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    
                    
                    if let game = team.games.last {
                        VStack () {
                            HStack {
                                Text("Previous Game")
                                    .padding()
                                    .font(.title2)
                                Spacer()
                            }
                            
                            
                            scoreGameUI(team, game, geo)
                            
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(BasketballStat.firstThree, id: \.self) {stat in
                                        RoundedRectangle(cornerRadius: 25.0)
                                            .stroke()
                                            .frame(width: geo.size.width * 0.4, height: 100)
                                            .overlay {
                                                VStack {
                                                    RoundedTopRectangle(cornerRadius: 25.0)
                                                        .fill(Color.blue)
                                                        .frame(height: 25)
                                                    
                                                        .overlay {
                                                            Text(stat.rawValue)
                                                                .foregroundStyle(.white)
                                                                .font(.subheadline)
                                                        }
                                                    
                                                    Spacer()
                                                    
                                                    Text(game.getPlayerStatInGame(stat: stat, id: player.id).description)
                                                        .font(.title)
                                                        .bold()
                                                    
                                                    Spacer()
                                                    
                                                }
                                            }
                                        
                                    }
                                }
                            }
                            
                            ScrollView(.horizontal) {
                                Grid (verticalSpacing: 10) {
                                    GridRow {
                                        ForEach(BasketballStat.allCases, id: \.self) {stat in
                                            Text(stat.rawValue)
                                        }
                                    }
                                    GridRow {
                                        ForEach(BasketballStat.allCases, id: \.self) {stat in
                                            Text(game.getPlayerStatInGame(stat: stat, id: player.id).description)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(.ultraThickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        
                    }
                    
                    
                    ScrollView(.horizontal) {
                        Grid (verticalSpacing: 10){
                            HStack {
                                Text("Season Averages")
                                    .font(.title2)
                                Spacer()
                            }
                            
                            GridRow {
                                ForEach(BasketballStat.allCases, id: \.self) {stat in
                                    Text(stat.rawValue)
                                }
                            }
                            
                            GridRow {
                                ForEach(BasketballStat.allCases, id: \.self) {stat in
                                    Text(team.getPlayerAverageInStat(stat: stat.rawValue, id: player.id).description)
                                }
                            }
                        }
                        .padding()
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    
                }
            }
        }
        .navigationTitle(player.name.abbreviatedName())
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }
}

struct RoundedTopRectangle: Shape {
    var cornerRadius: CGFloat = 20.0 // Set the corner radius for the top corners

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Start at the bottom-left corner
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        // Draw to the top-left corner with a rounded corner
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        path.addQuadCurve(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY),
                          control: CGPoint(x: rect.minX, y: rect.minY))
        
        // Draw to the top-right corner with a rounded corner
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius),
                          control: CGPoint(x: rect.maxX, y: rect.minY))
        
        // Draw to the bottom-right corner
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        
        // Close the path by drawing back to the start point
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        return path
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TeamModel.self, configurations: config)
    
    let player: Player = Player(name: "Seth Rojas", number: 21, heightInch: 70, weightLbs: 151, position: .SG)
    let team = TeamModel(name: "Golden State Warriors", players: [player])
    let stats: [UUID : PlayerStats] = [ team.players[0].id : PlayerStats(P2M: 2, P3M: 3)]
    team.games.append(Game(date: Date(), isUserHome: false, userPlayerBoxStats: stats, oppTeamName: "Goofies", oppPlayerBoxStats: [], gameLog: []))
    return IndividualPlayerView(team: team, player: player)
        .modelContainer(container)
}
