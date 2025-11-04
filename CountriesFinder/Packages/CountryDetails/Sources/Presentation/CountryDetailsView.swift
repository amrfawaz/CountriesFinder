//
//  CountryDetailsView.swift
//  Packages
//
//  Created by Amr Fawaz on 04/11/2025.
//

import Foundation
import SwiftUI
import CoreInterface
import SharedModels

public struct CountryDetailsView<ViewModel: CountryDetailsViewModel>: View {
    @ObservedObject private var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Style.Spacing.md) {
            flag

            Text("Capital: \(viewModel.capital)")

            Text("Currency: \(viewModel.currency)")

            Spacer()
        }
        .padding(.horizontal, Style.Spacing.md)
        .navigationTitle(viewModel.country.name?.name ?? "")
    }

    private var flag: some View {
        LoadedImage(
            viewModel.flag,
            shape: .rounded(cornerRadius: Style.CornerRadius.md),
            contentMode: .fit
        )
        .frame(maxWidth: .infinity)
        .frame(height: 300)
    }
}
