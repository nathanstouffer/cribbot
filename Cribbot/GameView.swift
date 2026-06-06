import SwiftUI

struct GameView: View {

    @ObservedObject private var viewModel: GameViewModel

    @Namespace private var animationNamespace

    init(_ game: GameViewModel) {
        self.viewModel = game
    }

    var body: some View {
        ZStack {
            background
            VStack {
                HandView(
                    cards: $viewModel.computer.hand,
                    mode: $viewModel.computerStaging,
                    isFaceUp: viewModel.stage == .scoringHands,
                    animationNamespace: animationNamespace
                )
                Spacer()
                TrayView(viewModel, animationNamespace: animationNamespace)
                buttons
                ScoreView(computer: viewModel.computer, human: viewModel.human)
                Spacer()
                HandView(
                    cards: $viewModel.human.hand,
                    mode: $viewModel.humanStaging,
                    isFaceUp: true,
                    animationNamespace: animationNamespace
                )
            }
        }
    }

    private var buttons: some View {
        HStack {
            Spacer()
            dealButton
            Spacer()
            throwButton
            Spacer()
            scoreButton
            Spacer()
            resetButton
            Spacer()
        }
        .padding(20)
    }

    private var dealButton: some View {
        Button("Deal") {
            withAnimation {
                viewModel.shuffleAndDeal()
            }
        }
        .buttonStyle(.borderedProminent)
    }

    private var throwButton: some View {
        Button("Throw") {
            if viewModel.stagedForCrib.count == 2 {
                withAnimation {
                    viewModel.throwToCrib()
                }
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.stagedForCrib.count != 2 || viewModel.isCribLocked)
    }

    private var scoreButton: some View {
        Button("Score") {
            if viewModel.isCribLocked {
                withAnimation {
                    viewModel.scoreHands()
                }
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(!viewModel.isCribLocked)
    }

    private var layButton: some View {
        Button("Lay") {
            if viewModel.isCribLocked && viewModel.stagedForLay != nil {
                withAnimation {

                }
            }
        }
        .buttonStyle(.borderedProminent)
        .disabled(viewModel.stagedForLay == nil || !viewModel.isCribLocked)
    }

    private var resetButton: some View {
        Button("Reset") {
            withAnimation {
                viewModel.resetDeck()
            }
        }
        .buttonStyle(.borderedProminent)
    }

    private var background: some View {
        Rectangle()
            .fill(.green)
            .ignoresSafeArea()
    }
}

#Preview {
    GameView(GameViewModel())
}
