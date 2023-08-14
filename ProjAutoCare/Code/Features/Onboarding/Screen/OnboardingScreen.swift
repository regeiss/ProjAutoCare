//
//  OnboardingScreen.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 19/06/23.
//

import SwiftUI

struct OnboardingScreen: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct OnBoardingView: View
{
    @State private var currentTab = 0
    
    var body: some View
    {
        TabView(selection: $currentTab, content: {
            ForEach(OnboardingData.list) { viewData in
                OnboardingTabView(data: viewData)
                    .tag(viewData.id)
            }
        })
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct OnboardingTabView: View
{
    var data: OnboardingData

    @State private var isAnimating: Bool = false

    var body: some View
    {
        VStack(spacing: 20)
        {
            ZStack
            {
                Image(data.backgroundImage)
                    .resizable()
                    .scaledToFit()
                
                Image(data.objectImage)
                    .resizable()
                    .scaledToFit()
                    .offset(x: 0, y: 150)
                    .scaleEffect(isAnimating ? 1 : 0.9)
            }
            Spacer()
            
            Text(data.primaryText)
                .font(.title2)
                .bold()
                .foregroundColor(Color(red: 41 / 255, green: 52 / 255, blue: 73 / 255))
            
            Text(data.secondaryText)
                .font(.headline)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 250)
                .foregroundColor(Color(red: 237 / 255, green: 203 / 255, blue: 150 / 255))
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 2, y: 2)
            
            Spacer()
            
            Button(action: {
                // Add action for button
            }, label: {
                Text("Inicie aqui")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 50)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(
                                Color(
                                    red: 255 / 255,
                                    green: 115 / 255,
                                    blue: 115 / 255
                                )
                            )
                    )
            })
            .shadow(radius: 10)
            
            Spacer()
        }
        .onAppear(perform: {
            isAnimating = false
            withAnimation(.easeOut(duration: 0.5)) {
                self.isAnimating = true
            }
        })
    }
}

struct OnboardingButton: View
{
    // #1
    @AppStorage("needsAppOnboarding") var needsAppOnboarding: Bool = true
    
    var body: some View
    {
        GeometryReader { proxy in
            LazyHStack
            {
                Button("Finish Setup", action: {
                    
                    // #2
                    needsAppOnboarding = false
                })
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(40)
                .frame(minWidth: 0, maxWidth: proxy.size.width-40)
            }
            .frame(width: proxy.size.width, height: proxy.size.height/1.5)
        }
    }
}
