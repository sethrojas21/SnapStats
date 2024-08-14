//
//  LandscapeForce.swift
//  SnapStats
//
//  Created by Seth Rojas on 7/13/24.
//

import Foundation
import UIKit
import SwiftUI

class LandscapeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Force landscape orientation
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
}

struct LandscapeViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> LandscapeViewController {
        return LandscapeViewController()
    }
    
    func updateUIViewController(_ uiViewController: LandscapeViewController, context: Context) {
        // Update the view controller if needed
    }
}


