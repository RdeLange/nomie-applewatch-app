//
//  ConnectErrorModal.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 13/10/2022.
//

import SwiftUI

struct ConnectErrorModal: View {
    @Binding var isPresented: Bool
        
        var body: some View {
            VStack {
                Image(systemName: "app.connected.to.app.below.fill")
                    .font(.system(size: 30))

                Text("Connection with API Server was not successful.")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                Button("OK") {
                    isPresented.toggle()
                }.padding(.horizontal)
            }
            .opacity(0.8)
            .padding(10)

            Spacer()

            
        }
    }

    struct TestViewConnectErrorModal: View {
        @State private var isPresentingModalView = false
        
        var body: some View {
            Button("Connect") {
                isPresentingModalView.toggle()
            }
            .fullScreenCover(isPresented: $isPresentingModalView) {
                ConnectErrorModal(isPresented: $isPresentingModalView)
            }
        }
    }

    struct TestViewConnectErrorModal_Previews: PreviewProvider {
        static var previews: some View {
            TestViewConnectErrorModal()
        }
    }
