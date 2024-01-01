//
//  PanelView.swift
//  VisionWeather
//
//  Created by JINSEN WU on 12/25/23.
//

import SwiftUI

struct PanelView<Content: View>: View {
    
    let content: Content
    
    init (@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            VStack {
                content
                    .padding()
            }
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .background(Color("NewsWindowColor").opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 25.0, style: .continuous))
        }
    }
}

struct PanelView_Previews: PreviewProvider {
    static var previews: some View {
        PanelView() {
            createPanelNewsView()
        }
    }
    
    static func createPanelNewsView() -> some View {
        HStack {
            Image(systemName: "newspaper.fill")
                .resizable()
                .frame(width: 50, height: 50)
            Text("There is currently no bad news")
                .font(.system(size: 24, weight: .medium))
        }
        .padding()
        .foregroundColor(.white)
    }
    
}
