Class {
	#name : 'ActiveMercenary',
	#superclass : 'ActiveCard',
	#instVars : [
		'hirer',
		'mercenary'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
ActiveMercenary class >> hiredBy: aShip mercenary: anotherShip [

	^ self new initializeHiredBy: aShip mercenary: anotherShip
]

{ #category : 'testing' }
ActiveMercenary >> hasHired: aShip [

	^ mercenary == aShip
]

{ #category : 'initialization' }
ActiveMercenary >> initializeHiredBy: aShip mercenary: anotherShip [

	hirer := aShip.
	mercenary := anotherShip
]

{ #category : 'as yet unclassified' }
ActiveMercenary >> mercenariesOf: aShip [

	^ aShip == hirer
		  ifTrue: [ { mercenary } ]
		  ifFalse: [ #(  ) ]
]
