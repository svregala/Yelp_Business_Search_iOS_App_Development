//
//  View+Modifiers.swift
//  Yelp Review App
//
//  Created by Steve Regala on 12/4/22.
//

import SwiftUI

extension View {
    public func alwaysPopover<Content>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View where Content : View {
        self.modifier(AlwaysPopoverModifier(isPresented: isPresented, contentBlock: content))
    }
}
