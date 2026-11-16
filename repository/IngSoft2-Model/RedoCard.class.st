Class {
	#name : 'RedoCard',
	#superclass : 'Card',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'playing' }
RedoCard >> applyTo: aShip using: aShip2 in: aGame [

	aGame cardManager applyRedoEffectOn: aShip in: aGame
]

{ #category : 'testing' }
RedoCard >> isRedo [

	^ true
]
