/**
 SplashScreen.swift

 Oniony

 Copyright (c) 2019 WebView, Lab. All rights reserved.
*/

import SwiftUI

/// Отображения запуска приложения.
public struct SplashScreen: View {
    
    public var body: some View {
        Text("Hello World!")
    }
}

/// Превью для дебага.
private struct Preview: PreviewProvider {
    
    static var previews: some View {
        SplashScreen()
    }
}
