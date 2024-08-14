import SwiftUI
import PhotosUI

struct AddPlayerView: View {
    @Binding var roster: [Player]
    
    @Environment(\.dismiss) var dismiss
    
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedPhotosData: Data?
    
    @State var name: String = ""
    @State var number: String = ""
    @State var heightInch: String = ""
    @State var weightLbs: String = ""
    @State var position: Position = .PG
    
    let positions: [Position] = [.PG, .SG, .SF, .PF, .C]
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Button("Save"){
                    let player = Player(name: name, image: selectedPhotosData, number: Int(number) ?? 0, heightInch: Double(heightInch) ?? 0.0, weightLbs: Int(weightLbs) ?? 0, position: position)
                    roster.append(player)
                    dismiss()
                }
                .padding()
//                Button(action: {
//
//                }) {
//                    Text("Save")
//                        .font(.headline)
//                        .padding()
//                        .foregroundColor(.white)
//                        .background(Color.blue)
//                        .cornerRadius(10)
//                }
//                .padding()
            }
            
            PhotosPicker(selection: $selectedPhoto, matching: .images, photoLibrary: .shared()) {
                if let selectedPhotosData, let uiImage = UIImage(data: selectedPhotosData){
                    Image(uiImage: uiImage)
                        .profileImage(strokeWidth: 5/*, color: .averageColor(uiImage: uiImage)*/)
                        
                } else{
                    Image("UnknownPersonHeadshot")
                        .profileImage(strokeWidth: 5, color: .brightOrange)
                }
            }
            .padding()
            
            Group {
                TextField("", text: $name, prompt: Text("Name").foregroundStyle(.black.opacity(0.5)))
                    .basicField()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    .submitLabel(.join)
                
                TextField("", text: $number, prompt: Text("Number").foregroundStyle(.black.opacity(0.5)))
                    .basicField()
                    .keyboardType(.numberPad)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    .submitLabel(.join)

                TextField("", text: $heightInch, prompt: Text("Height (in)").foregroundStyle(.black.opacity(0.5)))
                    .basicField()
                    .keyboardType(.numberPad)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    .submitLabel(.join)
                
                TextField("", text: $weightLbs, prompt: Text("Weight (lbs)").foregroundStyle(.black.opacity(0.5)))
                    .basicField()
                    .keyboardType(.numberPad)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    .submitLabel(.join)
            }
            .padding(.horizontal)
            .padding(.top, 5)
            
            Picker("Position", selection: $position) {
                ForEach(positions, id: \.self){ pos in
                    Text(pos.rawValue)
                }
            }
            
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .background(Color.black.opacity(0.1))
            .cornerRadius(10)
            
        }
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                selectedPhotosData = data
            }
        }
        .preferredColorScheme(.dark)
        .padding()
    }
}

extension TextField {
    func basicField() -> some View {
        self
            .font(.title2)
            .padding()
            .background(Color.white)
            .foregroundStyle(.black)
            .cornerRadius(10)
            .shadow(color: .gray, radius: 5, x: 0, y: 0)
            .padding(.bottom, 10)

    }
}

//extension Image {
//    func profileImage(size: CGFloat = 150, strokeWidth: CGFloat = 4) -> some View {
//        self
//            .resizable()
//            .aspectRatio(contentMode: .fill)
//            .frame(width: size, height: size)
//            .clipShape(Circle())
//            .overlay(Circle().stroke(Color.white, lineWidth: strokeWidth))
//            .shadow(radius: 10)
//    }
//}

#Preview {
    AddPlayerView(roster: .constant([]))
}
