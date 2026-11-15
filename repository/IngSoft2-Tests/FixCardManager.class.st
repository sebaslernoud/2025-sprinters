"
Soy un CardManager determinista para los tests, no formo parte del modelo del juego.
Reparto las cartas en el orden en que se agregaron al mazo con addCardsToDeck:.
"
Class {
	#name : 'FixCardManager',
	#superclass : 'CardManager',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'adding' }
FixCardManager >> addCardsToDeck: cards [

	deck addAll: cards
]

{ #category : 'as yet unclassified' }
FixCardManager >> drawCard [

	^ deck removeFirst
]
