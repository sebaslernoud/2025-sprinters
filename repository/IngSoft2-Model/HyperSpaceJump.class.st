Class {
	#name : 'HyperSpaceJump',
	#superclass : 'Effect',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'initialization' }
HyperSpaceJump class >> initializeThis [
	^ self new.
]

{ #category : 'playing' }
HyperSpaceJump >> applyTo: aShip in: aGame [

	aGame board move: aShip position + 4 ship: aShip.
	aShip loseShield
]
