Class {
	#name : 'Card',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Card >> applyBy: aShip targeting: aTarget in: aGame [

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
Card >> playBy: aShip targeting: aTarget in: aGame [

	self validatePlayBy: aShip in: aGame.
	self applyBy: aShip targeting: aTarget in: aGame
]

{ #category : 'as yet unclassified' }
Card >> registerIn: aCardManager [

	aCardManager registerPlayed: self
]

{ #category : 'as yet unclassified' }
Card >> validatePlayBy: aShip in: aGame [

	self subclassResponsibility
]
