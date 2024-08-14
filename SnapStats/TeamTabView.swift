//
//  TeamTabView.swift
//  SnapStats
//
//  Created by Seth Rojas on 6/27/24.
//

import SwiftUI
import SwiftData

struct TeamTabView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var userSaved: UserSaved
    @EnvironmentObject private var router: Router
    
    var team: TeamModel
    @State var selectedTab: Tab = .home
    
    var body: some View {
        TabView (selection: $selectedTab){
            HomeView(team: team, selection: $selectedTab)
                .tabItem { Label("Home", systemImage: "basketball") }
                .tag(Tab.home)
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            
            StatisticsView(team: team)
                .tabItem { Label("Stats", systemImage: "chart.bar.fill") }
                .tag(Tab.stats)
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)

            GamesView(team: team)
                .tabItem { Label("Games", systemImage: "list.dash") }
                .tag(Tab.games)
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                
            TeamView(team: team)
                .tabItem { Label("Team", systemImage: "person.3.fill") }
                .tag(Tab.team)
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            
            SettingsView(team: team)
                .tabItem { Label("Settings", systemImage: "gear") }
                .tag(Tab.settings)
                .toolbarBackground(.ultraThinMaterial, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
        }
        .onAppear {
            print(context.sqliteCommand)
            userSaved.userTeamID = team.id
        }
        .tint(.brightOrange)
        .navigationBarBackButtonHidden()

    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TeamModel.self, configurations: config)
    
    let team = fakeTeam()
    
    return TeamTabView(/*path: .constant(NavigationPath()), */team: team, selectedTab: .home)
        .modelContainer(container)
        .environmentObject(UserSaved())
        .environmentObject(Router())
}
