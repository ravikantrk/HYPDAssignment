//
//  LoadingView.swift
//  HYPDAssignment
//
//  Created by Ravi kant Tiwari on 30/06/23.
//

import SwiftUI

struct LoadingView: View {
    
    var loadingMessage: String = "Loading"
    var isSmall: Bool = false
    var hasBorder: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.gray)
                .cornerRadius(18)
                .frame(width: 90, height: 90)
            HStack {
                Spacer()
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.0, anchor: .center)
                }
                Spacer()
            }
            .padding(.all, 20)
            .cornerRadius(16)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
            LoadingView()
        }
        ZStack {
            Color.blue
            LoadingView()
        }
        ZStack {
            Color.black
            LoadingView()
        }
    }
}
