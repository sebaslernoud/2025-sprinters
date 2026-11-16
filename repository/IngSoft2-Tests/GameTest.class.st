Class {
	#name : 'GameTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
GameTest >> test000WhenPlayGameThenWinnerShowWinnerIsNotNill [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         dice: { Dice with: 5 };
		         build.
	aGame play.
	self assert: aGame showWinner isNotNil
]

{ #category : 'tests' }
GameTest >> test001WhenPlayGameThenReturnGameOver [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         dice: { Dice with: 5 };
		         build.
	self assert: aGame play equals: 'Game over'
]

{ #category : 'tests' }
GameTest >> test002WhenPlayGameWithOneShipThenReturnWinner [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'shipOne' );
		         dice: { Dice with: 5 };
		         build.
	aGame play.
	self assert: aGame showWinner name equals: 'shipOne'
]

{ #category : 'tests' }
GameTest >> test003WhenSomeShipWinThenShowPositions [

	| aGame expectedPositions |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' );
		         diceSequence: #( 5 8 );
		         build.
	aGame play.
	expectedPositions := Dictionary new.
	expectedPositions at: 'ship 1' put: 10.
	self assert: aGame showShipsPositions equals: expectedPositions
]

{ #category : 'tests' }
GameTest >> test004When2ShipsPlayAndShipOneWonThenReturnPositions [

	| aGame expectedPositions |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 5 );
		         build.
	(aGame findShipBy: 'ship 1') move: 10 in: aGame board.
	(aGame findShipBy: 'ship 2') move: 5 in: aGame board.
	aGame play.
	expectedPositions := Dictionary new.
	expectedPositions at: 'ship 1' put: 10.
	expectedPositions at: 'ship 2' put: 6.
	self assert: aGame showShipsPositions equals: expectedPositions
]

{ #category : 'tests' }
GameTest >> test005When2ShipsWithSameNameAddedInAListThenRaiseError [

	self
		should: [
			GameBuilder new
				shipsNamed: #( 'ship 1' 'ship 2' 'ship 1' );
				build ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'Ship´s name must not be reapeated.' ]
]

{ #category : 'tests' }
GameTest >> test006WhenCreateGamewithEmptyShipsThenRaiseError [

	self
		should: [
			GameBuilder new
				shipsNamed: #(  );
				laps: 0;
				build ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'List of ships must not be empty.' ]
]

{ #category : 'tests' }
GameTest >> test007WhenCreateGameThenGameCreateShips [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         build.
	self assert: (aGame findShipBy: 'ship 1') position equals: 1
]

{ #category : 'tests' }
GameTest >> test008WhenGameHasPlayedThenShowRanking [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 6 10 );
		         build.
	(aGame findShipBy: 'ship 2') move: 10 in: aGame board.
	aGame play.
	self
		assert: aGame showRanking
		equals: (OrderedCollection withAll: #( 'ship 2' 'ship 1' ))
]

{ #category : 'tests' }
GameTest >> test009WhenGameHasPlayedWithLoadedDiceThenShowShipSortedByPositionReturnShip3AtFirst [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 3 5 7 );
		         build.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: aGame shipsSortedByPosition first name equals: 'ship 3'
]

{ #category : 'tests' }
GameTest >> test010WhenGameHasNotStartedThenShowRankingRaiseError [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         build.
	self
		should: [ aGame showRanking ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'The Game has not been played yet so it doesn`t have a ranking' ]
]

{ #category : 'tests' }
GameTest >> test011WhenShipIsOnCellWithEffectThenReceiveEffect [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 6 );
		         allCellsWith: BlackHole;
		         build.
	aGame playTurn.
	self assert: (aGame findShipBy: 'ship 1') position equals: 3
]

{ #category : 'tests' }
GameTest >> test012WhenShipIsOnCellWithNoEffectThenDoNotReceiveEffect [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 5 );
		         build.
	aGame playTurn.
	self assert: (aGame findShipBy: 'ship 1') position equals: 6
]

{ #category : 'tests' }
GameTest >> test013WhenTwoShipsAreInTheSameCellWithEffectThenTheyDoNotBattle [

	| aGame ship1 ship2 |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 6 2 );
		         allCellsWith: BlackHole;
		         wormHoleBetween: 9 and: 10;
		         build.
	aGame playTurn. "ship 1: 1 + 6 = 7, el BlackHole lo lleva a 3"
	aGame playTurn. "ship 2: 1 + 2 = 3, donde esta ship 1; el BlackHole lo lleva a 1"
	ship1 := aGame findShipBy: 'ship 1'.
	ship2 := aGame findShipBy: 'ship 2'.
	self assert: ship1 position equals: 3.
	self assert: ship2 position equals: 1.
	self assert: ship1 shields equals: 3.
	self assert: ship2 shields equals: 3
]

{ #category : 'tests' }
GameTest >> test014WhenShipIsMovedBecauseAnEffectToACellWithEffectThenShipDoNotReceiveTheSecondEffect [

	| aGame |
	aGame := GameBuilder new
		         diceSequence: #( 6 );
		         allCellsWith: BlackHole;
		         build.
	aGame playTurn.
	self assert: (aGame findShipBy: 'ship 1') position equals: 3
]

{ #category : 'tests' }
GameTest >> test015WhenShipIsMovedByAnEffectToACellWithAnotherShipThenTheyFight [

	| aGame ship1 ship2 |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 6 6 5 2 );
		         allCellsWith: BlackHole;
		         wormHoleBetween: 9 and: 10;
		         build.
	aGame playTurn. "ship 1: 1 + 6 = 7, el BlackHole lo lleva a 3"
	aGame playTurn. "ship 2: 1 + 6 = 7, el BlackHole lo lleva a 3 donde esta ship 1: pelean 5 contra 2"
	ship1 := aGame findShipBy: 'ship 1'.
	ship2 := aGame findShipBy: 'ship 2'.
	self assert: ship1 position equals: 1.
	self assert: ship1 shields equals: 2.
	self assert: ship2 position equals: 3.
	self assert: ship2 shields equals: 3
]

{ #category : 'tests' }
GameTest >> test016WhenShipIsMovedByAnEffectToAWormHoleThenItIsNotTransported [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 7 );
		         allCellsWith: BlackHole;
		         wormHoleBetween: 2 and: 4;
		         build.
	aGame playTurn. "ship 1: 1 + 7 = 8, el BlackHole lo lleva a 4 (wormhole), pero no lo transporta a 2"
	self assert: (aGame findShipBy: 'ship 1') position equals: 4
]

{ #category : 'tests' }
GameTest >> test017WhenGameIsCreatedThenAShipFromCollectionWins [

	| distancesToMove shipNames aGame |
	distancesToMove := {
		                   (Distance lightYear: 27).
		                   (Distance lightYear: 18).
		                   (Distance lightYear: 9) }.
	shipNames := #( 'ship 1' 'ship 2' 'ship 3' 'ship 4' ).
	aGame := GameBuilder new
		         shipsNamed: shipNames;
		         dice: { Dice with: 6 };
		         cells: 5;
		         distributions: {
				         (Distribution at: NoEffect with: 0.38).
				         (Distribution at: CardGiver with: 0.10).
				         (Distribution at: BlackHole with: 0.20).
				         (Distribution at: HyperSpaceJump with: 0.20).
				         (Distribution at: MoonWalk with: 0.10).
				         (Distribution at: (HyperJump with: distancesToMove) with: 0.08).
				         (Distribution at: AtomicBomb with: 0.02) };
		         laps: 3;
		         build.
	aGame play.
	self assert: (shipNames includes: aGame showWinner name)
]
