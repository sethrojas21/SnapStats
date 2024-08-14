//
//  Data.swift
//  SnapStats
//
//  Created by Seth Rojas on 6/25/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class TeamModel: Codable {
    @Attribute(.unique)
    var id = UUID()
    var name: String
    @Attribute(.externalStorage)
    var image: Data?
    @Attribute(.externalStorage)
    var players: [Player]
    var games = [Game]()
    
    init(name: String, image: Data? = nil, players: [Player]) {
        self.name = name
        self.image = image
        self.players = players
    }
    
    // Codable conformance
    enum CodingKeys: String, CodingKey {
        case id, name, image, players, games
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        image = try container.decodeIfPresent(Data.self, forKey: .image)
        players = try container.decode([Player].self, forKey: .players)
        games = try container.decode([Game].self, forKey: .games)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encode(players, forKey: .players)
        try container.encode(games, forKey: .games)
    }
}

extension TeamModel {
    var avgColorFromTeamImage: Color {
        return Color.white
//        if let data = image, let uiImage = UIImage(data: data){
//            return Color(uiColor: uiImage.averageColor!)
//        } else{
//            return Color.white
//        }
    }
}


struct Game: Identifiable, Codable, Hashable {
    
    var id = UUID() //Game ID
    
    var date: Date
    
    var isUserHome: Bool
    var userPlayerBoxStats: [UUID : PlayerStats]
    
    var oppTeamName: String
    var oppPlayerBoxStats: [PlayerStats] = [PlayerStats()]
    
    var gameLog: [GameLog]
    
    var userEndOfQuarterScore: [Int] = [0,0,0,0]
    var oppEndOfQuarterScore: [Int] = [0,0,0,0]
    
}

struct Player: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var name: String
    
    var image: Data?
    
    var number: Int
    
    var heightInch: Double
    
    var weightLbs: Int
    
    var position: Position
    
    var heightDoubleToMeasurement: Measurement<UnitLength>{
        return Measurement(value: heightInch, unit: UnitLength.inches)
    }
    
    var measurementFormatted: Measurement<UnitLength>.FormatStyle {
        return Measurement<UnitLength>.FormatStyle (width: .abbreviated, numberFormatStyle: .number)
    }
    
    var numberFormatted: String {
        return "#\(number)"
    }
}

struct PlayerStats: Codable, Hashable {
    var FTA: Int = 0
    var FTM: Int = 0
    var P2M: Int = 0
    var P2A: Int = 0
    var P3M: Int = 0
    var P3A: Int = 0
    var AST: Int = 0
    var DREB: Int = 0
    var OREB: Int = 0
    var STL: Int = 0
    var BLK: Int = 0
    var TOV: Int = 0
    var PF: Int = 0
}

struct GameLog: Hashable, Codable, Identifiable {
    var id = UUID()
    var time: String
    var action: String
    
}

enum Position: String, Codable, Hashable{
    case PG, SG, SF, PF, C
}

enum Tab: String, Codable{
    case home, team, stats, games, settings
}

class UserSaved: ObservableObject{
    //Variables
    @Published var tab: Tab? {
        didSet {
            saveLastTab()
        }
    }
    @Published var userTeamID: UUID?{
        didSet{
            print("UserTeamID changed to \(String(describing: userTeamID))")
            saveUserID()
        }
    }
    @Published var path = NavigationPath(){
        didSet{
            saveLastNav()
        }
    }
    private let savePath = URL.documentsDirectory.appending(path: "SavePathStore")
    @Published var roster = [Player]() {
        didSet{
            saveRoster()
        }
    }
    
    //Decode values
    init() {
        //Decode roster
        decodeRoster()
        
        //Decode last saved tab
        decodeLastTab()
        
        //Decoded last saved Team Name (doing this to access them or see if they are logged out)
        decodeLastUserID()
        
        //Accessing saved NavPath
        decodeLastNavPath()
        
    }
    
    private func decodeLastTab(){
        if let savedTab = UserDefaults.standard.data(forKey: "SavedTab"){
            if let decodedItems = try? JSONDecoder().decode(Tab.self, from: savedTab){
                tab = decodedItems
                return
            }
        }
        tab = nil
    }
    
    private func decodeLastUserID(){
        if let savedUserTeamID = UserDefaults.standard.data(forKey: "SavedUserTeamID"){
            if let decodedItems = try? JSONDecoder().decode(UUID.self, from: savedUserTeamID){
                userTeamID = decodedItems
                return
            }
        }
        userTeamID = nil
    }
    
