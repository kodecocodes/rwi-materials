//
//  OnboardingModel.swift
//  OnboardingModel
//
//  Created by aaqib.hussain on 09.08.21.
// swiftlint:disable all

import SwiftUI

public struct OnboardingModel: Identifiable {
    
    
    public let id = UUID()
    
    let title: String
    let description: String
    let image: Image
    let nextButtonTitle: String
    let skipButtonTitle: String
    
    public init(title: String, description: String, image: Image, nextButtonTitle: String, skipButtonTitle: String) {
        self.title = title
        self.description = description
        self.image = image
        self.nextButtonTitle = nextButtonTitle
        self.skipButtonTitle = skipButtonTitle
    }
}
