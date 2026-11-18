Class {
	#name : 'EffectsTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
EffectsTest >> test001WhenApplyBlackHoleEffectToShipThenShipMove4Cells [

	| aGame ship1 |
	aGame := GameBuilder new build.
	ship1 := aGame findShipBy: 'ship 1'.
	ship1 move: 6 in: aGame board. "queda en 7"
	BlackHole new applyTo: ship1 in: aGame.
	self assert: ship1 position equals: 3
]

{ #category : 'tests' }
EffectsTest >> test002WhenApplyBlackHoleEffectNearTheStartThenShipPositionIsNeverLessThanOne [

	| aGame ship1 |
	aGame := GameBuilder new build.
	ship1 := aGame findShipBy: 'ship 1'.
	ship1 move: 2 in: aGame board. "queda en 3; 3 - 4 seria -1"
	BlackHole new applyTo: ship1 in: aGame.
	self assert: ship1 position equals: 1
]

{ #category : 'tests' }
EffectsTest >> test003WhenApplyHyperSpaceJumpEffectToShipThenShipMoves4Cells [

	| aGame ship1 |
	aGame := GameBuilder new build.
	ship1 := aGame findShipBy: 'ship 1'.
	HyperSpaceJump new applyTo: ship1 in: aGame. "de 1 a 5"
	self assert: ship1 position equals: 5
]

{ #category : 'tests' }
EffectsTest >> test004WhenApplyHyperSpaceJumpEffectToShipThenShipShieldsAre2 [

	| aGame ship1 |
	aGame := GameBuilder new build.
	ship1 := aGame findShipBy: 'ship 1'.
	HyperSpaceJump new applyTo: ship1 in: aGame.
	self assert: ship1 shields equals: 2
]

{ #category : 'tests' }
EffectsTest >> test005WhenApplyMoonWalkEffectToShip1ThenShip2MoveNPositionBackward [

	| aGame ship2 |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         laps: 2;
		         build.
	ship2 := aGame findShipBy: 'ship 2'.
	ship2 move: 13 in: aGame board. "queda en la celda 4 de la vuelta 2"
	(MoonWalk move: 10) applyTo: (aGame findShipBy: 'ship 1') in: aGame.
	self assert: ship2 position equals: 1
]

{ #category : 'tests' }
EffectsTest >> test006WhenApplyAtomicBombEffectThenAllShipsGoBackToTheFirstCell [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         laps: 4;
		         build.
	(aGame findShipBy: 'ship 2') move: 23 in: aGame board.
	AtomicBomb new applyTo: (aGame findShipBy: 'ship 1') in: aGame.
	self assert: (aGame findShipBy: 'ship 1') position equals: 1.
	self assert: (aGame findShipBy: 'ship 2') position equals: 1.
	self assert: (aGame findShipBy: 'ship 3') position equals: 1
]

{ #category : 'tests' }
EffectsTest >> test007WhenApplyAtomicBombEffectToShipThenAllShipPositionAreOneButLapsNotChange [

	| aGame ship1 ship2 |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 12 );
		         allCellsWith: AtomicBomb new;
		         wormHoleBetween: 9 and: 10;
		         laps: 3;
		         build.
	aGame playTurn. "ship 1: 1 + 12 = 13 -> celda 3 de la vuelta 2 -> AtomicBomb"
	ship1 := aGame findShipBy: 'ship 1'.
	ship2 := aGame findShipBy: 'ship 2'.
	self assert: ship1 position equals: 1.
	self assert: ship1 laps equals: 2.
	self assert: ship2 position equals: 1.
	self assert: ship2 laps equals: 1
]

{ #category : 'tests' }
EffectsTest >> test008WhenApplyAtomicBombEffectToShipThenAllShipLoseOneShield [

	| aGame |
	aGame := GameBuilder new
		         diceSequence: #( 10 );
		         allCellsWith: AtomicBomb new;
		         laps: 4;
		         build.
	aGame playTurn.
	self assert: (aGame findShipBy: 'ship 1') shields equals: 2
]

{ #category : 'tests' }
EffectsTest >> test009WhenCreatHuperJumpEffectToShipThenItMoveaParsec [

	| aGame |
	aGame := GameBuilder new
		         diceSequence: #( 2 );
		         allCellsWith: (HyperJump with: {
						          (Distance parsecs: 8).
						          (Distance parsecs: 6).
						          (Distance parsecs: 3) });
		         build.
	aGame playTurn. "cae en 3, salta 8 parsecs = 4 celdas"
	self assert: (aGame findShipBy: 'ship 1') position equals: 7
]

{ #category : 'tests' }
EffectsTest >> test010WhenTwoShipsFallOnTheSameHyperJumpThenEachOneJumpsTheNextDistance [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 3 );
		         allCellsWith: (HyperJump with: {
						          (Distance parsecs: 8).
						          (Distance parsecs: 6).
						          (Distance parsecs: 3) });
		         wormHoleBetween: 9 and: 10;
		         build.
	aGame playTurn. "ship 1: cae en 4, salta 8 parsecs = 4 celdas"
	aGame playTurn. "ship 2: cae en 4, salta 6 parsecs = 3 celdas"
	self assert: (aGame findShipBy: 'ship 1') position equals: 8.
	self assert: (aGame findShipBy: 'ship 2') position equals: 7
]

{ #category : 'tests' }
EffectsTest >> test011WhenCreatHuperJumpEffectWithCellsLessThanZeroThenRaiseError [

	| parsecsToMove |
	parsecsToMove := OrderedCollection new.
	parsecsToMove add: (Distance parsecs: 8).
	parsecsToMove add: (Distance parsecs: -6).
	parsecsToMove add: (Distance parsecs: 3).

	self
		should: [ HyperJump with: parsecsToMove ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'Parsecs and lightYears to move must to be positive' ]
]

{ #category : 'tests' }
EffectsTest >> test012WhenCreatHuperJumpEffectWithCellsHaveToBeLessThanThePreviusThenRaiseError [

	| lightYearToMove |
	lightYearToMove := OrderedCollection new.
	lightYearToMove add: (Distance lightYear: 8).
	lightYearToMove add: (Distance lightYear: 10).
	lightYearToMove add: (Distance lightYear: 3).

	self
		should: [ HyperJump with: lightYearToMove ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'Parsecs and lightYears have to be less than the earlier one' ]
]

{ #category : 'tests' }
EffectsTest >> test014WhenCreatHyperJumpWithParsecsrEffectToShipThenItMovesParsecs [

	| aGame |
	aGame := GameBuilder new
		         diceSequence: #( 2 );
		         cells: 20;
		         length: (Distance parsecs: 60);
		         allCellsWith: (HyperJump with: {
						          (Distance parsecs: 9).
						          (Distance parsecs: 6).
						          (Distance parsecs: 3) });
		         build.
	aGame playTurn. "cae en 3, salta 9 parsecs = 3 celdas"
	self assert: (aGame findShipBy: 'ship 1') position equals: 6
]

{ #category : 'tests' }
EffectsTest >> test015WhenCreatHyperJumpLightYearEffectToShipThenItMovesPrrsecs [

	| aGame |
	aGame := GameBuilder new
		         diceSequence: #( 2 );
		         cells: 20;
		         length: (Distance lightYear: 180);
		         allCellsWith: (HyperJump with: {
						          (Distance lightYear: 27).
						          (Distance lightYear: 18).
						          (Distance lightYear: 9) });
		         build.
	aGame playTurn. "cae en 3, salta 27 años luz = 9 parsecs = 3 celdas"
	self assert: (aGame findShipBy: 'ship 1') position equals: 6
]

{ #category : 'tests' }
EffectsTest >> test016WhenInitializeGameThenLastRealEffectIsEmpty [

	| aGame |
	aGame := GameBuilder new build.
	self assert: aGame effectManager lastRealEffect class equals: NoEffect
]
