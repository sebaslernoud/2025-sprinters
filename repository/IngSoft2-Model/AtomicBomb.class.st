Class {
	#name : 'AtomicBomb',
	#superclass : 'Effect',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'playing' }
AtomicBomb >> affect: aShip in: aGame [

	aGame sendToStart: aShip.
	aGame damage: aShip
]

{ #category : 'applying' }
AtomicBomb >> scope [

	^ AllShipsScope new
]
