import SwiftUI

struct ContentView: View {
    @State private var gameStarted = false

    var body: some View {
        if gameStarted {
            GameView(onQuit: { gameStarted = false })
        } else {
            MenuView(onStart: { gameStarted = true })
        }
    }
}

struct MenuView: View {
    let onStart: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 40) {
                Text("ColorTap")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Tap the squares to cycle their colour.\nMake them all match the target!")
                    .font(.system(size: 18, design: .rounded))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button(action: onStart) {
                    Text("Play")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .frame(width: 160, height: 56)
                        .background(Color.white)
                        .cornerRadius(16)
                }
            }
        }
    }
}
