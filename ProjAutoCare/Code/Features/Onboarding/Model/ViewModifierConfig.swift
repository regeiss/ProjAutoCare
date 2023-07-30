//
//  ViewModifierConfig.swift
//  ProjAutoCare
//
//  Created by Roberto Edgar Geiss on 04/07/23.
//

import Foundation
import SwiftUI
//
struct PrimaryViewModifier: ViewModifier
{
    func body(content: Content) -> some View
    {
        content
            .font(.title3.bold())
            .foregroundColor(.accentColor)
    }
}

struct SecondaryViewModifier: ViewModifier
{
    func body(content: Content) -> some View
    {
        content
            .font(.body)
            .foregroundColor(.white)
    }
}

struct TertiaryViewModifier: ViewModifier
{
    func body(content: Content) -> some View
    {
        content
            .font(.subheadline)
            .foregroundColor(.white)
    }
}

struct ButtonViewModifier: ViewModifier
{
    var border: Color
    var background: Color
    func body(content: Content) -> some View
    {
        content
            .padding()
            .padding([.leading, .trailing], 24)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(background)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(border, lineWidth: 1)
            )
            .padding()
    }
}

extension View
{
    func primaryLabel() -> some View
    {
        return self
            .modifier(PrimaryViewModifier())
    }
    
    func secondaryLabel() -> some View
    {
        return self
            .modifier(SecondaryViewModifier())
    }
    
    func tertiaryLabel() -> some View
    {
        return self
            .modifier(TertiaryViewModifier())
    }
    
    func primaryButton() -> some View
    {
        return self
            .modifier(PrimaryViewModifier())
            .modifier(
                ButtonViewModifier(
                    border: .accentColor,
                    background: .black
                )
            )
    }
    
    func secondaryButton() -> some View
    {
        return self
            .modifier(SecondaryViewModifier())
            .modifier(
                ButtonViewModifier(
                    border: .white,
                    background: .black
                )
            )
    }
    
    func tertiaryButton() -> some View
    {
        return self
            .modifier(TertiaryViewModifier())
    }
}
