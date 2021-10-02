//
//  OnboardingView.swift
//  OnboardingView
//
//  Created by aaqib.hussain on 08.08.21.
//  swiftlint:disable all

import SwiftUI

struct OnboardingView: View {

    let onboarding: OnboardingModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .circular)
                .fill(Color.white)
                .shadow(radius: 12)
                .padding(.horizontal, 20)
            VStack(alignment: .center) {
                VStack {
                    Text(onboarding.title)
                        .foregroundColor(.rwDark)
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                    Text(onboarding.description)
                        .foregroundColor(.rwDark)
                        .multilineTextAlignment(.center)
                        .padding([.top, .bottom], 10)
                        .padding(.horizontal, 10)
                   onboarding.image
                        .resizable()
                        .frame(width: 140, height: 140, alignment: .center)
                        .foregroundColor(.rwDark)
                        .aspectRatio(contentMode: .fit)
                    
                }
                .padding()
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingView(onboarding: OnboardingModel(title: "Welcome to PetSave", description: "Looking for a Pet? Then you're at the right place", image: Image("creature-bird-blue-fly", bundle: .module), nextButtonTitle: "Naschte", skipButtonTitle: "Skip"))
        }
    }
}
