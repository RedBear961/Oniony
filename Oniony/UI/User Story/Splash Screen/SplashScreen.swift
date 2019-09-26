/*
* Copyright (c) 2019  WebView, Lab
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import SwiftUI

/// Отображения запуска приложения.
public struct SplashScreen: View {
    
    /// Презентер модуля.
    @Environment(\.splashScreenPresenter) private var presenter: SplashScreenPresenter
      
    /// Глобальный отступ сверху.
    @State private var offset: CGFloat = -5
    
    /// Стартовала ли анимация.
    @State private var isStart = false
    
    /// Конечный глобальный отступ сверху.
    private let endOffset: CGFloat = -45

    /// Контент отображения.
    public var body: some View {
        ZStack {
            // Круговой контейнер для полоски прогресса.
            Circle()
                .path(in: CGRect(x: 10, y: 10, width: 110, height: 110))
                .frame(width: 130, height: 130)
                .foregroundColor(.white)
                .shadow(color: Color(white: 0, opacity: 0.2), radius: 6, y: 4)
                .offset(y: endOffset)
                .opacity(isStart ? 1 : 0)
                .animation(Animation.easeInOut(duration: 0.5).delay(1))
          
            // Круглая полоска прогресса.
            Circle()
                .trim(from: 0, to: presenter.progress)
                .rotation(.degrees(270))
                .stroke(lineWidth: 10)
                .foregroundColor(.blue)
                .frame(width: 100, height: 100)
                .offset(y: endOffset)
                .opacity(isStart ? 1 : 0)
                .animation(Animation.easeInOut(duration: 0.5).delay(1))
              
            // Логотип приложения.
            Image(uiImage: Images.app.logo)
                .offset(y: offset)
            
            // Лейбл приложения.
            Text("Oniony")
                .font(.title)
                .offset(y: 71)
                .opacity(isStart ? 0 : 1)
          
            //  Процент загрузки.
            Text(presenter.progress.percent)
                .font(.headline)
                .bold()
                .opacity(isStart ? 1 : 0)
                .offset(y: 40)
                .animation(Animation.easeInOut(duration: 0.5).delay(1))
          
            // Описание статуса загрузки.
            Text(presenter.description)
                .font(.footnote)
                .opacity(isStart ? 1 : 0)
                .offset(y: 65)
                .animation(Animation.easeInOut(duration: 0.5).delay(1))
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                self.offset = self.endOffset
                self.isStart = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.presenter.beginLaunch()
            }
        }
    }
}

#if DEBUG
/// Превью для дебага.
private struct Preview: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
#endif
