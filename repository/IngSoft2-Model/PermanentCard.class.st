Class {
	#name : 'PermanentCard',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
PermanentCard >> activeCardBy: aShip targeting: aTarget in: aGame [

	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
PermanentCard >> applyBy: aShip targeting: aTarget in: aGame [

	aGame activate: (self activeCardBy: aShip targeting: aTarget in: aGame)
]

{ #category : 'as yet unclassified' }
PermanentCard >> validatePlayBy: aShip in: aGame [

	aGame validateTurnOf: aShip
]
