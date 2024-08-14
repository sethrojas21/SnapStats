//
//  MultiUseViewFunctions.swift
//  SnapStats
//
//  Created by Seth Rojas on 7/2/24.
//

import Foundation
import SwiftUI
import PhotosUI


extension String{
    func abbrievateString() -> String{
        let words = self.split(separator: " ")

        // Get the first letter of each word
        let firstLetters = words.map { word -> Character in
            guard let firstChar = word.first else {
                return Character("")
            }
            return firstChar
        }

        // Convert the array of characters back into a string
        let result = String(firstLetters)
        let firstThreeCharacters = result.prefix(4)
        
        return String(firstThreeCharacters)
    }
    
    func abbreviatedName() -> String {
        let nameComponents = self.split(separator: " ")
        guard let firstName = nameComponents.first, let lastName = nameComponents.last else {
            return self // If the string doesn't contain at least two components, return it as is
        }
        
        let firstInitial = firstName.prefix(1)
        return "\(firstInitial). \(lastName)"
    }
}

extension TeamModel {
    
    func gameRecordConvertedToString() -> String {
        var gamesWon: Int = 0
        var gamesLost: Int = 0
        
        for game in games {
            if game.didWin {
                gamesWon += 1
            } else{
                gamesLost += 1
            }
        }
        
        return "\(gamesWon) - \(gamesLost)"
    }
}

extension Game {
    
    func totalUserPoints(team: TeamModel) -> Int {
        var totalPoints = 0
        for player in team.players {
            if let currPlayer = userPlayerBoxStats[player.id] {
                totalPoints +=  currPlayer.P2M * 2 + currPlayer.P3M * 3 + currPlayer.FTM
            }
        }
        return totalPoints
    }
    
    func totalOppPoints() -> Int {
        var points = 0
        for oppPlayerBoxStat in self.oppPlayerBoxStats {
            points += oppPlayerBoxStat.P2M * 2 + oppPlayerBoxStat.P3M * 3
        }
        return points
    }
    
    var didWin: Bool { //TODO make function work
        return true
    }
    
    var dateFormatted: String {
        return date.formatted(date: .long, time: .omitted)
    }
    
}

func scoreGameUI(_ team: TeamModel, _ game: Game, _ geo: GeometryProxy) -> some View {
    HStack{
        
        VStack{
            if let data = team.image, let uiImage = UIImage(data: data){
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width * 0.2, height: geo.size.height * 0.1)
                    .clipShape(Circle())
            } else{
                Image("UnknownPersonHeadshot")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: geo.size.width * 0.2, height: geo.size.height * 0.1)
            }
            
            Text(team.name.abbrievateString())
        }
        
        Text(game.totalUserPoints(team: team).description)
            .font(.title)
            .bold()
            .padding(.trailing)
        
        Text("FINAL")
            .padding(.bottom, 10)
            .font(.caption)
        
        Text("\(game.totalOppPoints())")
            .font(.title)
            .bold()
            .padding(.leading)
        
        VStack{
            Image("appIcon")
                .resizable()
                .scaledToFit()
                .frame(width: geo.size.width * 0.2, height: geo.size.height * 0.1)
            
            Text(game.oppTeamName.abbrievateString())
        }
        
    }
}


func SingleGameUII(_ team: TeamModel, _ game: Game, _ geo: GeometryProxy, size: Double = 0.25) -> some View{
    RoundedRectangle(cornerRadius: 10.0)
        .stroke(.gray)
        .frame(height: geo.size.height * size)
        .overlay{
            VStack{
                
                scoreGameUI(team, game, geo)
                
                Text(game.dateFormatted)
                    .font(.title3)
                    .padding(.top)
            }
        }
        .padding()
}

