import SwiftUI
import SwiftData

struct PreGameView: View {
    @EnvironmentObject var router: Router
    var inputGameObject: InputGameObject
    var team: TeamModel
    
    
    var body: some View {
        GeometryReader { geo in

            HStack {
                
                VStack {
                    if let data = team.image, let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .profileImage(size: geo.size.width * 0.2)
                    } else {
                        Image("UnknownPersonHeadshot")
                            .profileImage(size: geo.size.width * 0.2)
                    }
                    Text(team.name)
                        .frame(width: geo.size.width * 0.25)
                        .font(.largeTitle)
                        .foregroundStyle(team.avgColorFromTeamImage)
                        .contrast(3.0)
                        .brightness(0.40)
                        .bold()
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                    
                    Text(team.gameRecordConvertedToString())
                        .foregroundStyle(team.avgColorFromTeamImage)
                        .font(.title3)
                }
                
                Grid (verticalSpacing: geo.size.height / 15) {
                    VStack {
                        HStack {
                            Text(team.name.abbrievateString())
                                .foregroundStyle(team.avgColorFromTeamImage)
                            Text("Starters")
                        }
                        .font(.title)
                        Divider()
                    }
                    
                    // need to fix. just needs a pointer to the starters passed in
                    // should also sort by position
                    
                    ForEach(inputGameObject.playersPlaying, id: \.self) {value in
                        GridRow {
                            HStack {
                                Text(team.players.first(where: {$0.id == value})!.name)
                                    .lineLimit(1)
                                Spacer()
                            }
                            
                            Text(team.players.first(where: {$0.id == value})!.position.rawValue)
                                .foregroundStyle(.brightOrange)
                            Text(team.players.first(where: {$0.id == value})!.numberFormatted)
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .frame(width: geo.size.width * 0.3)
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .padding()
                
                
                VStack {
                    RoundedRectangle(cornerRadius: 25.0)
                        .frame(height: geo.size.height * 0.4)
                        .opacity(0.5)
                        .padding()
                        .overlay {
                            VStack {
                                Text(inputGameObject.isHome ? "Home" : "Away")
                                    .bold()
                                    .underline()
                                
                                Text("\(inputGameObject.periodLength) min " + getQuarterHalveFullPeriod(val: inputGameObject.periodSections) )
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            .font(.title)
                        }
                    
                    Button {
                        router.gamesRouter.append(.playgame(inputGameObject))
                    } label: {
                        RoundedRectangle(cornerRadius: 25.0)
                            .frame(height: geo.size.height * 0.4)
                            .foregroundStyle(.brightOrange)
                            .overlay {
                                HStack {
                                    VStack {
                                        Text("vs")
                                            .padding(.top)
                                        Text(inputGameObject.oppName)
                                            .foregroundStyle(.white)
                                            .font(.title)
                                            .lineLimit(3)
                                            .padding( [.horizontal, .bottom])
                                        
                                            
                                    }

                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .padding(.trailing)
                                        .font(.largeTitle)
                                }
                                .foregroundStyle(.blue)
                            }
                            .padding()
                    }
                    
                }
                
                

            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            var _ = router.gamesRouter.removeLast()
                        }

                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
                
                
            }
            .toolbar(.hidden, for: .tabBar)
        }
        .persistentSystemOverlays(.hidden)
        .navigationTitle("Game Preview")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onAppear {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
        }
        .previewInterfaceOrientation(.landscapeLeft)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TeamModel.self, configurations: config)
    

    let team = TeamModel(name: "Catalina Foothills High School", players: [])
    var starters = [UUID]()
    
    for i in 0..<5 {
        let p1 = Player(name: "Seth Rojas", number: 21, heightInch: 70, weightLbs: 151, position: .PG)
        team.players.append(p1)
        starters.append(p1.id)
    
    }
    
    let gameobject = InputGameObject(oppName: "Salpointe Catholic High School", isHome: true, periodSections: 4, periodLength: 10, playersPlaying: starters)

//    starters.append(Player(name: "Seth Rojas", number: 21, heightInch: 70, weightLbs: 151, position: .PG).id)
//    starters.append(Player(name: "Seth Rojas fsdfsdf", number: 21, heightInch: 70, weightLbs: 151, position: .PG).id)
//    starters.append(Player(name: "Norma Morales Rojas fdsfdsfsfdsfdsffsdfdsf", number: 21, heightInch: 70, weightLbs: 151, position: .PG).id)
//    starters.append(Player(name: "Sethsdfdf Rojas", number: 21, heightInch: 70, weightLbs: 151, position: .PG).id)
//    starters.append(Player(name: "Seth Rofdsfjas", number: 21, heightInch: 70, weightLbs: 151, position: .PG).id)
    
    
    

    return PreGameView(inputGameObject: gameobject, team: team)
        .modelContainer(container)
        .environmentObject(Router())
}
