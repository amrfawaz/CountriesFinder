//
//  HomeView.swift
//  Packages
//
//  Created by Amr Fawaz on 01/11/2025.
//

import Foundation
import SwiftUI
import SharedModels

struct HomeView<ViewModel: HomeViewModel>: View {
    @ObservedObject private var viewModel: ViewModel

    private let navigator: HomeNavigationProtocol

    init(
        viewModel: ViewModel,
        navigator: HomeNavigationProtocol
    ) {
        self.viewModel = viewModel
        self.navigator = navigator
    }

    var body: some View {
        NavigationStack {
            
            List(viewModel.filteredCountries) { item in
                HStack {
                    if let flag = item.flags?.png {
                        LoadedImage(flag)
                            .frame(width: 30, height: 30)

                    }
                    
                    Text(item.name?.name ?? "")
                    Spacer()
                }
                .onTapGesture {
                    navigator.showCountryDetail(item)
                }

            }
            .listStyle(.insetGrouped)
            .navigationTitle("Countries")
            .searchable(text: $viewModel.searchText, prompt: "Search Countries")
        }
        .onAppear{
            Task {
                await viewModel.fetchCountries()
            }
        }
    }

}
