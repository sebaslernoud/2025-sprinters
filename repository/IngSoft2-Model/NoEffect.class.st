Class {
	#name : 'NoEffect',
	#superclass : 'Effect',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'playing' }
NoEffect >> affect: aShip in: aGame [

	^ self
]

{ #category : 'test' }
NoEffect >> allowsBattlesOnItsCell [

	^ true
]

{ #category : 'applying' }
NoEffect >> scope [

	^ NoShipsScope new
]
