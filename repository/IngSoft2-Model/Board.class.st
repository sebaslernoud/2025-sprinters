Class {
	#name : 'Board',
	#superclass : 'Object',
	#instVars : [
		'amountOfCells',
		'laps',
		'cells',
		'distance'
	],
	#category : 'IngSoft2-Model',
	#package : 'IngSoft2-Model'
}

{ #category : 'as yet unclassified' }
Board class >> withEffects: effects wormHole: aWorm laps: anAmountOfLaps length: aDistance [

	effects ifEmpty: [
		^ Error signal: 'Amount of cells must be greater than zero' ].
	(aWorm isInside: effects size) ifFalse: [
		^ Error signal:
			  'Position of the worm hole exceed amount board`s cells' ].
	^ self new
		  initializeWithEffects: effects
		  wormHole: aWorm
		  laps: anAmountOfLaps
		  length: aDistance
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

	^ (cells at: position) effect
]

{ #category : 'initialization' }
Board >> initializeWithEffects: effects wormHole: aWorm laps: anAmountOfLaps length: aDistance [

	| effectsWithWormHole |
	effectsWithWormHole := effects asArray copy.
	aWorm positions do: [ :position |
		effectsWithWormHole at: position put: aWorm ].
	cells := effectsWithWormHole collect: [ :effect | Cell with: effect ].
	amountOfCells := cells size.
	laps := anAmountOfLaps.
	distance := aDistance
]

{ #category : 'accessing' }
Board >> laps [

	^ laps
]

{ #category : 'as yet unclassified' }
Board >> move: aDistance ship: aShip [

	| newPosition currentLap position modPosition |
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
