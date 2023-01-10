//
//  EmailValidToast.swift
//  Yelp Review App
//
//  Created by Steve Regala on 12/8/22.
//

import SwiftUI

// CITATION: https://stackoverflow.com/questions/56550135/swiftui-global-overlay-that-can-be-triggered-from-any-view
struct EmailValidToast<Presenting, Content>: View where Presenting: View, Content: View {
    @Binding var isPresented: Bool
    let presenter: () -> Presenting
    let content: () -> Content
    let delay: TimeInterval = 2

    var body: some View {
        if self.isPresented {
            DispatchQueue.main.asyncAfter(deadline: .now() + self.delay) {
                withAnimation {
                    self.isPresented = false
                }
            }
        }

        return GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                self.presenter()

                ZStack {
                    RoundedRectangle(cornerSize: .init(width: 30, height: 30)).fill(.gray)

                    self.content()
                } //ZStack (inner)
                .frame(width: geometry.size.width / 1.00, height: geometry.size.height / 10)
                .opacity(self.isPresented ? 1 : 0)
            } //ZStack (outer)
        } //GeometryReader
    } //body
} //Toast

struct EmailValidToast_Previews: PreviewProvider {
    static var previews: some View {
        Text("TEST")
        //EmailValidToast<Presenting: View, <#Content: View#>>(isPresented: true)
    }
}
