Class {
	#name : 'FixedHyperJump',
	#superclass : 'Effect',
	#instVars : [
		'distance'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
FixedHyperJump class >> of: aDistance [

	^ self new initializeOf: aDistance
]

{ #category : 'playing' }
FixedHyperJump >> affect: aShip in: aGame [

	aGame move: aShip by: (aGame cellsIn: distance)
]

{ #category : 'initialization' }
FixedHyperJump >> initializeOf: aDistance [

	distance := aDistance
]
