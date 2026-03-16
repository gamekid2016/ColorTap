import SwiftUI

struct GameView: View {
    @StateObject private var vm = GameViewModel()
    let onQuit: () -> Void

    private let columns = 5
    private let spacing: CGFloat = 8
    private let cornerRadius: CGFloat = 10

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 20) {
                HStack {
                    Button(action: onQuit) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .semibold))
                    }
                    Spacer()
                    Text("Moves: \(vm.moveCount)")
                        .foregroundColor(.gray)
                        .font(.system(size: 16, design: .rounded))
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                HStack(spacing: 12) {
                    Text("Target:")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(vm.target.color)
                        .frame(width: 40, height: 40)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.4), lineWidth: 2)
                        )
                    Text(vm.target.name)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .foregroundColor(vm.target.color)
                }

                GeometryReader { geo in
                    let totalSpacing = spacing * CGFloat(columns - 1) + 32
                    let tileSize = (geo.size.width - totalSpacing) / CGFloat(columns)

                    VStack(spacing: spacing) {
                        ForEach(0 ..< vm.rows, id: \.self) { row in
                            HStack(spacing: spacing) {
                                ForEach(0 ..< columns, id: \.self) { col in
                                    let index = row * columns + col
                                    TileView(
                                        color: vm.tiles[index].color,
                                        size: tileSize,
                                        cornerRadius: cornerRadius
                                    )
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.15)) {
                                            vm.tap(index: index)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                Spacer()
            }

            if vm.isWon {
                WinOverlay(moveCount: vm.moveCount, onPlayAgain: {
                    vm.newGame()
                }, onQuit: onQuit)
                .transition(.opacity)
                .animation(.easeIn(duration: 0.3), value: vm.isWon)
            }
        }
    }
}

struct TileView: View {
    let color: Color
    let size: CGFloat
    let cornerRadius: CGFloat

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(color)
            .frame(width: size, height: size)
            .shadow(color: color.opacity(0.5), radius: 4, x: 0, y: 2)
    }
}

struct WinOverlay: View {
    let moveCount: Int
    let onPlayAgain: () -> Void
    let onQuit: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.85).ignoresSafeArea()
            VStack(spacing: 28) {
                Text("You Won!")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Completed in \(moveCount) moves")
                    .font(.system(size: 20, design: .rounded))
                    .foregroundColor(.gray)

                HStack(spacing: 16) {
                    Button(action: onPlayAgain) {
                        Text("Play Again")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                            .frame(width: 140, height: 50)
                            .background(Color.white)
                            .cornerRadius(14)
                    }
                    Button(action: onQuit) {
                        Text("Menu")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(width: 100, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                }
            }
        }
    }
}
