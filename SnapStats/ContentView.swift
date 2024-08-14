//
//  ContentView.swift
//  SnapStats
//
//  Created by Seth Rojas on 6/20/24.
//

import SwiftUI
import SwiftData

// Main view that contains the team picker
struct ContentView: View {
    @EnvironmentObject var userSaved: UserSaved
    @EnvironmentObject var router: Router
    @Environment(\.modelContext) private var context
    @Query private var teams: [TeamModel]
    
    var body: some View {
        if userSaved.userTeamID == nil {
            SelectAndMakeTeamView(teams: teams)
        } else {
            if let team = teams.first(where: {$0.id == userSaved.userTeamID}) {
                withAnimation {
                    TeamTabView(team: team)
                }
            } else {
                VStack {
                    Text("Error. Failed to log in")
                    Button("Fix it") {
                        userSaved.userTeamID = nil
                    }
                }
            }
        }
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
            .onAppear {
//                deleteAllTeams()
//                for team in teams {
//                    team.games.removeAll()
//                }
            }
            .padding()
        
    }
    
    
    func deleteAllTeams(){
        do{
            try context.delete(model: TeamModel.self)
        } catch{
            print("Failed to delete them")
        }
    }
    
    func addTeam(){
        let team = TeamModel(name: "Fake Team", players: [.init(name: "Seth Rojas", number: 21, heightInch: 70, weightLbs: 150, position: .SG)])
        context.insert(team)
    }

    func deleteTeam(_ index: TeamModel){
        context.delete(index)
    }

}



#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TeamModel.self, configurations: config)
    return ContentView()
        .environmentObject(UserSaved())
        .environmentObject(Router())
        .modelContainer(container)
}
