/**
 SplashScreen.swift

 Oniony

 Copyright (c) 2019 WebView, Lab. All rights reserved.
*/

import SwiftUI

/// Отображения запуска приложения.
public struct SplashScreen: View {
    
    /// Презентер модуля.
    @ObservedObject public var presenter: SplashScreenPresenter
      
    /// Глобальный отступ сверху.
    @State private var offset = CGFloat()
    
    /// Прозрачность полей прогресса загрузки.
    @State private var progressOpacity = 0.0
    
    /// Прозрачность логотипа.
    @State private var titleOpacity = 1.0
    
    /// Цвет тени обводки прогресса.
    private let shadowColor = Color(white: 0).opacity(0.2)

    public var body: some View {
        let topOffset = UINavigationBar.topOffset / 2
        return ZStack {
            // Круговой контейнер для полоски прогресса.
            Circle()
                .path(in: CGRect(x: 10, y: 10, width: 110, height: 110))
                .frame(width: 130, height: 130)
                .foregroundColor(.white)
                .shadow(color: shadowColor, radius: 6, y: 4)
                .offset(y: offset - topOffset)
                .opacity(progressOpacity)
          
            // Круглая полоска прогресса.
            Circle()
                .trim(from: 0, to: presenter.progress)
                .rotation(.degrees(270))
                .stroke(lineWidth: 10)
                .foregroundColor(.blue)
                .frame(width: 100, height: 100)
                .offset(y: offset - topOffset)
                .opacity(progressOpacity)
              
            // Логотип приложения.
            Image(uiImage: Images.app.logo)
                .offset(y: offset - topOffset)
            
            // Лейбл приложения.
            Text("Oniony")
                .font(.title)
                .offset(y: topOffset + 21.5)
                .opacity(titleOpacity)
          
            //  Процент загрузки.
            Text("\(Int(presenter.progress * 100))%")
                .font(.headline)
                .bold()
                .opacity(progressOpacity)
                .offset(y: topOffset - 10)
          
            // Описание статуса загрузки.
            Text(presenter.description)
                .font(.footnote)
                .opacity(progressOpacity)
                .offset(y: topOffset + 20)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                self.offset = -40
                self.titleOpacity = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.progressOpacity = 1
                }
            }
        }
    }
}

/// Превью для дебага.
private struct Preview: PreviewProvider {
    static var previews: some View {
        SplashScreen(presenter: SplashScreenPresenter())
    }
}
