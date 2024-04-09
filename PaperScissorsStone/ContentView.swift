//
//  ContentView.swift
//  PaperScissorsStone
//
//  Created by Sam Lee iMac24 on 2024/4/9.
//

import SwiftUI

enum Moves: String, CaseIterable {
    case rock = "✊"
    case paper = "✋"
    case scissor = "✌️"
}

enum Result: String {
    case userWin
    case userLose
    case tie
}

struct ContentView: View {
    
    private var currentMove: Moves {
        return moves.randomElement()!
    }
    @State private var __result: Result? = nil {
        didSet {
            if let __result = __result {
                result = __result
            } else {
                result = .tie
            }
        }
    }
    @State private var lastMoves: (userMove: Moves, computerMove: Moves) = (.rock,.rock)
    @State private var result: Result = .tie
    @State private var score: Int = 0
    @State private var rounds: Int = 0
    @State private var showAlert: Bool = false
    @State private var showResetAlert: Bool = false
    
    private var moves = Moves.allCases
    
    var body: some View {
        ScrollView {
            VStack {
                Button("✌️") {
                    getResult(.scissor)
                }
                Button("✊") {
                    getResult(.rock)
                }
                Button("✋") {
                    getResult(.paper)
                }
            }
            .font(.system(size: 100))
            
            VStack {
                Text("score: \(score)")
                Text("rounds: \(rounds)")
                Text("result: \(__result?.rawValue ?? "--")")
            }
            .font(.title)
            
            .alert("結果", isPresented: $showAlert) {
                Button("OK") {
                    showAlert = false
                    checkIfCanEndGame()
                }
            } message: {
                getAlertMessage()
            }
            
            .alert("已結束遊戲", isPresented: $showResetAlert) {
                Button("OK") {
                    showResetAlert = false
                }
            }
        }
    }
    
    private func getResult(_ userMove: Moves) {
        let currentMove = currentMove
        switch (userMove,currentMove) {
        case (.scissor,.rock):
            __result = .userLose
        case (.scissor,.scissor):
            __result = .tie
        case (.scissor,.paper):
            __result = .userWin
        case (.rock,.rock):
            __result = .tie
        case (.rock,.scissor):
            __result = .userWin
        case (.rock,.paper):
            __result = .userLose
        case (.paper,.rock):
            __result = .userWin
        case (.paper,.scissor):
            __result = .userLose
        case (.paper,.paper):
            __result = .tie
        }
        calculateRoundAndScore()
        lastMoves = (userMove,currentMove)
        showAlert = true
    }
    
    private func calculateRoundAndScore() {
        switch result {
        case .userWin:
            score += 1
            rounds += 1
        case .userLose:
            score -= 1
            if score < 0 {
                score = 0
            }
            rounds += 1
        case .tie:
            rounds += 1
        }
    }
    
    private func getAlertMessage() -> some View {
        switch result {
        case .userWin:
            return Text("你贏了!!!\n電腦:\(lastMoves.computerMove.rawValue)\n您:\(lastMoves.userMove.rawValue)")
        case .userLose:
            return Text("你輸了!!!\n電腦:\(lastMoves.computerMove.rawValue)\n您:\(lastMoves.userMove.rawValue)")
        case .tie:
            return Text("平手!!!")
        }
    }
    
    private func checkIfCanEndGame() {
        if rounds == 2 {
            score = 0
            rounds = 0
            __result = nil
            showResetAlert = true
        }
    }
}

#Preview {
    ContentView()
}
