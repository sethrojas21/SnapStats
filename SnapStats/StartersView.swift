import SwiftUI
import SwiftData

struct StartersView: View {
    @EnvironmentObject var router: Router
    var team: TeamModel
    @State var gameObject: InputGameObject
    
    @State var roster: [(player: Player, isSelected: Bool)]
    @State var starters = [UUID]()
    
    init(team: TeamModel, gameObject: InputGameObject) {
        self.team = team
        self.gameObject = gameObject
        self._roster = State(initialValue: team.players.map { ($0, false) })
    }
    
    
    var body: some View {
        GeometryReader { geo in

            VStack(alignment: .center) {
                
                LazyHGrid(rows: [GridItem(.flexible()), GridItem(.flexible())]) {
                    //sort by number in the future
                    ForEach(0..<roster.count, id: \.self) { index in
                        Button {
                            if !starters.contains(where: {$0 == roster[index].player.id}) {
                                starters.append(roster[index].player.id)
                            } else {
                                starters.removeAll(where: {$0 == roster[index].player.id})
                            }
                            
                            roster[index].isSelected.toggle()
                        } label: {
                            //make into multi use function
                            RoundedRectangle(cornerRadius: 25.0)
                                .stroke(.brightOrange)
                                .fill(roster[index].isSelected ? .ultraThinMaterial : .ultraThin )
                                .opacity(roster[index].isSelected ? 1.0 : 0.2 )
                                .frame(width: geo.size.width / 5.25)
                                .overlay {
                                    HStack {
                                        VStack {
                                            if let data = roster[index].player.image, let uiImage = UIImage(data: data) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .clipShape(Circle())
                                            } else {
                                                Image("UnknownPersonHeadshot")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .clipShape(Circle())
                                            }
                                            
                                            Text(roster[index].player.name)
                                                .lineLimit(2)
                                                .foregroundStyle(.white)
                                        }
                                        .padding(.leading)
                                        
                                        VStack {
                                            Text(roster[index].player.numberFormatted)
                                                .font(.system(size: 21))
                                                .minimumScaleFactor(0.5)
                                            Text(roster[index].player.position.rawValue)
                                                .font(.headline)
                                                .foregroundStyle(.brightOrange)
                                        }
                                        .padding(.trailing)
                                    }
                                }
                        }
                    }
                }
                .frame(height: geo.size.height * 0.9)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            var _ = router.gamesRouter.removeLast()
                        }

                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
//                        gameObject.starters = starters
                        gameObject.playersPlaying = starters
                        router.gamesRouter.append(.pregame(gameObject))
                    } label: {
                        Text("Done")
                    }
                }
                
                
            }
            .toolbar(.hidden, for: .tabBar)
        }
        .persistentSystemOverlays(.hidden)
        .navigationTitle("Starters")
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
    
    let team = TeamModel(name: "Catalina Foothills", players: [])
    
    for i in 0..<10 {
        team.players.append(Player(name: "Seth Rojas", number: 21, heightInch: 70, weightLbs: 151, position: .PG))
    }
    
    var inputGameObject = InputGameObject(oppName: "", isHome: true, periodSections: 4, periodLength: 10, playersPlaying: [])
    return StartersView(team: team, gameObject: inputGameObject)
        .modelContainer(container)
        .environmentObject(Router())
}
