//
//  AddNewPlayerView.swift
//  SnapStats
//
//  Created by Seth Rojas on 7/6/24.
//

import SwiftUI
import PhotosUI

struct AddNewPlayerView: View {
    @Environment(\.dismiss) var dismiss
    @State var name: String = ""
    @State var height: String = ""
    @State var number: String = ""
    @State var weight: String = ""
    @State var position: Position = .PG
    
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotosData: Data?
    
    @Binding var roster: [Player]
    
    let positions: [Position] = [.PG, .SG, .SF, .PF, .C]
    
    @FocusState var inputActive: Bool
    
    var player = Player(name: "Seth Rojas", number: 21, heightInch: 70.5, weightLbs: 150, position: .SG)
    var body: some View {
        GeometryReader{geo in
            VStack{
                HStack{
                    TextField("Ht (in)", text: $height)
                        .textFieldStyle(OutlinedTextFieldStyle())
                        .padding(.horizontal)
                        .keyboardType(.numberPad)

                    
                    TextField("Number", text: $number)
                        .textFieldStyle(OutlinedTextFieldStyle())
                        .padding(.horizontal)
                        .keyboardType(.numberPad)

                    
                    TextField("Wt (lbs)", text: $weight)
                        .textFieldStyle(OutlinedTextFieldStyle())
                        .padding(.horizontal)
                        .keyboardType(.numberPad)
                }
                .padding(.top)
                
                Picker("Position", selection: $position) {
                    ForEach(positions, id: \.self){ pos in
                        Text(pos.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .cornerRadius(10)
                
                TextField("Name", text: $name)
                    .font(.title)
                    .padding(7.5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color(.blue), lineWidth: 2)
                    }
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                    .submitLabel(.done)
                
                PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                    if let selectedPhotosData, let uiImage = UIImage(data: selectedPhotosData){
                        Image(uiImage: uiImage)
                            .profileImage(size: geo.size.width * 0.4, strokeWidth: 2.0)
                            
                    } else{
                        Image("UnknownPersonHeadshot")
                            .profileImage(size: geo.size.width * 0.4, strokeWidth: 2.0)
                    }
                }
                
                Divider()
                
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(height: geo.size.height * 0.35)
                    .foregroundStyle(.ultraThinMaterial)
                    .overlay{
                        VStack{
                            HStack{
                                if let data = selectedPhotosData, let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .profileImage(size: geo.size.height * 0.125, strokeWidth: 0.0)
                                } else{
                                    Image("UnknownPersonHeadshot")
                                        .profileImage(size: geo.size.height * 0.125, strokeWidth: 0.0)
                                }
                                
                                
                                VStack (alignment: .leading){
                                    HStack{
                                        Text(name)
                                            .underline()
                                            .bold()
                                        Spacer()
                                    }
                                    
                                    if number != "" {
                                            HStack{
                                                Text("#" + number)
                                                Spacer()
                                            }
                                        }
                                    
                                    
                                }
                                .padding()
                                .frame(width: geo.size.width * 0.35, height: geo.size.height * 0.12)
                                .background(.brightOrange)
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            }
                            .padding(7.5)
                            .background{
                                RoundedRectangle(cornerRadius: 25.0)
                                    .stroke(.white)
                                    .foregroundStyle(.clear)
                                
                            }
                            HStack{
                                
                                playerVitalItem(text: Text(Measurement(value: Double(height) ?? 0.0, unit: UnitLength.inches), format: Measurement<UnitLength>.FormatStyle (width: .abbreviated, numberFormatStyle: .number)), geo: geo)
                                    .padding()
                                
                                playerVitalItem(text: Text(position.rawValue), geo: geo)
                                    .padding()
                                
                                playerVitalItem(text:                                 Text(Measurement<UnitMass>(value: Double(weight) ?? 0.0, unit: .pounds).description), geo: geo)
                                    .padding()
                                

                            }
                        }
                    }
                    .padding()
                
                Button {
                    let player = Player(name: name, image: selectedPhotosData, number: Int(number) ?? 0 , heightInch: Double(height) ?? 0.0, weightLbs: Int(weight) ?? 0, position: position)
                    roster.append(player)
                    dismiss()
                    
                } label: {
                    
                    RoundedRectangle(cornerRadius: 25.0)
                        .frame(height: geo.size.height * 0.05)
                        .foregroundStyle(.blue)
                        .overlay{
                            Text("Save")
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal)
                }
            }
        }
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                selectedPhotosData = data
            }
        }
        .preferredColorScheme(.dark)
    }
    
    func val (text: Text) -> some View {
        HStack {
            
        }
    }
    
    func playerVitalItem(text: Text, geo: GeometryProxy) -> some View {
        Circle()
            .stroke()
            .frame(width: geo.size.height * 0.1)
            .overlay{
                text
                    .foregroundStyle(.brightOrange)
                    .lineLimit(1)
                
            }
    }
}

#Preview {
    AddNewPlayerView(roster: .constant([]))
}
