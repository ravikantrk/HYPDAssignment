//
//  ImageErrorView.swift
//  utrplay
//
//  Created by João Barbosa on 05/01/2021.
//  Copyright © 2021 Universal Tennis LCC. All rights reserved.
//

import SwiftUI

struct ImageErrorView: View {
    
    private let errorType: ImageLoadingError
    private let textColor: Color
    
    init(errorType: ImageLoadingError, textColor: Color = .white) {
        self.errorType = errorType
        self.textColor = textColor
    }
    
    var title: Text {
        switch self.errorType {
        case .incorrectData:
            return Text("Could Not Load Image")
        case .timedOut:
            return Text("Request Timeout")
        case .unknown:
            return Text("Something Went Wrong")
        }
    }
    
    var description: Text {
        switch self.errorType {
        case .incorrectData:
            return Text("Could Not Load Image")
        case .timedOut:
            return Text("Request Timeout")
        case .unknown:
            return Text("Something Went Wrong")
        }
    }
    
    var body: some View {
        VStack {
            title
                .foregroundColor(textColor)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.45)
            description
                .multilineTextAlignment(.center)
                .foregroundColor(textColor)
                .lineLimit(2)
                .minimumScaleFactor(0.25)
                .padding(.top, 5.0)
            
        }
    }
}

struct ImageErrorView_Previews: PreviewProvider {
    
    static var previews: some View {
        ImageErrorView(errorType: .timedOut)
            .frame(width: 145, height: 145, alignment: .center)
            .background(Color.green)
        
    }
}
