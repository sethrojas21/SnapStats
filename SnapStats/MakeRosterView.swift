//
//  MakeRosterView.swift
//  SnapStats
//
//  Created by Seth Rojas on 7/6/24.
//

import SwiftUI

struct MakeRosterView: View {
    @EnvironmentObject var userSaved: UserSaved
    var teamName: String
    var teamImageData: Data?
    var averageTeamColor: Color = .black
    
    @State var isAddPlayerViewShowing = false
    
    init(teamName: String, teamImageData: Data? = nil) {
        self.teamName = teamName
        self.teamImageData = teamImageData
//        if let data = teamImageData, let uiImage = UIImage(data: data){
//            averageTeamColor = .averageColor(uiImage: uiImage)
//        }
    }
    
    var body: some View {
        GeometryReader{ geo in
            ScrollView {
                VStack {
                    HStack{
                        RoundedRectangle(cornerRadius: 25.0)
                            .frame(width: geo.size.width * 0.4, height: geo.size.height * 0.15)
                            .foregroundStyle(.brightOrange)
                            .overlay{
                                VStack{
                                    Text("Num of Players:")
                                        .font(.headline)
                                    Text("\(userSaved.roster.count)")
                                        .font(.largeTitle)
                                        .bold()
                                        .foregroundStyle(.blue)
                                        .background{
                                            Circle()
                                                .stroke()
                                                .frame(width: geo.size.width * 0.1)
                                        }
                                        .offset(CGSize(width: 0, height: 10))

                                    
                                }
                            }
                            .padding()
                        
                        Button {
                            userSaved.navigate(to: .seefinalteaminfo(teamName: teamName, teamImageData: teamImageData, roster: userSaved.roster))
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
                    
                    Button {
                        isAddPlayerViewShowing.toggle()
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 25.0)
                            .frame(height: geo.size.height * 0.05)
                            .foregroundStyle(.ultraThinMaterial)
                            .overlay{
                                Image(systemName: "plus")
                                
                            }
                            .padding(.horizontal, geo.size.width * 0.06)
                        
                    }
                    .padding(.bottom)
                    
                    Menu {
                        
                        ForEach(userSaved.roster){ player in
                            Button(player.name, role: .destructive) {
                                userSaved.roster.removeAll { deletePlayer in
                                    player == deletePlayer
                                }
                            }
                            
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 25.0)
                            .frame(height: geo.size.height * 0.05)
                            .foregroundStyle(.ultraThinMaterial)
                            .overlay{
                                Image(systemName: "trash")
                                    .foregroundStyle(.brightOrange)
                                
                            }
                            .padding(.horizontal, geo.size.width * 0.06)
                    }
                    
                    ForEach(userSaved.roster.reversed()) { player in
                        RoundedRectangle(cornerRadius: 25.0)
                            .frame(height: geo.size.height * 0.4)
                            .foregroundStyle(.ultraThinMaterial)
                            .overlay{
                                VStack{
                                    HStack{
                                        if let data = player.image, let uiImage = UIImage(data: data){
                                            Image(uiImage: uiImage)
                                                .profileImage(size: geo.size.height * 0.125/*, color: .averageColor(uiImage: uiImage)*/)
                                        } else{
                                            Image("UnknownPersonHeadshot")
                                                .profileImage(size: geo.size.height * 0.125)
                                        }
                                        
                                        VStack (alignment: .leading){
                                            HStack{
                                                Text(player.name)
                                                    .underline()
                                                    .bold()
                                                Spacer()
                                            }
                                            
                                            HStack{
                                                Text(player.numberFormatted)
                                                    .foregroundStyle(.white)
                                                Spacer()
                                            }
                                        }
                                        .padding()
                                        .frame(width: geo.size.width * 0.35, height: geo.size.height * 0.12)
                                        .background(.brightOrange)
                                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                    }
                                    .padding()
                                    .background{
                                        RoundedRectangle(cornerRadius: 25.0)
                                            .stroke(.white)
                                            .foregroundStyle(.clear)
                                        
                                    }
                                    HStack{
                                        
                                        Circle()
                                            .frame(width: geo.size.height * 0.08)
                                            .overlay{
                                                Text(player.heightDoubleToMeasurement, format: player.measurementFormatted)
                                                    .foregroundStyle(.brightOrange)
                                                    .lineLimit(1)
                                                
                                            }
                                            .padding()
                                        
                                        
                                        playerVitalItem(string: player.position.rawValue, geo: geo)
                                            .padding()
                                        
                                        playerVitalItem(string: player.weightLbs.description + "lbs", geo: geo)
                                            .padding()
                                    }
                                }
                            }
                            .padding(geo.size.width * 0.06)
                        
                    }
                    .animation(.bouncy(duration: 1), value: userSaved.roster)
                }
            }
        }
        .navigationTitle("Team Roster")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    userSaved.navigateBack()
                } label: {
                    Image(systemName: "arrow.left.circle")
                        .foregroundStyle(.brightOrange)
                }
            }
        }
        .sheet(isPresented: $isAddPlayerViewShowing, content: {
            AddNewPlayerView(roster: $userSaved.roster)
        })
        .preferredColorScheme(.dark)
    }
    
    func playerVitalItem(string: String, geo: GeometryProxy) -> some View {
        Circle()
            .frame(width: geo.size.height * 0.08)
            .overlay{
                Text(string)
                    .foregroundStyle(.brightOrange)
                    .lineLimit(1)
                
            }
    }
}

#Preview {
    MakeRosterView(/*path: .constant(NavigationPath()), */teamName: "Wailing Woods")
        .environmentObject(UserSaved())
}
