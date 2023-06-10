//
//  SportsListView.swift
//  Outrack Watch App
//
//  Created by Valentin Mont on 07/06/2023.
//

import SwiftUI

struct SportsListView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Select one")
                    .frame(width: geometry.size.width * 0.8,
                           height: geometry.size.height * 0.2,
                           alignment: .leading)
                    .foregroundColor(Color(Color.secondary))
                    .fontWeight(.bold)

                Sport(text: "Running",
                      icon: "figure.run",
                      width: geometry.size.width * 0.9,
                      height: geometry.size.height * 0.22)
                Sport(text: "Cycling",
                      icon: "figure.outdoor.cycle",
                      width: geometry.size.width * 0.9,
                      height: geometry.size.height * 0.22)
                Sport(text: "Fitness",
                      icon: "figure.flexibility",
                      width: geometry.size.width * 0.9,
                      height: geometry.size.height * 0.22)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
    }
}

private struct Sport: View {
    let text: String
    let icon: String
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color(Color.secondary))
                    .cornerRadius(17)
                    .frame(width: width, height: height)

                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(Color(Color.primary))

                    Text(text)
                        .font(.system(size: 17))
                        .foregroundColor(Color(Color.primary))
                }

            }
            .padding(.bottom, 12)
        }
    }
}

struct SportsList_Previews: PreviewProvider {
    static var previews: some View {
        SportsListView()
    }
}
