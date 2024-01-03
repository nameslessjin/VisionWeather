//
//  NewsView.swift
//  VisionWeather
//
//  Created by JINSEN WU on 12/27/23.
//

import SwiftUI

struct NewsView: View {
    
    @State var news: String
    
    func createNewsView() -> some View {
        HStack{
//            Image(systemName: "newspaper.fill")
//                .resizable()
//                .frame(width: 50, height: 50)
            Text("Alert: \(news)")
                .font(.system(size: 30, weight: .medium))
            
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    var body: some View {
        PanelView() {
            createNewsView()
        }
    }
}

#Preview {
    NewsView(news: "There is current no bad news")
}
