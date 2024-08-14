//
//  LogShotView.swift
//  SnapStats
//
//  Created by Seth Rojas on 7/15/24.
//

import SwiftUI

struct LogShotView: View {
    @State private var location: CGPoint = .zero
    var madeShot: Bool = true
    @Binding var game: Game
    var player: Player


    var tap: some Gesture {
        SpatialTapGesture(coordinateSpace: .local)
            .onEnded { event in
                withAnimation(.bouncy){
                    self.location = event.location
                }
             }
    }
    


    var body: some View {
        
        GeometryReader {geo in
            
            ZStack{
                
                Image("courtTransparent-modified")
                    .resizable()
                    .scaledToFit()
                           
                Image(systemName: madeShot ? "circle" : "multiply")
                    .foregroundStyle(madeShot ? .green : .red)
                    .font(.largeTitle)
                    .position(location)
//                    .animation(.bouncy, value: location)
                    
                VStack{
                    Spacer()
                    Text(location.debugDescription)
                    
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .gesture(tap)
            .onAppear{
                withAnimation(.bouncy) {
                    location = CGPoint(x: geo.size.width * 0.5, y: geo.size.height * 0.5)
                }
            }
        }
        .preferredColorScheme(.dark)
        .ignoresSafeArea()
    }
}

#Preview {
    LogShotView(game: .constant(Game(date: Date(), isUserHome: false, userPlayerBoxStats: [:], oppTeamName: "Bad Team", oppPlayerBoxStats: [], gameLog: [])), player: Player(name: "Seth Rojas", number: 21, heightInch: 70, weightLbs: 150, position: .SG))
}
