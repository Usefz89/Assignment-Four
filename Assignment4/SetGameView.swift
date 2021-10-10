//
//  SetGameView.swift
//  Set-Assignment3
//
//  Created by yousef zuriqi on 02/10/2021.
//

import SwiftUI

struct SetGameView: View {
    
    @ObservedObject var game: SetGameMode
    @State private var discarded = Set<Int>()
    @State private var isFaceUp = false
    
    var body: some View {
        ZStack {
            Image("green")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack {
                gameBody
                HStack {
                    discardedCardsBody
                    Spacer()
                    deckBody
                }
                .padding()
                buttons
            }
        }
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cardsOnScreen, aspectRatio: Constants.aspectRatio) { card  in
            CardView(card: card)
                .padding(5)
                .foregroundColor( game.colorOfShape(card: card))
                .onTapGesture {
                    game.choose(card: card)
            }
        }
        .padding()
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards) { card in
                if isFaceUp {
                    CardView(card: card)
                } else {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius).fill(Color.yellow)
                }
            }
        }
        .frame(width: Constants.deckWidth , height: Constants.deckHeight)
    }
    
    var discardedCardsBody: some View {
        ZStack {
            ForEach(game.discardedCards) { card in
                CardView(card: card)
            }
        }
        .frame(width: Constants.deckWidth, height: Constants.deckHeight)
    }
    
    var buttons: some View {
        HStack {
            Button(action: {game.dealCards()}) {
                Text("DEAL CARDS")
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    
            }
            .disabled(game.cards.isEmpty)
            Button(action: {game.newGame()}) {
                Text("NEW GAME")
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
    }
    
    struct Constants {
        static let aspectRatio: CGFloat = 2/3
        static let deckHeight: CGFloat = 90
        static let deckWidth: CGFloat = deckHeight * aspectRatio
        static var cornerRadius: CGFloat = CardView.Constants.cornerRadius

    }
}

struct CardView: View {
    
    let card: SetGame.Card
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .fill()
                    .foregroundColor(.white)
                    
                RoundedRectangle(cornerRadius: Constants.cornerRadius)
                    .stroke(lineWidth: card.isSelected ? Constants.selectedLineWidth : 1 )
                    .foregroundColor(getBorderColor(of: card))
                    .shadow(color: .clear, radius: 3)
               

                getCardContent(in: geometry.size, from: card)
            }
        }
    }

    func getBorderColor(of card: SetGame.Card) -> Color {
        switch card.matchingStatus {
        case .notChecked: return Color.yellow
        case .checkedNotMatched: return Color.red
        case .checkedMatched: return Color.green
            
        }
    }
 
    @ViewBuilder
    func getCardContent(in size: CGSize, from card: SetGame.Card) -> some View {
        VStack {
            ForEach(0..<card.cardContent.numberOfShapes.rawValue, id: \.self) { _ in
                switch card.cardContent.shape {
                case .oval :
                    ZStack {
                        RoundedRectangle(cornerRadius: min(size.width, size.height) / 2)
                            .stroke(lineWidth: Constants.lineWidth)
                            .frameThatFits(in: size)
                        RoundedRectangle(cornerRadius: min(size.width, size.height) / 2)
                            .frameThatFits(in: size)
                            .opacity(card.cardContent.opacityOfShape.rawValue)
                    }
                    
                case .rectangle:
                    ZStack {
                        Rectangle()
                            .stroke(lineWidth: Constants.lineWidth)
                            .frameThatFits(in: size)
                            

                        Rectangle()
                            .frameThatFits(in: size)
                            .opacity(card.cardContent.opacityOfShape.rawValue)
                    }
                    
                case .diamond:
                    ZStack {
                        Diamond()
                            .stroke(lineWidth: Constants.lineWidth)
                            .frameThatFits(in: size)
                         

                        Diamond()
                            .frameThatFits(in: size)
                            .opacity(card.cardContent.opacityOfShape.rawValue)
                    }
                }
            }
        }
    }
   
    struct Constants {
        static var cornerRadius: CGFloat = 10
        static let lineWidth: CGFloat = 1.5
        static let selectedLineWidth: CGFloat = 5
        static let notSelectedLineWidth: CGFloat = 1

    }
}







struct SetGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameMode()
        SetGameView(game: game)
    }
}


