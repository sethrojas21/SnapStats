//
//  AddTeamView.swift
//  SnapStats
//
//  Created by Seth Rojas on 6/27/24.
//

import SwiftUI
import PhotosUI
import SwiftData

struct AddTeamView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var userSaved: UserSaved
//    @Binding var path: NavigationPath
    
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotosData: Data?
    @State var roster: [Player] = [Player(name: "Fernando Gonzales", number: 21, heightInch: 71, weightLbs: 150, position: .SG)]
    @State private var teamName: String = ""
    
    @State var isAddPlayerViewShowing: Bool = false
    
    var body: some View {
        GeometryReader {geo in
            VStack{
                
                PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                    if let selectedPhotosData, let uiImage = UIImage(data: selectedPhotosData){
                        Image(uiImage: uiImage)
                            .profileImage(/*color: .averageColor(uiImage: uiImage)*/)
                    } else{
                        Image("UnknownPersonHeadshot")
                            .profileImage()
                    }
                }
                
                TextField("Team name", text: $teamName)
                    .textFieldStyle(OrangeGradientTextFieldStyle(roundedCornes: 25, startColor: .brightOrange, endColor: .gray, textColor: .white))
//                    .modifier(customViewModifier(roundedCornes: 25, startColor: .brightOrange, endColor: .gray, textColor: .white))
                    .padding()
                    .multilineTextAlignment(.center)
                    .defersSystemGestures(on: .vertical)
                
                Spacer()
                
                Button {
                    userSaved.navigate(to: .createrosterinfo(teamName: teamName, teamImageData: selectedPhotosData))
                } label: {
                    HStack {
                        Text("Next")
                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(.brightOrange)
                    .padding()
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                }
                .padding(.bottom, geo.size.height / 5)

            }
        }
        .ignoresSafeArea(.keyboard)
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    userSaved.navigateToRoot()
                    
                } label: {
                    HStack {
                        Image(systemName: "arrow.left.circle")
                            .tint(.brightOrange)
                    }
                }
            }
        }
        .navigationTitle("Team Info")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: selectedPhoto){
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self){
                selectedPhotosData = data
            }
        }
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden()
    }
    
    func deletePlayer(at index: Int) {
        // Ensure index is within bounds
        guard roster.indices.contains(index) else { return }
        
        // Perform deletion from your roster array
        roster.remove(at: index)
        
        // Perform any additional logic you need, such as updating UI or saving changes
    }
    
}

struct SwooshView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                let heightMultiplier = 0.6
                
                // Starting point at the top-left corner
                path.move(to: CGPoint(x: 0, y: 0))
                
                // Curve to create the swoosh effect
                path.addCurve(to: CGPoint(x: width, y: 0),
                              control1: CGPoint(x: width * 0.25, y: height * heightMultiplier),
                              control2: CGPoint(x: width * 0.75, y: height * heightMultiplier))
            }
            .fill(Color.brightOrange) // Adjust color as needed
            .frame(height: 50) // Adjust height as needed
        }
        .ignoresSafeArea()
    }
}

struct HeaderView: View {
    var title: String
    @Binding var sheetPresented: Bool
    
    var body: some View {
        VStack{
            HStack{
                Text(title)
                    .padding(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 10))
                Spacer()
                
                Button{
                    sheetPresented = true
                } label: {
                    Image(systemName: "plus.circle")
                        .foregroundStyle(.brightOrange)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 25))
                }
                
            }
            Divider()
        }
    }
}

#Preview {
    return AddTeamView(/*path: .constant(NavigationPath())*/)
        .environmentObject(UserSaved())
}
