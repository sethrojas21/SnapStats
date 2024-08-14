//
//  AppHomeScreenView.swift
//  SnapStats
//
//  Created by Seth Rojas on 7/9/24.
//

import SwiftUI

struct AppHomeScreenView: View {
    @State private var location: CGPoint = CGPoint(x: 200, y: 500)


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
            VStack {
                Image("appIcon")
                    .resizable()
                    .scaledToFit()
                
                Text("Snap Stats")
                    .padding(.top, -25)
                    .font(.system(size: 65))
                    .fontDesign(.serif)
                
                Text("The fastest stats for the quickest game ")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding(1)
                    .foregroundStyle(.brightOrange)
                Spacer()
                
                GeometryReader {geom in
                    Button {
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 25.0)
                            .frame(width: geo.size.width * 0.4, height: geo.size.width * 0.2)
                            .foregroundStyle(.ultraThinMaterial)
                            .overlay{
                                VStack{
                                    Image(systemName: "arrow.right")
                                        .foregroundStyle(.blue)
                                        .font(.title)
                                }
                            }
                    }
                    .position(location)
                    .gesture(tap)
                    .onAppear{
                        withAnimation(.bouncy(duration: 2.5)) {
                            location = CGPoint(x: geom.size.width * 0.5, y: geom.size.height * 0.5)
                        }
                    }
                }
                
                Spacer()
            }
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    AppHomeScreenView()
}
