Class {
	#name : 'Board',
	#superclass : 'Object',
	#instVars : [
		'amountOfCells',
		'wormHole',
		'laps',
		'cells',
		'totalParsecs',
		'distance'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Board class >> with: aAmountOfCells and: aWormHole has: aDistribution basedOn: aDistance [

	aAmountOfCells isInteger ifFalse: [
		^ Error signal: 'Amount of cells must be an integer' ].
	aAmountOfCells < 1 ifTrue: [
		^ Error signal: 'Amount of cells must be greater than zero' ].
	(aWormHole isInside: aAmountOfCells) ifFalse: [
		^ Error signal:
			  'Position of the worm hole exceed amount board`s cells' ].
	^ self new
		  initializeWith: aAmountOfCells
		  and: aWormHole
		  has: aDistribution
		  basedOn: aDistance
]

{ #category : 'accessing' }
Board >> amountOfCells [

	^ amountOfCells
]

{ #category : 'convertion' }
Board >> amountOfCellsOf: anEffectOrClass [

	^ cells count: [ :cell | cell effect className = anEffectOrClass ]
]

{ #category : 'as yet unclassified' }
Board >> calculatePositionByParsecs: parsecs [

	| parsecsInCell newPosition |
	parsecsInCell := self parsecsPerCell.
	newPosition := (parsecs / parsecsInCell) ceiling.
	^ newPosition
]

{ #category : 'playing' }
Board >> effectOnPosition: position [

	(wormHole positions anySatisfy: [ :cell | cell = position ]) ifTrue: [
		^ wormHole ].
	^ (cells at: position) effect value
]

{ #category : 'initialization' }
Board >> initializeWith: aAmountOfCells and: aWormHole has: distributions basedOn: aDistance [

	| cell aDistributor effectsOnCells |
	amountOfCells := aAmountOfCells.
	wormHole := aWormHole.
	laps := 1.
	distance := aDistance.
	aDistributor := EffectDistributor
		                withDistribution: distributions
		                on: aAmountOfCells.

	effectsOnCells := aDistributor recieveAmountOfEffects.
	cells := OrderedCollection new.
	1 to: amountOfCells do: [ :i |
		cell := Cell new.
		cell position: i.
		cell effect: (effectsOnCells at: i).
		cells add: cell ]
]

{ #category : 'accessing' }
Board >> laps [

	^ laps
]

{ #category : 'as yet unclassified' }
Board >> move: aDistance ship: aShip [

	| parsecsInCell currentParsec newParsecPos newPosition currentLap position modPosition |
	newPosition := aDistance <= 0
		               ifTrue: [ 1 ]
		               ifFalse: [ aDistance ].

	currentLap := self moveThrowTheLaps: aShip laps this: newPosition.

	position := laps > 1
		            ifTrue: [
			            modPosition := newPosition \\ amountOfCells.
			            modPosition = 0
				            ifTrue: [ amountOfCells ]
				            ifFalse: [ modPosition ] ]
		            ifFalse: [ (newPosition max: 1) min: amountOfCells ].

	aShip updatePosition: position andLap: currentLap
]

{ #category : 'playing' }
Board >> moveThrowTheLaps: currentLap this: position [

	| lapValue |
	lapValue := currentLap + (position // amountOfCells).
	lapValue <= 0 ifTrue: [
		^ Error signal: 'Current lap cannot be negative' ].
	^ lapValue
]

{ #category : 'convertion' }
Board >> parsecsPerCell [

	^ distance parsecs / amountOfCells
]

{ #category : 'instance creation' }
Board >> with: aNumberOfLaps [

	laps := aNumberOfLaps
]

{ #category : 'accessing' }
Board >> wormHole [

	^ wormHole
]
