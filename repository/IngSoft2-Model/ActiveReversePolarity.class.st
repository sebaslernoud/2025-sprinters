Class {
	#name : 'ActiveReversePolarity',
	#superclass : 'ActiveCard',
	#instVars : [
		'cell'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'instance creation' }
ActiveReversePolarity class >> on: aCell [

	^ self new initializeOn: aCell
]

{ #category : 'initialization' }
ActiveReversePolarity >> initializeOn: aCell [

	cell := aCell
]

{ #category : 'querying' }
ActiveReversePolarity >> reversesCell: aCell [

	^ cell = aCell
]
