//
//  ProductStoreView.swift
//  HYPDAssignment
//
//  Created by Ravi kant Tiwari on 29/06/23.
//

import SwiftUI

struct ProductStoreView: View {
    
    @State var isShowLeftItem : Bool = false
    @ObservedObject var viewModel: ProductStoreViewModel
    
    var body: some View {
        
        NavigationView {
            ZStack{
                ScrollView{
                    Spacer().frame(height:20)
                    if viewModel.isShowSelect == false {
                        topCollectionView
                        Spacer().frame(height:30)
                    }
                    
                    if viewModel.isShowSelect == false {
                        if viewModel.similarProductDataModel?.count ?? 0 > 0 {
                            SimilarProductsView
                        }
                    }
                    
                    ProductsListView
                    
                }
                .frame(width: UIScreen.main.bounds.width)
                .background(Color(.white))
                
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            
            .toolbar {
                leftNavView
                rightNavView
            }
            
        }
    }
    
    //MARK: Top Collection view
    var topCollectionView: some View {
        VStack{
            HStack(spacing: 10){
                Spacer().frame(width:16)
                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.collectionDataModel?.name ?? "")
                        .font(
                            Font.custom(UserInterfaceConstants.FontNames.UrbanistBold, size: 18)
                        )
                        .kerning(0.2)
                        .foregroundColor(Color(UserInterfaceConstants.ColorNames.darkPurple))
                    
                    Text(String(viewModel.collectionDataModel?.catalogIDS?.count ?? 0) + " Products")
                        .font(
                            Font.custom(UserInterfaceConstants.FontNames.UrbanistBold, size: 12)
                        )
                        .kerning(1)
                        .foregroundColor(Color(UserInterfaceConstants.ColorNames.secondaryText))
                }
                Spacer()
            }
            
        }
    }
    
    //MARK: Similar Products view
    var SimilarProductsView: some View {
        VStack{
            Spacer().frame(height: 16)
            HStack(alignment: .top){
                Spacer().frame(width: 17)
                Text("Some Products you can add to your store:")
                    .font(
                        Font.custom(UserInterfaceConstants.FontNames.UrbanistBold, size: 18)
                    )
                    .foregroundColor(Color(red: 0.26, green: 0.26, blue: 0.26))
                    .frame(width: 224, alignment: .topLeading)
                
                Spacer()
                
                Button {
                    withAnimation {
                        viewModel.addAllSimilarProducts()
                    }
                } label: {
                    Text("Add all")
                        .font(
                            Font.custom("Urbanist", size: 14)
                                .weight(.bold)
                        )
                        .kerning(0.2)
                        .foregroundColor(Color(red: 0.98, green: 0.42, blue: 0.14))
                }
                
                Spacer().frame(width: 17)
                
            }
            
            Spacer().frame(height: 10)
            
            ScrollView(.horizontal,showsIndicators: false){
                LazyHStack(spacing: 12){
                    
                    Spacer().frame(width: 17)
                    
                    ForEach(viewModel.similarProductDataModel ?? [], id: \.id) { products in
                        ProductView(addBtnAction: {
                            withAnimation {
                                viewModel.addProduct(product: products)
                            }
                        },product: products, viewModel: viewModel)
                    }
                }
            }
            
            Spacer().frame(height: 24)
            
        }
        .frame(width: UIScreen.main.bounds.width, height: 440)
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
    }
    
    //MARK: Collection Products List view
    var ProductsListView: some View {
        LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())]){
            ForEach(viewModel.productsDataModel, id: \.id) { products in
                ProductView(isShowAddBtn: viewModel.isShowSelect, isShowSltBtn: viewModel.isShowSelect,isShowShareBtn: !viewModel.isShowSelect,product: products, viewModel: viewModel)
                    .onAppear {
                        // Check if the current product is the last one in the list
                        if products.id == viewModel.productsDataModel.last?.id {
                            viewModel.fetchNextPage()
                        }
                    }
            }
        }
        .onAppear {
            viewModel.fetchNextPage()
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
    }
    
    //MARK: left navigation item view
    var leftNavView: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Text("Selected (" + String(viewModel.selectedProductDataModel.count) + ")")
                .font(
                    Font.custom(UserInterfaceConstants.FontNames.UrbanistBold, size: 18)
                )
                .kerning(0.2)
                .multilineTextAlignment(.trailing)
                .foregroundColor(Color(UserInterfaceConstants.ColorNames.darkPurple))
                .opacity(viewModel.isShowSelect ? 1 : 0)
        }
    }
    
    //MARK: Right navigation item view
    var rightNavView: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                viewModel.isShowSelect = !viewModel.isShowSelect
                if !viewModel.isShowSelect {
                    viewModel.clearSelection()
                }
            }) {
                Text(viewModel.isShowSelect ? "Cancel" : "Select")
                    .font(
                        Font.custom(UserInterfaceConstants.FontNames.UrbanistMedium, size: 16)
                    )
                    .kerning(0.2)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(viewModel.isShowSelect ? Color(red: 0.66, green: 0.66, blue: 0.66) : Color(UserInterfaceConstants.ColorNames.darkPurple))
            }
        }
    }
}

struct ProductStoreView_Previews: PreviewProvider {
    static var previews: some View {
        ProductStoreView(viewModel: ProductStoreViewModel())
    }
}

