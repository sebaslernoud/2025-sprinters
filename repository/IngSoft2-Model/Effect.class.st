Class {
	#name : 'Effect',
	#superclass : 'Object',
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'playing' }
Effect >> affect: aShip in: aGame [
	self subclassResponsibility .
]

{ #category : 'applying' }
Effect >> effectFor: aShip [

	^ self
]

{ #category : 'applying' }
Effect >> scope [

	^ LandingShipScope new
]
