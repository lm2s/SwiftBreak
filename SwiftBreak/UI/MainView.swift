//
//  MainView.swift
//  SwiftBreak
//
//  Created by Luís Silva on 23/11/2020.
//

import SwiftUI
import Combine

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        HStack {
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Image("SwiftBreak512px-no-edge_space")
                        .resizable()
                        .frame(width: 120, height: 120, alignment: .center)
                }

                VStack(alignment: .center, spacing: 5) {
                    Text("SwiftBreak")
                        .font(Font.system(size: 20, weight: .light, design: .monospaced))

                    Text("Version \(viewModel.appVersion)")
                        .font(Font.system(size: 12, weight: .light, design: .default))
                }

                Spacer()
            }
            .frame(width: 200, height: nil, alignment: .center)

            VStack(alignment: HorizontalAlignment.leading, spacing: nil) {
                Group {
                    Text("Indentation:")

                    Toggle(
                        "Automatically detect indentation style",
                        isOn: $viewModel.automaticallyDetectIndentationStyle
                    )
                }

                Text(" ") // 1 line spacer

                Group {
                    Text("Displayed errors:")

                    Toggle(
                        "Missing parameters",
                        isOn: $viewModel.displayMissingParametersError
                    )

                    Toggle(
                        "Missing parentheses",
                        isOn: $viewModel.displayMissingParenthesesError
                    )

                    Toggle(
                        "Other",
                        isOn: $viewModel.displayOtherErrors
                    )
                }

                Spacer()

            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))

            Spacer()

        }.padding(EdgeInsets(top: 30, leading: 20, bottom: 50, trailing: 20))
    }
}
