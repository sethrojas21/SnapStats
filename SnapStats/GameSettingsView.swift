//
//  GameSettingsView.swift
//  SnapStats
//
//  Created by Seth Rojas on 7/10/24.
//

import SwiftUI
import SwiftData

struct GameSettingsView: View {
    @EnvironmentObject var router: Router
    
    @State var opponentName: String = ""
    @State var homeOrAway: String = "Home"
    @State var periodSections = "Halves"
    @State var periodLength = ""
    var team: TeamModel
    let sideArr = ["Home", "Away"]
    let periodSectionsArr = ["Quarters", "Halves", "Full"]
    
    var body: some View {
        GeometryReader {geo in
            VStack {
//                ZStack {
//                    Color.brightOrange
//                    VStack{
//                        Spacer()
//                        Spacer()
//                        Text("Game Settings")
//                            .font(.largeTitle)
//                            .bold()
//                            .background(.brightOrange)
//                        Spacer()
//                        
//                    }
//                }
//                .ignoresSafeArea()
//                .frame(height: geo.size.height * 0.1)
                
                TextField("Opponent Name", text: $opponentName)
                    .textFieldStyle(OrangeGradientTextFieldStyle(roundedCornes: 25.0, startColor: .brightOrange, endColor: .gray, textColor: .white))
//                    .modifier(customViewModifier(roundedCornes: 25.0, startColor: .blue, endColor: .brightOrange, textColor: .black))
                    .padding()
                    .padding(.top, geo.size.height * 0.05)
                    .multilineTextAlignment(.center)
                
                Divider()
                Picker("Home Or Away", selection: $homeOrAway) {
                    ForEach(sideArr, id: \.self){ side in
                        Text(side)
                    }
                }
                .padding()
                .pickerStyle(SegmentedPickerStyle())
                
                Divider()
                
                HStack{
                    Picker("", selection: $periodSections) {
                        ForEach(periodSectionsArr, id: \.self) {section in
                            Text(section)
                        }
                    }
                    .pickerStyle(InlinePickerStyle())
                    .padding(.horizontal)
                    
                    TextField("Time (min)", text: $periodLength)
                        .textFieldStyle(OutlinedTextFieldStyle())
                        .frame(width: geo.size.width * 0.4)
                        .padding(.horizontal)
                        .keyboardType(.numberPad)
                        .defersSystemGestures(on: .vertical)
                    
                }
                
                Divider()
                
                Spacer()
                
                Button {
                    let isHome: Bool = homeOrAway == "Home"
                    var ps: Int = 1
                    if periodSections == periodSectionsArr[0] {
                        ps = 4
                    } else if periodSections == periodSectionsArr[1] {
                        ps = 2
                    }
                    
                    let inputGameObject = InputGameObject(oppName: opponentName, isHome: isHome, periodSections: ps, periodLength: Int(periodLength) ?? 0, playersPlaying: [])
                    
                    router.gamesRouter.append(.starters(inputGameObject))
                
                } label: {
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundStyle(.blue)
                        .frame(width: geo.size.height * 0.2, height: geo.size.height * 0.1)
                        .overlay {
                            Text("Continue")
                                .foregroundStyle(.brightOrange)
                                .bold()
                                
                        }
                }

                Spacer()
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            router.gamesRouter.removeAll()
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            
        }
        .ignoresSafeArea(.keyboard)
        .tint(.blue)
        .toolbarBackground(Color.brightOrange, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationTitle("Game Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .preferredColorScheme(.dark)
        .onAppear {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        }
        .previewInterfaceOrientation(.portrait)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TeamModel.self, configurations: config)
    
    let team = TeamModel(name: "Golden State Warriors", players: [])
    return GameSettingsView(team: team)
        .modelContainer(container)
        .environmentObject(Router())
        
}