func HomeViewHeader(_ team: TeamModel, _ geo: GeometryProxy) -> some View {
    VStack{
        HStack{
            if let data = team.image, let image = UIImage(data: data){
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
                if let data = team.image, let uiImage = UIImage(data: data){
                    Text(team.name)
                        .font(.system(size: 40))
                        .minimumScaleFactor(0.5)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .bold()
                        .foregroundStyle(.averageColor(uiImage: uiImage))
                        .contrast(3.0)
                        .brightness(0.40)
                } else{
                    Text(team.name)
                        .font(.system(size: 40))
                        .minimumScaleFactor(0.5)
                        .lineLimit(2)
//                        .brightness(2.0)
                        .multilineTextAlignment(.center)
                        .bold()
                }
                Text(team.gameRecordConvertedToString())
                    .font(.title3)
                    .foregroundStyle(team.avgColorFromTeamImage)
                    .brightness(0.1)

                
            }
            .padding(.trailing)
            
            Spacer()
            Spacer()
        }
//        .padding(.top)
        
    }
}


struct TeamHeaderView: View {
    var team: TeamModel
    var geo: GeometryProxy
    var isPhotosPickers: Bool = false
    
    @Binding var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
//        if isPhotosPickers {
                VStack{
                    HStack{
                        PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                            ZStack{
                                if let data = team.image, let image = UIImage(data: data){
                                    Image(uiImage: image)
                                        .profileImage(size: geo.size.width * 0.3, strokeWidth: 0.0)
                                        .padding([.top, .horizontal])
                                } else{
                                    Image("UnknownPersonHeadshot")
                                        .profileImage(size: geo.size.width * 0.3)
                                        .padding([.top, .horizontal])
                                }
                            }
                        }
                        
                        Spacer()
                        
                        VStack{
                            if let data = team.image, let uiImage = UIImage(data: data){
                                Text(team.name)
                                    .font(.system(size: 40))
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .bold()
                                    .foregroundStyle(adjustColorIfTooDark(team.avgColorFromTeamImage))
                                    .contrast(3.0)
                                    .brightness(0.40)
                            } else{
                                Text(team.name)
                                    .font(.system(size: 40))
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .bold()
                            }
                            Text(team.gameRecordConvertedToString())
                                .font(.title3)
                                .foregroundStyle(adjustColorIfTooDark(team.avgColorFromTeamImage))
                                .brightness(0.1)

                            
                        }
                        .padding(.trailing)
                        
                        Spacer()
                        Spacer()
                        
                        
                    }
                }
                .padding(.top)
//                
//            
//        } else {
//            HomeViewHeader(team, geo)
//        }
        
    }
}

struct HiddenNavigationBar: ViewModifier {
    func body(content: Content) -> some View {
        content
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
    }
}

extension View {
    func hiddenNavigationBarStyle() -> some View {
        modifier( HiddenNavigationBar() )
    }
}

func getPositionCountInRoster(team: [Player], position: Position) -> Int {
    var sum = 0
    for player in team {
        if player.position == position {
            sum += 1
        }
    }
    
    return sum
}

func getQuarterHalveFullPeriod(val: Int)  -> String {
    if val == 1 {
        return "period"
    } else if val == 2 {
        return "halves"
    } else {
        return "quarters"
    }
}

extension UIColor {
    var brightness: CGFloat {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red * 299 + green * 587 + blue * 114) / 1000
    }
}

func adjustColorIfTooDark(_ color: Color) -> Color {
    let uiColor = UIColor(color)
    let brightness = uiColor.brightness
    
    return brightness < 0.4 ? .white : color
}

func showStatLeaderWithImage(statName: String, _ stat: String, team: TeamModel) -> some View {
    let calc = calculateStatLeader(stat: statName, team: team)
    let player = calc.1
    let highestValue = calc.0
    
    return HStack {
        VStack (alignment: .leading) {
            Text(stat)
                .font(.title3)
                .bold()
            HStack {
                if let data = player.image, let uiImage = UIImage(data: data) {
                    
                } else {
                    Image("UnknownPersonHeadshot")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 75, height: 75)
                }
                VStack (alignment: .leading) {
                    HStack {
                        Text(player.name.abbreviatedName())
                            .lineLimit(1)
                        Text(player.position.rawValue)
                            .opacity(0.5)
                    }
                    
                    Text(highestValue.description)
                        .font(.title)
                        .bold()
                    
                }
                .padding(.leading, 5)
                
            }
        }
    }
    .padding()
    .frame(width: 225)
    .background(.ultraThinMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 25.0))
}

