Class {
	#name : 'BoardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
BoardTest >> test000WhenCreateBoardWithAmountOfCellsThenShowAmountOfCells [

	| aBoard amountOfCells aWorm distributions |
	amountOfCells := 10.
	aWorm := Worm with: 4 and: 6.

	distributions := OrderedCollection new.
	distributions add: (Distribution at: NoEffect with: 1).

	aBoard := Board
		          with: amountOfCells
		          and: aWorm
		          has: distributions
		          basedOn: (Distance parsecs: 200).
	self assert: aBoard amountOfCells equals: amountOfCells
]

{ #category : 'tests' }
BoardTest >> test001WhenPlayGameThenReturnGameOver [

	| aBoard amountOfCells aWorm aX aY distributions |
	amountOfCells := 10.
	aX := 4.
	aY := 6.
	aWorm := Worm with: aX and: aY.

	distributions := OrderedCollection new.
	distributions add: (Distribution at: NoEffect with: 1).

	aBoard := Board
		          with: amountOfCells
		          and: aWorm
		          has: distributions
		          basedOn: (Distance parsecs: 20).
	self assert: aBoard wormHole positions equals: {
			aX.
			aY }
]

{ #category : 'tests' }
BoardTest >> test002WhenCreateBoardWithWrongWormHolePostionThenReturnsError [

	| amountOfCells aWorm distributions |
	amountOfCells := 10.
	aWorm := Worm with: 4 and: 11.
	distributions := OrderedCollection new.
	distributions add: (Distribution at: NoEffect with: 1).
	self
		should: [
			Board
				with: amountOfCells
				and: aWorm
				has: distributions
				basedOn: (Distance parsecs: 20) ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'Position of the worm hole exceed amount board`s cells' ]
]

{ #category : 'tests' }
BoardTest >> test003WhenCreateBoardWithCellsLessThan1ThenReturnsError [

	| amountOfCells aWorm distributions |
	amountOfCells := 0.
	aWorm := Worm with: 4 and: 11.
	distributions := OrderedCollection new.
	distributions add: (Distribution at: NoEffect with: 1).
	self
		should: [
			Board
				with: amountOfCells
				and: aWorm
				has: distributions
				basedOn: (Distance parsecs: 20) ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'Amount of cells must be greater than zero' ]
]

{ #category : 'tests' }
BoardTest >> test004WhenCreateBoardWithCellsNotIntegerThenReturnsError [

	| amountOfCells aWorm distributions |
	amountOfCells := 3.14.
	aWorm := Worm with: 4 and: 11.
	distributions := OrderedCollection new.
	distributions add: (Distribution at: NoEffect with: 1).
	self
		should: [
			Board
				with: amountOfCells
		          and: aWorm
		          has: distributions
		          basedOn: (Distance parsecs: 20). ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'Amount of cells must be an integer' ]
]

{ #category : 'tests' }
BoardTest >> test005WhenShipMovesToWormholeThenBoardKnowsThePositionOfShip [

	| amountOfCells aX aY aWorm aBoard distributions aLoadedDice aDiceBucket ships cardManager aGame dices |
	amountOfCells := 10.
	aX := 4.
	aY := 7.
	aWorm := Worm with: aX and: aY.
	distributions := OrderedCollection new.
	distributions add: (Distribution at: NoEffect with: 1).
	aBoard := Board
		          with: amountOfCells
		          and: aWorm
		          has: distributions
		          basedOn: (Distance parsecs: 20).
	aLoadedDice := LoadedDice withSequence: #( 6 ).
	dices := OrderedCollection new.
	dices add: aLoadedDice.
	aDiceBucket := DiceBucket with: dices.
	ships := OrderedCollection new.
	ships add: 'ship 1'.
	cardManager := CardManager creation.
	aGame := Game
		         with: aBoard
		         using: aDiceBucket
		         andShipsNamed: ships
		         until: 1
		         cardManager: cardManager.
	aGame playTurn.
	self assert: (aGame findShipBy: 'ship 1') position equals: 4
]

{ #category : 'tests' }
BoardTest >> test006WhenShipMoveMoreThanCellsInTheBoardThenPositionIsAmountOfCells [

	| amountOfCells aX aY aWorm aBoard aShip loadedDice distributions |
	amountOfCells := 4.
	aX := 1.
	aY := 2.
	aWorm := Worm with: aX and: aY.
	distributions := OrderedCollection new.
	distributions add: (Distribution at: NoEffect with: 1).
	aBoard := Board
		          with: amountOfCells
		          and: aWorm
		          has: distributions
		          basedOn: (Distance parsecs: 20).
	loadedDice := LoadedDice withSequence: #( 6 ).
	aShip := Ship create: 'ship1'.
	aShip move: loadedDice throw in: aBoard.
	self assert: aShip position equals: 4
]

{ #category : 'tests' }
BoardTest >> test007WhenGivenDistributionToABoardThenAllAddUpToTheExacAmountOfCells [

	| amountOfCells aX aY aWorm aBoard distributions total |
	amountOfCells := 5.
	"El numero de celdas por ahora esta logicamente implementado para que sea siempre un entero, un par"
	aX := 1.
	aY := 2.
	aWorm := Worm with: aX and: aY.

	distributions := OrderedCollection new.
	distributions add: (Distribution at: NoEffect with: 0.4).
	distributions add: (Distribution at: BlackHole with: 0.6).

	aBoard := Board
		          with: amountOfCells
		          and: aWorm
		          has: distributions
		          basedOn: (Distance parsecs: 100).
	total := (aBoard amountOfCellsOf: 'NoEffect')
	         + (aBoard amountOfCellsOf:'BlackHole').
	self assert: total equals: amountOfCells
]

{ #category : 'tests' }
BoardTest >> test008WhenAskForEffectOnPositionThenBoardReturnItEffect [

	| amountOfCells aX aY aWorm aBoard distributions effect |
	amountOfCells := 4.
	"El numero de celdas por ahora esta logicamente implementado para que sea siempre un entero, un par"
	aX := 1.
	aY := 2.
	aWorm := Worm with: aX and: aY.

	distributions := OrderedCollection new.
	distributions add: (Distribution at: BlackHole with: 1).

	aBoard := Board
		          with: amountOfCells
		          and: aWorm
		          has: distributions
		          basedOn: (Distance parsecs: 100).
	effect := aBoard effectOnPosition: 3.
	self assert: effect className equals: 'BlackHole'
]

{ #category : 'tests' }
BoardTest >> test009WhenGivenDistributionToABoardThenAllAddUpToTheExactAmountOfCellsAs4 [

	| amountOfCells aX aY aWorm aBoard distributions total |
	amountOfCells := 2.
	"El numero de celdas por ahora esta logicamente implementado para que sea siempre un entero, un par"
	aX := 1.
	aY := 2.
	aWorm := Worm with: aX and: aY.

	distributions := OrderedCollection new.
	distributions add: (Distribution at: NoEffect with: 0.4).
	distributions add: (Distribution at: BlackHole with: 0.6).

	aBoard := Board
		          with: amountOfCells
		          and: aWorm
		          has: distributions
		          basedOn: (Distance parsecs: 1).
	total := (aBoard amountOfCellsOf: 'NoEffect')
	         + (aBoard amountOfCellsOf: 'BlackHole').
	self assert: total equals: amountOfCells
]

{ #category : 'tests' }
BoardTest >> test010WhenCreateBoardWithDistributionsThenEffectsOFCellsISNoEFfect [

	| amountOfCells aX aY aWorm aBoard distributions |
	amountOfCells := 4.
	"El numero de celdas por ahora esta logicamente implementado para que sea siempre un entero, un par"
	aX := 1.
	aY := 2.
	aWorm := Worm with: aX and: aY.

	distributions := OrderedCollection new.
	distributions add: (Distribution at: NoEffect with: 1).

	aBoard := Board
		          with: amountOfCells
		          and: aWorm
		          has: distributions
		          basedOn: (Distance parsecs: 20).
	self
		assert: (aBoard effectOnPosition: 3) className
		equals: 'NoEffect'
]

{ #category : 'tests' }
BoardTest >> test011WhenBoardIsCreatedThenEffectsAreDistributedAccordingToProbability [

	| board distributions tolerance cardGiverRatio blackHoleRatio noEffectRatio |
	distributions := {
		                 (Distribution at: NoEffect with: 0.38).
		                 (Distribution at: CardGiver with: 0.10).
		                 (Distribution at: BlackHole with: 0.20).
		                 (Distribution at: HyperSpaceJump with: 0.20).
		                 (Distribution at: MoonWalk with: 0.10).
		                 (Distribution
			                  at: (HyperJump with: {
						                   (Distance lightYear: 27).
						                   (Distance lightYear: 18).
						                   (Distance lightYear: 9) })
			                  with: 0.08).
		                 (Distribution at: AtomicBomb with: 0.02) }.
	board := Board
		         with: 1000
		         and: (Worm with: 2 and: 4)
		         has: distributions
		         basedOn: (Distance parsecs: 20).
	tolerance := 0.05. "5% de margen de error"
	cardGiverRatio := (board amountOfCellsOf: 'CardGiver') / 1000.
	blackHoleRatio := (board amountOfCellsOf: 'BlackHole') / 1000.
	noEffectRatio := (board amountOfCellsOf: 'NoEffect') / 1000.
	self assert: (cardGiverRatio between: 0.10 - tolerance and: 0.10 + tolerance).
	self assert: (blackHoleRatio between: 0.20 - tolerance and: 0.20 + tolerance).
	self assert: (noEffectRatio between: 0.38 - tolerance and: 0.38 + tolerance)
]
