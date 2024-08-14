//
//  SelectAndMakeTeamView.swift
//  SnapStats
//
//  Created by Seth Rojas on 7/12/24.
//

import SwiftUI
import SwiftData

struct SelectAndMakeTeamView: View {
    @EnvironmentObject var userSaved: UserSaved
    @Environment(\.modelContext) private var context
    var teams: [TeamModel]
    var body: some View {
        NavigationStack(path: $userSaved.path){
            //Team Picker View
            ScrollView{
                VStack{
                    ForEach(teams){team in
                        Button {
                            withAnimation {
                                userSaved.userTeamID = team.id
                            }
                        } label: {
                            teamPickerView(teamName: team.name, imageData: team.image)
                        }
                    }
                }
            }
            .navigationTitle("Snap Stats")
            .toolbar{
                Button {
                    userSaved.roster = []
                    userSaved.navigate(to: .createteaminfo)
                } label: {
                    Image(systemName: "plus.circle")
                        .tint(.brightOrange)
                }
            }
            .navigationDestination(for: UserSaved.MakeTeamRoute.self) { destination in
                switch destination {
                case .createteaminfo:
                    AddTeamView()
                case .createrosterinfo(let teamName, let teamImageData):
                    MakeRosterView(teamName: teamName, teamImageData: teamImageData)
                case .seefinalteaminfo(let name, let data, let roster):
                    SeeFinalTeamView(teamName: name, teamImageData: data, roster: roster)
                }
            }
        }
        .onAppear {
            userSaved.userTeamID = nil
            userSaved.roster = [Player]()
        }
        .navigationBarBackButtonHidden()
        .preferredColorScheme(.dark)
    }
    
    func teamPickerView(teamName: String, imageData: Data?) -> some View {
        RoundedRectangle(cornerRadius: 10.0)
            .stroke(.gray)
            .background{
                if let data = imageData, let uiImage = UIImage(data: data) {
                    if let uiColor = uiImage.averageColor {
                        Color(uiColor: uiColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    }
                }
            }
            .frame(height: 150)
            .overlay{
                HStack{
                    if let data = imageData, let uiImage = UIImage(data: data){
                        Image(uiImage: uiImage)
                            .profileImage(size: 100, strokeWidth: 2.0)
                    } else{
                        Image("UnknownPersonHeadshot")
                            .profileImage(size: 100, strokeWidth: 2.0)
                    }
                    Spacer()
                    VStack(alignment: .leading){
                        Text(teamName)
                            .font(.largeTitle)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.white)
                            .padding()
                    }
                    Spacer()
                    Spacer()
                }
            }
            .padding()
        
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TeamModel.self, configurations: config)
    return SelectAndMakeTeamView(teams: [TeamModel(name: "Fake Team", players: [.init(name: "Seth Rojas", number: 21, heightInch: 70, weightLbs: 150, position: .SG)])])
        .environmentObject(UserSaved())
        .modelContainer(container)
}