    private func decodeLastNavPath(){
        if let data = try? Data(contentsOf: savePath){
            if let decoded = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data){
                path = NavigationPath(decoded)
                return
            }
        }
        path = NavigationPath()
    }
    
    
    private func decodeRoster(){
        if let savedRoster = UserDefaults.standard.data(forKey: "SavedRoster"){
            if let decodedItems = try? JSONDecoder().decode([Player].self, from: savedRoster){
                self.roster = decodedItems
                return
            }
        }
        roster = [Player]()
    }
    
    //Save values
    
    private func saveLastNav() {
        //Nav path saved
        guard let representation = path.codable else{return}
        
        do {
            let data = try JSONEncoder().encode(representation)
            try data.write(to: savePath)
        } catch{
            print("Failed to save navigation data")
        }
    }
    
    private func saveUserID(){
        //Saved UUID
        if let encoded = try? JSONEncoder().encode(userTeamID){
            UserDefaults.standard.setValue(encoded, forKey: "SavedUserTeamID")
        }
    }
    
    private func saveLastTab(){
        //Saved last saved tab
        if let encoded = try? JSONEncoder().encode(tab){
            UserDefaults.standard.setValue(encoded, forKey: "SavedTab")
        }
    }
    
    private func saveRoster() {
        if let encoded = try? JSONEncoder().encode(roster){
            UserDefaults.standard.setValue(encoded, forKey: "SavedRoster")
        }
    }
    
    func resetUserTeamID() {
        userTeamID = nil
    }
    
    //Routing
    public enum MakeTeamRoute: Codable, Hashable {
        case createteaminfo
        case createrosterinfo (teamName: String, teamImageData: Data?)
        case seefinalteaminfo (teamName: String, teamImageData: Data?, roster: [Player])
    }
    
    func navigate(to destination: MakeTeamRoute) {
        path.append(destination)
    }

    
    func navigateBack() {
        path.removeLast()
    }
    
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
    
}


final class Router: ObservableObject {
    @Published var teamRouter = [TeamRoute]()
    @Published var statsRouter = [StatsRoute]()
    @Published var gamesRouter = [GamesRoute]()
    
    public enum TeamRoute: Hashable {
        case playerdetail (Player, TeamModel)

    }
    
    public enum StatsRoute: Hashable {
        case teamstats (String)
        case advancedStat
        case chartsAndVisuals
    }
    
    public enum GamesRoute: Hashable {
        case gameSettings
        case starters (InputGameObject)
        case pregame (InputGameObject)
        case playgame (InputGameObject)
        case logstat (Binding<Game>, String, [UUID])
        case seeSingleGameSummary(Game)
    }

}

struct InputGameObject: Equatable, Hashable {
    var oppName: String
    var isHome: Bool
    var periodSections: Int
    var periodLength: Int
    var playersPlaying: [UUID]
}



extension Binding: Equatable where Value: Equatable {
    public static func == (lhs: Binding<Value>, rhs: Binding<Value>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
extension Binding: Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.wrappedValue)
    }
}

func fakeTeam() -> TeamModel {
    var team = TeamModel(name: "Catalina Foothills", players: [])
    team.players.append(.init(name: "Seth Rojas", number: 21, heightInch: 70, weightLbs: 150, position: .SG))
    team.players.append(.init(name: "Chris Paul", number: 3, heightInch: 68, weightLbs: 160, position: .PG))
    team.players.append(.init(name: "Devin Booker", number: 1, heightInch: 76, weightLbs: 180, position: .SF))
    team.players.append(.init(name: "Lamarcus Aldridge", number: 11, heightInch: 80, weightLbs: 230, position: .PF))
    team.players.append(.init(name: "Victor Wembanyama", number: 1, heightInch: 88, weightLbs: 215, position: .C))
    return team
}

func randomGame() -> (Game, [UUID]) {
    var idPB = [UUID : PlayerStats]()
    var arr = [UUID]()
    
    for _ in 0..<7 {
        var id = UUID()
        arr.append(id)
        idPB[id] = PlayerStats(FTA : Int.random(in: 0...3), FTM: Int.random(in: 0...3), P2M: Int.random(in: 0...3), P2A: Int.random(in: 0...3), P3M: Int.random(in: 0...3), P3A: Int.random(in: 0...3), AST: Int.random(in: 0...3), DREB: Int.random(in: 0...3), OREB: Int.random(in: 0...3), STL: Int.random(in: 0...3), BLK: Int.random(in: 0...3), TOV: Int.random(in: 0...3))
    }
    
    
    return (Game(date: Date(), isUserHome: false, userPlayerBoxStats: idPB, oppTeamName: "Salpointe Catholic", gameLog: []), arr)
     
}

func newRandomGame(team: TeamModel) -> Game {
    var idPB = [UUID : PlayerStats]()
    for player in team.players {
        idPB[player.id] = PlayerStats(FTA : Int.random(in: 0...3), FTM: Int.random(in: 0...3), P2M: Int.random(in: 0...3), P2A: Int.random(in: 0...3), P3M: Int.random(in: 0...3), P3A: Int.random(in: 0...3), AST: Int.random(in: 0...3), DREB: Int.random(in: 0...3), OREB: Int.random(in: 0...3), STL: Int.random(in: 0...3), BLK: Int.random(in: 0...3), TOV: Int.random(in: 0...3))
    }
    
    return Game(date: Date(), isUserHome: false, userPlayerBoxStats: idPB, oppTeamName: "Salpointe Catholic", gameLog: [])
    
}

extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}

