//
//  ContentView.swift
//  RockPaperScissorsChallengeSwiftUI
//
//  Created by Jules Lee on 12/31/19.
//  Copyright © 2019 Jules Lee. All rights reserved.
//

import SwiftUI

enum RPS: String, CaseIterable, Identifiable {
    var id: UUID {
        return UUID()
    }
    case Scissors = "Scissors"
    case Rock = "Rock"
    case Paper = "Paper"
    
    static func shuffle() -> [RPS] {
        var list = RPS.allCases
        let last = list.popLast()!
        list.insert(last, at: 0)
        return list
    }
}

struct ContentView: View {
    @State private var points = 0
    @State private var level = 0
    @State private var protagonist = RPS.allCases.shuffled()[0]
    @State private var antagonist = RPS.allCases.shuffled()[0]
    @State private var showAlert = false
    @State private var won = false
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Stats")) {
                    Text("Level: \(level)")
                    Text("Your points is \(points)")
                }

                Section(header: Text("Choose")) {
                    ForEach(RPS.allCases) { choice in
                        Button(action: {
                            self.protagonist = choice
                            self.next()
                        }) {
                            Text(choice.rawValue)
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) { () -> Alert in
            Alert(title: Text("\(won ? "You win!" : "You lose!")"), message: Text("Your \(protagonist.rawValue) against \(antagonist.rawValue)"), dismissButton: .default(Text("Next")) {
                self.showAlert = false
                }
            )
        }
    }
    
    func next() {
        if level == 10 {
            points = 0
            level = 0
        }
        level += 1
        winOrLose()
        antagonist = RPS.allCases.shuffled()[0]
        
    }
    
    func winOrLose() {
        var rpsList = RPS.allCases
        if (isFirst(protagonist) || isFirst(antagonist)) && (isLast(protagonist) || isLast(antagonist)) {
            rpsList = RPS.shuffle()
        }
        if rpsList.firstIndex(of: protagonist)! > rpsList.firstIndex(of: antagonist)! {
            points += 1
            won = true
        } else {
            won = false
        }
        showAlert = true
    }
    
    func isFirst(_ rps: RPS) -> Bool {
        return RPS.allCases.firstIndex(of: rps) == 0
    }
    
    func isLast(_ rps: RPS) -> Bool {
        return RPS.allCases.firstIndex(of: rps) == 2
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus")).previewDisplayName("iPhone 8 Plus")
    }
}
