Class {
	#name : 'CardGiver',
	#superclass : 'Effect',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'playing' }
CardGiver >> affect: aShip in: aGame [

	aGame giveCardTo: aShip
]
