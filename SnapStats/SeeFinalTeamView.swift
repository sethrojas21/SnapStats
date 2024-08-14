//
//  SeeFinalTeamView.swift
//  SnapStats
//
//  Created by Seth Rojas on 7/8/24.
//

import SwiftUI

struct SeeFinalTeamView: View {
    @Environment(\.modelContext) var context
    @EnvironmentObject var userSaved: UserSaved
    var teamName: String
    var teamImageData: Data?
    var roster: [Player]
    var body: some View {
        GeometryReader {geo in
            VStack {
                HStack{
                    if let data = teamImageData, let image = UIImage(data: data){
                        Image(uiImage: image)
                            .profileImage(size: geo.size.width * 0.3, strokeWidth: 0.0)
                            .padding([.top, .horizontal])
                    } else{
                        Image("UnknownPersonHeadshot")
                            .profileImage(size: geo.size.width * 0.3)
                            .padding([.top, .horizontal])
                    }
                    
                    Spacer()
                    
                    VStack{
                        if let data = teamImageData, let uiImage = UIImage(data: data){
                            Text(teamName)
                                .font(.system(size: 40))
                                .minimumScaleFactor(0.5)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .bold()
//                                .foregroundStyle(.averageColor(uiImage: uiImage))
                                .contrast(3.0)
                                .brightness(0.40)
                        } else{
                            Text(teamName)
                                .font(.system(size: 40))
                                .minimumScaleFactor(0.5)
                                .lineLimit(2)
                            //                        .brightness(2.0)
                                .multilineTextAlignment(.center)
                                .bold()
                        }
                    }
                    .padding(.trailing)
                    
                    Spacer()
                    Spacer()
                }
                .padding(.top)
                Divider()
                
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem(.fixed(20))]) {
                        ForEach(userSaved.roster) {player in
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke()
                                .frame(width: geo.size.width * 0.3, height: geo.size.height * 0.25)
                                .overlay{
                                    VStack{
                                        if let data = player.image, let image = UIImage(data: data){
                                            Image(uiImage: image)
                                                .profileImage(size: geo.size.width * 0.15, strokeWidth: 0.0)
                                                .padding([.top, .horizontal])
                                        } else{
                                            Image("UnknownPersonHeadshot")
                                                .profileImage(size: geo.size.width * 0.15)
                                                .padding([.top, .horizontal])
                                        }
                                        
                                        Text(player.name)
                                        Text(player.numberFormatted)
                                            .foregroundStyle(.gray)
                                    }
                                }
                        }
                        .padding()
                        
                    }
                }
                .frame(height: geo.size.height * 0.3)
                .padding(.bottom)
                
                HStack{
                    VStack{
                        Text("Breakdown")
                            .multilineTextAlignment(.center)
                            .font(.headline)
                            .foregroundStyle(.blue)
                        
                        Divider()
                            .overlay(.brightOrange)
                        Grid (verticalSpacing: 7.5){
                            GridRow {
                                Text("PG")
                                Text(String(getPositionCountInRoster(team: userSaved.roster, position: .PG)))
                            }
                            Divider()
                            GridRow {
                                Text("SG")
                                Text(String(getPositionCountInRoster(team: userSaved.roster, position: .SG)))
                            }
                            Divider()
                            GridRow {
                                Text("SF")
                                Text(String(getPositionCountInRoster(team: userSaved.roster, position: .SF)))
                            }
                            Divider()
                            GridRow {
                                Text("PF")
                                Text(String(getPositionCountInRoster(team: userSaved.roster, position: .PF)))
                            }
                            Divider()
                            GridRow {
                                Text("C")
                                Text(String(getPositionCountInRoster(team: userSaved.roster, position: .C)))
                            }
                        }
                    }
                    .padding()
                    .frame(width: geo.size.width * 0.4)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    
                    VStack{
                        
                        RoundedRectangle(cornerRadius: 25.0)
                            .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.15)
                            .foregroundStyle(.brightOrange)
                            .overlay{
                                VStack{
                                    Text("\(userSaved.roster.count)")
                                        .font(.system(size: 60))
                                        .bold()
                                    Text("Players")
                                        .font(.title)
                                }
                                
                            }
                        
                        Button {
                            withAnimation {
                                let team = TeamModel(name: teamName, image: teamImageData, players: roster)
                                context.insert(team)
                                userSaved.roster = [Player]()
                                userSaved.navigateToRoot()
                                userSaved.userTeamID = team.id
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 25.0)
                                .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.15)
                                .padding()
                                .overlay{
                                    VStack{
                                        Text("Finish")
                                            .foregroundStyle(.white)
                                            .font(.largeTitle)
                                            .bold()
                                        Image(systemName: "arrow.right")
                                            .foregroundStyle(.brightOrange)
                                            .font(.largeTitle)
                                    }
                                        
                                }
                        }
                        
                    }
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        userSaved.navigateBack()
                    } label: {
                        Image(systemName: "arrow.left.cirlce")
                            .tint(.brightOrange)
                    }
                }
            }
        }
        .navigationTitle("Final Team")
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        
    }
}

#Preview {
    SeeFinalTeamView(teamName: "Golden State Warriors", roster: [Player(name: "Seth Rojas", number: 21, heightInch: 70, weightLbs: 150, position: .SG), Player(name: "Seth Rojas", number: 21, heightInch: 70, weightLbs: 150, position: .SG), Player(name: "Seth Rojas", number: 21, heightInch: 70, weightLbs: 150, position: .SG)])
        .environmentObject(UserSaved())
}
