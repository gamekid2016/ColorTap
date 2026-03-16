import SwiftUI
import Combine

enum TileColor: Int, CaseIterable {
    case red, blue, green, yellow

    var color: Color {
        switch self {
        case .red:    return Color(red: 0.92, green: 0.26, blue: 0.26)
        case .blue:   return Color(red: 0.26, green: 0.53, blue: 0.96)
        case .green:  return Color(red: 0.20, green: 0.78, blue: 0.35)
        case .yellow: return Color(red: 0.99, green: 0.84, blue: 0.15)
        }
    }

    var name: String {
        switch self {
        case .red:    return "Red"
        case .blue:   return "Blue"
        case .green:  return "Green"
        case .yellow: return "Yellow"
        }
    }

    func next() -> TileColor {
        let all = TileColor.allCases
        let nextIndex = (self.rawValue + 1) % all.count
        return all[nextIndex]
    }
}

class GameViewModel: ObservableObject {
    let columns = 5
    let rows = 6

    @Published var tiles: [TileColor] = []
    @Published var target: TileColor = .red
    @Published var isWon: Bool = false
    @Published var moveCount: Int = 0

    init() {
        newGame()
    }

    func newGame() {
        isWon = false
        moveCount = 0
        target = TileColor.allCases.randomElement() ?? .red
        repeat {
            tiles = (0 ..< columns * rows).map { _ in
                TileColor.allCases.randomElement() ?? .red
            }
        } while allMatch()
    }

    func tap(index: Int) {
        guard !isWon else { return }
        tiles[index] = tiles[index].next()
        moveCount += 1
        if allMatch() {
            isWon = true
        }
    }

    private func allMatch() -> Bool {
        tiles.allSatisfy { $0 == target }
    }
}
