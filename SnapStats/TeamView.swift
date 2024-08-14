//
//  TeamView.swift
//  SnapStats
//
//  Created by Seth Rojas on 6/27/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct TeamView: View {
    @EnvironmentObject var userSaved: UserSaved
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) var context
    var team: TeamModel
    
    @State var isAddPlayerShowing = false
    @State var photosPickerItem: PhotosPickerItem?
    
    @State var roster: [Player]
    
    @State var path = NavigationPath()
    
    init(team: TeamModel, isAddPlayerShowing: Bool = false, photosPickerItem: PhotosPickerItem? = nil) {
        self.team = team
        self.isAddPlayerShowing = isAddPlayerShowing
        self.photosPickerItem = photosPickerItem
        self.roster = self.team.players
    }
    
    var body: some View {
        NavigationStack (path: $router.teamRouter) {
            GeometryReader{ geo in
                ScrollView(.vertical){
                    VStack{
                        HStack{
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        TeamHeaderView(team: team, geo: geo, isPhotosPickers: true, selectedPhoto: $photosPickerItem)
                        
                        HeaderView(title: "Players", sheetPresented: $isAddPlayerShowing)
                        LazyVGrid(columns: [GridItem(.flexible(minimum: 0, maximum: 0))]){
                            ForEach(team.players){ player in
                                Button {
                                    router.teamRouter.append(.playerdetail(player, team))
                                } label: {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.1)
                                        .foregroundStyle(.ultraThinMaterial)
                                        .overlay{
                                            HStack{
                                                if let data = player.image, let uiImage = UIImage(data: data){
                                                    Image(uiImage: uiImage)
                                                        .profileImage(size: geo.size.height * 0.125, strokeWidth: 1.0)
                                                } else{
                                                    Image("UnknownPersonHeadshot")
                                                        .profileImage(size: geo.size.height * 0.125, strokeWidth: 1.0)
                                                }
                                                
                                                VStack (alignment: .leading){
                                                    Text(player.name)
                                                        .underline()
                                                        .foregroundStyle(adjustColorIfTooDark(team.avgColorFromTeamImage))
                                                        .contrast(3.0)
                                                        .brightness(0.40)
                                                        .bold()
                                                    
                                                    Text(player.numberFormatted)
                                                        .foregroundStyle(.white)
                                                }
                                                Spacer()
                                                
                                                Image(systemName: "chevron.right")
                                                    .padding()
                                                    .foregroundStyle(.brightOrange)
                                            }
                                        }
                                        .padding()
                                }
                                
                            }
                            
                        }
                    }
                    
                }

            }
            .navigationDestination(for: Router.TeamRoute.self, destination: { destination in
                switch destination {
                case .playerdetail(let player, let team):
                    IndividualPlayerView(team: team, player: player)
                }
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        withAnimation {
                            userSaved.userTeamID = nil
                        }

                    } label: {
                        Text("Logout")
                            .foregroundStyle(.brightOrange)
                    }
                }
            }
            .navigationTitle("Roster")
            .navigationBarTitleDisplayMode(.inline)
            .animation(.default, value: team.image)
            .animation(.bouncy, value: team.players)
            .task(id: photosPickerItem){
                if let data = try? await photosPickerItem?.loadTransferable(type: Data.self){
                    team.image = data
                    try? context.save()
                }
            }
            .sheet(isPresented: $isAddPlayerShowing, content: {
                AddNewPlayerView(roster: $roster)
            })
            .onChange(of: roster) {
                team.players = roster
                try? context.save()
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TeamModel.self, configurations: config)
    
    let team = TeamModel(name: "Golden State Warriors", players: [Player(name: "Seth Rojas", number: 21, heightInch: 70, weightLbs: 151, position: .SG)])
    return TeamView(team: team)
        .modelContainer(container)
        .environmentObject(UserSaved())
        .environmentObject(Router())
}
