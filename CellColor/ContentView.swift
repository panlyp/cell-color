//
//  ContentView.swift
//  CellColor
//
//  Created by Pan on 10/5/2020.
//  Copyright © 2020 Pan. All rights reserved.
//

import SwiftUI

struct ButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .foregroundColor(Color.white)
            .padding(15)
    }
}

struct ColorCellStyle: ViewModifier {
    func body(content: Content) -> some View {
        return content
            .frame(width: 40, height: 40)
    }
}

struct ContentView: View {
    let numOfColors = 4
    @State var colors = [Color]()
    @State var descriptions = [String]()
    @State var chosenColorCode = ""
    @State var showingMessage = false
    
    
    func initialize() -> Void {
        for _ in 0...numOfColors - 1 {
            let color = getRandomColor()
            colors.append(color)
            descriptions.append(getRGB(color: color))
        }
    }
    
    func getRandomColor() -> Color {
        let color = Color(red:    .random(in: 0...1),
                          green:  .random(in: 0...1),
                          blue:   .random(in: 0...1))
        return color
    }
    
    func updateColor(code: String) -> Void {
        for index in 0...numOfColors - 1 {
            if descriptions[index] == chosenColorCode {
                let newColor = getRandomColor()
                colors[index] = newColor
                descriptions[index] = getRGB(color: newColor)
            }
        }
    }
    
    func getRGBA(color: Color) -> String {
        return color.description // eg. #FA198AFF
    }
    
    
    func getRGB(color: Color) -> String {
        let rgbCode = String(getRGBA(color: color).prefix(7)) // eg. #FA198A
        return rgbCode
    }
    
    var body: some View {
        VStack{
            Text("Random Colors").font(.headline)
            HStack {
                ForEach(colors, id: \.self) { color in
                    Rectangle()
                    .foregroundColor(color)
                    .modifier(ColorCellStyle())
                }
            }
            
            Divider()
            
            Text("Buttons").font(.headline)
            VStack {
                ForEach(colors, id: \.self) { color in
                    Button(action: {
                        self.showingMessage.toggle()
                        self.chosenColorCode = self.getRGB(color: color)
                    }) {
                        Text(self.getRGB(color: color))
                        .fixedSize()
                        .padding()
                        .background(color)
                        .cornerRadius(25)
                    }
                    .modifier(ButtonStyle())
                    .alert(isPresented: self.$showingMessage) {
                        Alert(
                            title: Text("Chosen Color"),
                            message: Text("Your chosen color is: \(self.chosenColorCode)"),
                            dismissButton: .default(Text("OK!"), action: {
                                // after dismising the alert, change the color
                                self.updateColor(code: self.chosenColorCode)
                            })
                        )
                    }
                }
            }
        }.onAppear{
            self.initialize()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
