//
//  ProductView.swift
//  HYPDAssignment
//
//  Created by Ravi kant Tiwari on 29/06/23.
//

import SwiftUI

struct ProductView: View {
    
    var addBtnAction: (() -> Void) = {}
    var isShowAddBtn : Bool = true
    var isShowSltBtn : Bool = false
    var isShowShareBtn : Bool = false
    @State var product : ProductsPayload?
    @State private var discountPercentage: Int = 0
    @ObservedObject var viewModel: ProductStoreViewModel

    var body: some View {
        VStack{
            Spacer().frame(height:15)
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 164.5, height: 215.52)
                    .background(
                        LinearGradient(
                            stops: [
                                Gradient.Stop(color: .black.opacity(0.2), location: 0.00),
                                Gradient.Stop(color: .black.opacity(0), location: 1.00),
                            ],
                            startPoint: UnitPoint(x: 1, y: -0.04),
                            endPoint: UnitPoint(x: 0.72, y: 0.22)
                        )
                    )
                    .cornerRadius(12)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 164.5, height: 215.52139)
                    .background(
                        AsyncImage(
                            url: URL(string: product?.featuredImage?.src ?? ""),
                            loadingView: {  },
                            image: { Image(uiImage: $0).resizable() },
                            placeholder: { Image("ProductImage").renderingMode(.original)},
                            contentMode: .fill,
                            placeholderTextColor: .white
                            )
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 164.5, height: 215.52)
                            .clipped()
                    )
                    .cornerRadius(12)
                
                if isShowShareBtn {
                    ZStack {
                        Image("shareIcon")
                            .aspectRatio(contentMode: .fit)
                    }
                    .frame(width: 24, height: 24)
                    .position(x:142, y:28)
                }
                
                if isShowAddBtn {
                    ZStack {
                        Button {
                            if isShowSltBtn {
                                withAnimation {
                                    viewModel.selectProduct(product: product!)
                                }
                            }else{ addBtnAction() }
                        } label: {
                            if isShowSltBtn {
                                Image(viewModel.isSelected(product!) ? "sltIcn" : "checkBoxIcn")
                                    .aspectRatio(contentMode: .fit)
                            }else{
                                Image("addIcon")
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                    }
                    .frame(width: 32, height: 32)
                    .position(x:142, y:220)
                }
                
                
            }
            .frame(width: 164.5, height: 230)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product?.name ?? "Puma")
                .font(
                Font.custom(UserInterfaceConstants.FontNames.UrbanistBold, size: 12)
                )
                .kerning(0.4)
                .foregroundColor(Color(UserInterfaceConstants.ColorNames.darkPurple))
                
//                Text("Forest bomber jacket with Hoodie")
//                .font(
//                Font.custom(UserInterfaceConstants.FontNames.UrbanistMedium, size: 12)
//                )
//                .kerning(0.4)
//                .foregroundColor(Color(UserInterfaceConstants.ColorNames.secondaryText))
//                .frame(width: 155, height: 32, alignment: .topLeading)
                
                Spacer().frame(height:5)
                HStack(alignment: .center, spacing: 4) {

                    Text("₹" + String(product?.retailPrice?.value ?? 15))
                    .font(
                        Font.custom(UserInterfaceConstants.FontNames.UrbanistBold, size: 12)
                        )
                    .kerning(0.2)
                    .foregroundColor(Color(UserInterfaceConstants.ColorNames.darkPurple))

                    if discountPercentage > 0 {
                        Text("₹" + String(product?.basePrice?.value ?? 15))
                            .font(
                                Font.custom(UserInterfaceConstants.FontNames.UrbanistMedium, size: 12)
                            )
                            .kerning(0.4)
                            .strikethrough()
                            .foregroundColor(Color(UserInterfaceConstants.ColorNames.disabledtext))
                    }
                    
                    if discountPercentage > 0 {
                        Text("(" + String(discountPercentage) + "% off)")
                            .font(
                                Font.custom(UserInterfaceConstants.FontNames.UrbanistBold, size: 12)
                            )
                            .kerning(0.4)
                            .foregroundColor(Color(red: 0, green: 0.76, blue: 0.35))
                    }
                }
                .padding(0)
                
                HStack(alignment: .center, spacing: 10) {
                    HStack(alignment: .center) {
                        ZStack {
                            Image("discount-shape")
                                .aspectRatio(contentMode: .fit)
                        }
                        .frame(width: 16, height: 16)
                        Text("Commission")
                          .font(
                            Font.custom(UserInterfaceConstants.FontNames.UrbanistBold, size: 12)
                          )
                          .kerning(0.4)
                          .foregroundColor(Color(UserInterfaceConstants.ColorNames.darkPurple))
                    Spacer()
                        Text(String(product?.commissionRate ?? 12))
                          .font(
                            Font.custom(UserInterfaceConstants.FontNames.UrbanistBold, size: 12)
                          )
                          .kerning(0.4)
                          .multilineTextAlignment(.trailing)
                          .foregroundColor(Color(UserInterfaceConstants.ColorNames.darkPurple))
                    }
                    .padding(.leading, 8)
                    .padding(.trailing, 12)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color(red: 0.98, green: 0.98, blue: 0.98))
                    .cornerRadius(6)
                }
                .padding(.horizontal, 0)
                .padding(.vertical, 2)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 0)
            .padding(.vertical, 0)
            .frame(width: 164, alignment: .topLeading)
            .background(Color(.clear))
        }
        .onAppear {
            discountPercentage = calculateDiscountPercentage(originalPrice: Double(product?.basePrice?.value ?? 15), discountedPrice: Double(product?.retailPrice?.value ?? 15))
        }
    }
    
    func calculateDiscountPercentage(originalPrice: Double, discountedPrice: Double) -> Int {
        if originalPrice == discountedPrice {
            return 0
        } else {
            let discountAmount = originalPrice - discountedPrice
            let discountPercentage = (discountAmount / originalPrice) * 100
            let roundedPercentage = discountPercentage.rounded()
            return Int(roundedPercentage)
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        ProductView(product: ProductsPayload(), viewModel: ProductStoreViewModel())
    }
}
