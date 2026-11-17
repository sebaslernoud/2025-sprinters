Class {
	#name : 'BoardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
BoardTest >> test000WhenCreateBoardWithAmountOfCellsThenShowAmountOfCells [

	| aBoard |
	aBoard := Board
		          withEffects: (Array new: 10 withAll: NoEffect new)
		          wormHole: (Worm with: 4 and: 6)
		          laps: 1
		          length: (Distance parsecs: 200).
	self assert: aBoard amountOfCells equals: 10
]

{ #category : 'tests' }
BoardTest >> test001WhenBoardIsCreatedThenTheWormHoleIsTheEffectOfItsTwoCells [

	| aWorm aBoard |
	aWorm := Worm with: 4 and: 6.
	aBoard := Board
		          withEffects: (Array new: 10 withAll: NoEffect new)
		          wormHole: aWorm
		          laps: 1
		          length: (Distance parsecs: 20).
	self assert: (aBoard effectOnPosition: 4) equals: aWorm.
	self assert: (aBoard effectOnPosition: 6) equals: aWorm.
	self assert: (aBoard effectOnPosition: 5) class equals: NoEffect
]

{ #category : 'tests' }
BoardTest >> test002WhenCreateBoardWithWrongWormHolePostionThenReturnsError [

	self
		should: [
			Board
				withEffects: (Array new: 10 withAll: NoEffect new)
				wormHole: (Worm with: 4 and: 11)
				laps: 1
				length: (Distance parsecs: 20) ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'Position of the worm hole exceed amount board`s cells' ]
]

{ #category : 'tests' }
BoardTest >> test003WhenCreateBoardWithCellsLessThan1ThenReturnsError [

	self
		should: [
			Board
				withEffects: #(  )
				wormHole: (Worm with: 4 and: 11)
				laps: 1
				length: (Distance parsecs: 20) ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'Amount of cells must be greater than zero' ]
]

{ #category : 'tests' }
BoardTest >> test005WhenShipMovesToWormholeThenBoardKnowsThePositionOfShip [

	| aGame |
	aGame := GameBuilder new
		         diceSequence: #( 6 );
		         wormHoleBetween: 4 and: 7;
		         build.
	aGame playTurn. "cae en 7 y el wormhole lo lleva a 4"
	self assert: (aGame findShipBy: 'ship 1') position equals: 4
]

{ #category : 'tests' }
BoardTest >> test006WhenShipMoveMoreThanCellsInTheBoardThenPositionIsAmountOfCells [

	| aBoard aShip |
	aBoard := Board
		          withEffects: (Array new: 4 withAll: NoEffect new)
		          wormHole: (Worm with: 1 and: 2)
		          laps: 1
		          length: (Distance parsecs: 20).
	aShip := Ship create: 'ship1'.
	aShip move: 6 in: aBoard.
	self assert: aShip position equals: 4
]

{ #category : 'tests' }
BoardTest >> test008WhenAskForEffectOnPositionThenBoardReturnItEffect [

	| aBoard |
	aBoard := Board
		          withEffects: {
				          NoEffect new.
				          NoEffect new.
				          BlackHole new.
				          HyperSpaceJump new.
				          NoEffect new }
		          wormHole: (Worm with: 1 and: 2)
		          laps: 1
		          length: (Distance parsecs: 100).
	self assert: (aBoard effectOnPosition: 3) class equals: BlackHole.
	self assert: (aBoard effectOnPosition: 4) class equals: HyperSpaceJump
]
