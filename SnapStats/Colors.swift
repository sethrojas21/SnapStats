//
//  Colors.swift
//  SnapStats
//
//  Created by Seth Rojas on 6/24/24.
//

import Foundation
import SwiftUI
import UIKit
import CoreImage

extension ShapeStyle where Self == Color {
    static var brightOrange: Color{
        return Color(red: 1.0, green: 100/255, blue: 0)
    }
    
    static func averageColor(uiImage: UIImage) -> Color{
        return Color(uiColor: uiImage.averageColor!)
        
    }
}

struct customViewModifier: ViewModifier {
    var roundedCornes: CGFloat
    var startColor: Color
    var endColor: Color
    var textColor: Color

    func body(content: Content) -> some View {
        content
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(roundedCornes)
            .padding(3)
            .foregroundColor(textColor)
            .overlay(RoundedRectangle(cornerRadius: roundedCornes)
                        .stroke(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.5))
            .font(.system(size: 25))

            .shadow(radius: 10)
    }
}

struct OrangeGradientTextFieldStyle: TextFieldStyle {
    var roundedCornes: CGFloat
    var startColor: Color
    var endColor: Color
    var textColor: Color
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(roundedCornes)
            .padding(3)
            .foregroundColor(textColor)
            .overlay(RoundedRectangle(cornerRadius: roundedCornes)
                        .stroke(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.5))
            .font(.system(size: 25))

            .shadow(radius: 10)
    }
}

extension Image{
    
    func profileImage(size: Double = 200, strokeWidth: Double = 5.0, color: Color = .white) -> some View{
        self
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .frame(width: size, height: size)
            .overlay{
                Circle()
                    .stroke(color ,lineWidth: strokeWidth)
            }
            .padding()
    }
    
}


extension UIImage {
    static let sharedCIContext = CIContext(options: [.workingColorSpace: kCFNull ?? 0])
    
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        UIImage.sharedCIContext.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

struct OutlinedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(Color(UIColor.systemGray4), lineWidth: 2)
            }
    }
}

struct NoButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
    }
}

