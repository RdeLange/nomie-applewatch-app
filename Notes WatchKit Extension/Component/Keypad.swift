//
//  Keypad.swift
//  Notes WatchKit Extension
//
//  Created by Ronald De Lange on 03/10/2022.
//
import SwiftUI

struct Keypad: View {
    @Binding var keypadtext: String
    var body: some View {
        VStack {
            //Text(keypadtext).frame(height: 14.0)
            LazyVGrid(columns: [GridItem(.flexible(minimum:30,maximum:40)), GridItem(.flexible(minimum:30,maximum:40)), GridItem(.flexible(minimum:30,maximum:40)),GridItem(.flexible(minimum:30,maximum:40))],alignment: .center, spacing: nil, pinnedViews: [], content: {
                ForEach(0..<10) { item in
                    Button(action: {
                        keypadtext.append("\(item)")
                        print(keypadtext)
                    }, label: {
                        ZStack {
                            
                            Text("\(item)")
                                .font(.headline)
                        }
                    }).buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 2)
                        .padding(.vertical, 1)
                        .frame(width: 35, height: 20.0)
                        .background(
                               Color.accentColor
                                  .cornerRadius( 5.0))
                    
                }
                Button(action: {
                    print("S")
                }, label: {
                    ZStack {
                        
                        Text(",")
                            .font(.headline)
                    }
                }).buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 2)
                    .padding(.vertical, 1)
                    .frame(width: 35, height: 20.0)
                    .background(
                           Color.accentColor
                              .cornerRadius( 5.0))
                Button(action: {
                    if (keypadtext.count > 0) {
                        keypadtext.remove(at: keypadtext.index(before: keypadtext.endIndex))
                        print(keypadtext)
                        
                    }}, label: {
                    ZStack {
                        
                        Text("🔙")
                            .font(.headline)
                    }
                }).buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 2)
                    .padding(.vertical, 1)
                    .frame(width: 35, height: 20.0)
                    .background(
                           Color.accentColor
                              .cornerRadius( 5.0))
            })
        }
        
    }
}

// MARK: - PREVIEW

struct Keypad_Previews: PreviewProvider {
    @State private var input: String = "2"
    static var previews: some View {
        Keypad(keypadtext:.constant("2"))
        
    }
}
