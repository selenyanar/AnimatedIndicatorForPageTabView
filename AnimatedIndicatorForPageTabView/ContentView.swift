//
//  ContentView.swift
//  AnimatedIndicatorForPageTabView
//
//  Created by Selen Yanar on 22.10.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


struct Home: View {
    
    //Colors as tabs...
    //Use your own tabs here...
    var colors : [Color] = [.red, .blue, .pink, .purple]
    
    // Offset...
    @State var offset: CGFloat = 0
    
    var body: some View {
        
        //Tabview has problem in ignoring top view. Fix by using scroll view...
        
        ScrollView(.init()) {
            
            TabView {
                
                ForEach(colors.indices, id: \.self) {index in
                    
                    if index == 0 {
                        colors[index]
                            .overlay(
                                //Geometry reader for getting offset...
                                GeometryReader {proxy -> Color in
                                    
                                    let minX = proxy.frame(in: .global).minX
                                    
                                    
                                    DispatchQueue.main.async {
                                        
                                        withAnimation(.default) {
                                            
                                            self.offset = -minX
                                            
                                        }
                                    }
                                    
                                    return Color.clear
                                }
                                .frame(width: 0, height: 0)
                                , alignment: .leading
                            )
                        
                    }
                    else {
                        colors[index]
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .overlay(
            
                //Animated indicators...
                HStack(spacing: 15) {
                   
                    ForEach(colors.indices, id: \.self) {index in
                        
                        Capsule()
                            .fill(Color.white)
                            .frame(width: getIndex() == index ? 20 : 7, height: 7)
                        
                    }
                }
                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                .padding(.bottom, 10)
                , alignment: .bottom
            )
        }
        .ignoresSafeArea()
    }
    //Getting index...
    func getIndex() -> Int {
        
        let index = Int(round(Double(offset / getWidth())))
        
        return index
    }
}

//Extending view to get width...
extension View {
    
    func getWidth() -> CGFloat {
        
        return UIScreen.main.bounds.width
        
    }
}
