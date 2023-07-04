//
//  OnboardingModel.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 04/07/23.
//

import Foundation

struct OnboardingData: Hashable, Identifiable
{
    let id: Int
    let backgroundImage: String
    let objectImage: String
    let primaryText: String
    let secondaryText: String

    static let list: [OnboardingData] = [
        OnboardingData(id: 0, backgroundImage: "onboarding-bg-1", objectImage: "onboarding-object-1", primaryText: "Get healthy and live peacfully", secondaryText: "Living a happier, more satisfied life is within reach."),
        OnboardingData(id: 1, backgroundImage: "onboarding-bg-2", objectImage: "onboarding-object-2", primaryText: "Predict weather", secondaryText: "Predict weather trends and conditions with current solar activity."),
        OnboardingData(id: 2, backgroundImage: "onboarding-bg-3", objectImage: "onboarding-object-3", primaryText: "Get air quality information", secondaryText: "Immediate, accurate air quality data to help you create healthier.")
    ]
}
