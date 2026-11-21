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
	self assert: aGame winner isNotNil
]

{ #category : 'tests' }
GameTest >> test002WhenPlayGameWithOneShipThenReturnWinner [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'shipOne' );
		         dice: { Dice with: 5 };
		         build.
	aGame play.
	self assert: aGame winner equals: 'shipOne'
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
	self assert: aGame positions equals: expectedPositions
]

{ #category : 'tests' }
GameTest >> test004When2ShipsPlayAndShipOneWonThenReturnPositions [

	| aGame expectedPositions |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 5 );
		         build.
	aGame move: (aGame shipNamed: 'ship 1') by: 10.
	aGame move: (aGame shipNamed: 'ship 2') by: 5.
	aGame play.
	expectedPositions := Dictionary new.
	expectedPositions at: 'ship 1' put: 10.
	expectedPositions at: 'ship 2' put: 6.
	self assert: aGame positions equals: expectedPositions
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
	self assert: (aGame positionOf: 'ship 1') equals: 1
]

{ #category : 'tests' }
GameTest >> test008WhenGameHasPlayedThenShowRanking [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 6 10 );
		         build.
	aGame move: (aGame shipNamed: 'ship 2') by: 10.
	aGame play.
	self
		assert: aGame ranking
		equals: (OrderedCollection withAll: #( 'ship 2' 'ship 1' ))
]

{ #category : 'tests' }
GameTest >> test009WhenThreeShipsPlayTheirTurnsThenEachOneIsInItsPosition [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 3 5 7 );
		         wormHoleBetween: 9 and: 10;
		         build.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: (aGame positionOf: 'ship 1') equals: 4.
	self assert: (aGame positionOf: 'ship 2') equals: 6.
	self assert: (aGame positionOf: 'ship 3') equals: 8
]

{ #category : 'tests' }
GameTest >> test010WhenGameHasNotStartedThenShowRankingRaiseError [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         build.
	self
		should: [ aGame ranking ]
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
		         allCellsWith: BlackHole new;
		         build.
	aGame playTurn.
	self assert: (aGame positionOf: 'ship 1') equals: 3
]

{ #category : 'tests' }
GameTest >> test012WhenShipIsOnCellWithNoEffectThenDoNotReceiveEffect [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 5 );
		         build.
	aGame playTurn.
	self assert: (aGame positionOf: 'ship 1') equals: 6
]

{ #category : 'tests' }
GameTest >> test013WhenTwoShipsAreInTheSameCellWithEffectThenTheyDoNotBattle [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 6 2 );
		         allCellsWith: BlackHole new;
		         wormHoleBetween: 9 and: 10;
		         build.
	aGame playTurn. "ship 1: 1 + 6 = 7, el BlackHole lo lleva a 3"
	aGame playTurn. "ship 2: 1 + 2 = 3, donde esta ship 1; el BlackHole lo lleva a 1"
	self assert: (aGame positionOf: 'ship 1') equals: 3.
	self assert: (aGame positionOf: 'ship 2') equals: 1.
	self assert: (aGame shieldsOf: 'ship 1') equals: 3.
	self assert: (aGame shieldsOf: 'ship 2') equals: 3
]

{ #category : 'tests' }
GameTest >> test014WhenShipIsMovedBecauseAnEffectToACellWithEffectThenShipDoNotReceiveTheSecondEffect [

	| aGame |
	aGame := GameBuilder new
		         diceSequence: #( 6 );
		         allCellsWith: BlackHole new;
		         build.
	aGame playTurn.
	self assert: (aGame positionOf: 'ship 1') equals: 3
]

{ #category : 'tests' }
GameTest >> test015WhenShipIsMovedByAnEffectToACellWithAnotherShipThenTheyFight [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 6 6 5 2 );
		         allCellsWith: BlackHole new;
		         wormHoleBetween: 9 and: 10;
		         build.
	aGame playTurn. "ship 1: 1 + 6 = 7, el BlackHole lo lleva a 3"
	aGame playTurn. "ship 2: 1 + 6 = 7, el BlackHole lo lleva a 3 donde esta ship 1: pelean 5 contra 2"
	self assert: (aGame positionOf: 'ship 1') equals: 1.
	self assert: (aGame shieldsOf: 'ship 1') equals: 2.
	self assert: (aGame positionOf: 'ship 2') equals: 3.
	self assert: (aGame shieldsOf: 'ship 2') equals: 3
]

{ #category : 'tests' }
GameTest >> test016WhenShipIsMovedByAnEffectToAWormHoleThenItIsNotTransported [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 7 );
		         allCellsWith: BlackHole new;
		         wormHoleBetween: 2 and: 4;
		         build.
	aGame playTurn. "ship 1: 1 + 7 = 8, el BlackHole lo lleva a 4 (wormhole), pero no lo transporta a 2"
	self assert: (aGame positionOf: 'ship 1') equals: 4
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
				         (Distribution of: [ NoEffect new ] withProbability: 0.38).
				         (Distribution of: [ CardGiver new ] withProbability: 0.10).
				         (Distribution of: [ BlackHole new ] withProbability: 0.17).
				         (Distribution of: [ HyperSpaceJump new ] withProbability: 0.17).
				         (Distribution
					          of: [ MoonWalk move: (Random new nextIntegerBetween: 1 and: 5) ]
					          withProbability: 0.09).
				         (Distribution
					          of: [ HyperJump with: distancesToMove ]
					          withProbability: 0.07).
				         (Distribution of: [ AtomicBomb new ] withProbability: 0.02) };
		         laps: 3;
		         build.
	aGame play.
	self assert: (shipNames includes: aGame winner)
]

{ #category : 'tests' }
GameTest >> test018WhenShipReachesTheFinishThenItWinsEvenIfTheCellHasAnEffect [

	| aGame |
	aGame := GameBuilder new
		         diceSequence: #( 9 );
		         allCellsWith: BlackHole new;
		         build.
	aGame playTurn. "1 + 9 = 10: llega a la meta y no se aplica el BlackHole"
	self assert: aGame winner equals: 'ship 1'.
	self assert: (aGame positionOf: 'ship 1') equals: 10
]

{ #category : 'tests' }
GameTest >> test019WhenShipLosesAllItsShieldsThenItLosesTwoTurns [

	| effects aGame |
	effects := (1 to: 30) collect: [ :cell | NoEffect new ].
	effects at: 2 put: HyperSpaceJump new.
	effects at: 7 put: HyperSpaceJump new.
	effects at: 12 put: HyperSpaceJump new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 1 20 1 1 1 1 1 1 1 );
		         effects: effects;
		         wormHoleBetween: 29 and: 30;
		         build.
	aGame playTurn. "ship 1: cae en 2 (HyperSpaceJump) -> 6, le quedan 2 escudos"
	aGame playTurn. "ship 2: cae en 21"
	aGame playTurn. "ship 1: cae en 7 (HyperSpaceJump) -> 11, le queda 1 escudo"
	aGame playTurn. "ship 2: 22"
	aGame playTurn. "ship 1: cae en 12 (HyperSpaceJump) -> 16, se queda sin escudos"
	aGame playTurn. "ship 2: 23"
	aGame playTurn. "ship 1 pierde su 1er turno; juega ship 2: 24"
	aGame playTurn. "ship 1 pierde su 2do turno; juega ship 2: 25"
	self assert: (aGame positionOf: 'ship 1') equals: 16.
	self assert: (aGame shieldsOf: 'ship 1') equals: 3.
	self assert: (aGame positionOf: 'ship 2') equals: 25.
	aGame playTurn. "ship 1 vuelve a jugar"
	self assert: (aGame positionOf: 'ship 1') equals: 17
]

{ #category : 'tests' }
GameTest >> test020WhenAShipPlaysATurnThenTheGameKnowsItsPositionLapAndShields [

	| aGame |
	aGame := GameBuilder new
		         diceSequence: #( 5 );
		         allCellsWith: HyperSpaceJump new;
		         wormHoleBetween: 9 and: 10;
		         laps: 2;
		         build.
	self assert: (aGame positionOf: 'ship 1') equals: 1.
	self assert: (aGame lapOf: 'ship 1') equals: 1.
	self assert: (aGame shieldsOf: 'ship 1') equals: 3.
	aGame playTurn. "cae en 6, el HyperSpaceJump lo lleva a 10 y le saca un escudo"
	self assert: (aGame positionOf: 'ship 1') equals: 10.
	self assert: (aGame lapOf: 'ship 1') equals: 1.
	self assert: (aGame shieldsOf: 'ship 1') equals: 2
]

{ #category : 'tests' }
GameTest >> test021WhenAskingForAShipThatDoesNotExistThenRaiseError [

	| aGame |
	aGame := GameBuilder new build.
	self
		should: [ aGame positionOf: 'ship 99' ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'There is no ship named ship 99' ]
]
