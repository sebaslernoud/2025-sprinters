Class {
	#name : 'Teleport',
	#superclass : 'Effect',
	#instVars : [
		'cell'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'accessing' }
Teleport class >> to: aCell [

	^ self new initializeTo: aCell
]

{ #category : 'playing' }
Teleport >> applyTo: aShip in: aGame [

	aGame teleport: aShip to: cell
]

{ #category : 'initialization' }
Teleport >> initializeTo: aCell [

	cell := aCell
]
