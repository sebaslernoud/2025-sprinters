Class {
	#name : 'EffectManager',
	#superclass : 'Object',
	#instVars : [
		'lastRealEffect'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'accessing' }
EffectManager class >> creation [

	^ self new initialization
]

{ #category : 'as yet unclassified' }
EffectManager >> apply: anEffect to: aShip in: aGame [

	anEffect isCardGiver ifTrue: [
		aGame giveCardTo: aShip.
		^ self ].
	anEffect applyTo: aShip in: aGame.
	self registerEffect: anEffect
]

{ #category : 'initialization' }
EffectManager >> initialization [

	lastRealEffect := NoEffect new
]

{ #category : 'accessing' }
EffectManager >> lastRealEffect [

	^ lastRealEffect
]

{ #category : 'as yet unclassified' }
EffectManager >> registerEffect: anEffect [

	lastRealEffect := anEffect
]
