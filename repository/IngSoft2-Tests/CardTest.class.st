Class {
	#name : 'CardTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
CardTest >> test000WhenGameStartsThenEachShipHasTwoCards [

	| speedCard redoCard repeatCard accelerationCard aGame |
	speedCard := SpeedCard new.
	redoCard := RedoCard new.
	repeatCard := RepeatCard new.
	accelerationCard := AccelerationCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         deck: { speedCard. redoCard. repeatCard. accelerationCard };
		         build.
	self
		assert: (aGame cardsOf: 'ship 1')
		equals: (OrderedCollection with: speedCard with: redoCard).
	self
		assert: (aGame cardsOf: 'ship 2')
		equals: (OrderedCollection with: repeatCard with: accelerationCard)
]

{ #category : 'tests' }
CardTest >> test001WhenUseSpeedCardFromDeckThenApplyItEffect [

	| aGame speedCard |
	speedCard := SpeedCard new.
	aGame := GameBuilder new
		         diceSequence: #( 6 );
		         deck: { speedCard. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: speedCard targeting: 'ship 1'.
	aGame playTurn. "1 + 6 + 1 de la Speed = 8"
	self assert: (aGame positionOf: 'ship 1') equals: 8
]

{ #category : 'tests' }
CardTest >> test002WhenShipWantsToPlayACardThatItDoesNotHaveThenRaiseError [

	| aGame |
	aGame := GameBuilder new
		         deck: { MercenaryCard new. AccelerationCard new };
		         build.
	self
		should: [ aGame ship: 'ship 1' plays: SpeedCard targeting: 'ship 1'. ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'Cannot play a card you do not have' ]
]

{ #category : 'tests' }
CardTest >> test003WhenShipUseMercenaryCardWithShip2ThenTheyDoNotBattle [

	| aGame mercenaryCard |
	mercenaryCard := MercenaryCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'mercenary' );
		         diceSequence: #( 6 );
		         deck: { mercenaryCard. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: mercenaryCard targeting: 'mercenary'.
	aGame playTurn. "ship 1 cae en 7"
	aGame playTurn. "mercenary cae en 7: son aliadas, no pelean"
	self assert: (aGame positionOf: 'ship 1') equals: 7.
	self assert: (aGame positionOf: 'mercenary') equals: 7.
	self assert: (aGame shieldsOf: 'ship 1') equals: 3.
	self assert: (aGame shieldsOf: 'mercenary') equals: 3
]

{ #category : 'tests' }
CardTest >> test004WhenAShipUseSpeedCardThenIsRemovedFromDeckOfShip [

	| aGame speedCard |
	speedCard := SpeedCard new.
	aGame := GameBuilder new
		         deck: { speedCard. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: speedCard targeting: 'ship 1'.
	self assert: (aGame cardsOf: 'ship 1') size equals: 1
]

{ #category : 'tests' }
CardTest >> test005WhenShip1FightToShip3UsingShip2AsMErcenaryThenShip1WinTheBattle [

	| aGame mercenaryCard |
	mercenaryCard := MercenaryCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 2 3 2 5 2 4 );
		         wormHoleBetween: 9 and: 10;
		         deck: { mercenaryCard. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: mercenaryCard targeting: 'ship 2'.
	aGame playTurn. "ship 1 cae en 3"
	aGame playTurn. "ship 2 cae en 4"
	aGame playTurn. "ship 3 cae en 3 y pelea: ship 3 saca 5; ship 1 saca 2 + 4 de su mercenaria = 6"
	self assert: (aGame shieldsOf: 'ship 3') equals: 2.
	self assert: (aGame positionOf: 'ship 3') equals: 1.
	self assert: (aGame shieldsOf: 'ship 1') equals: 3.
	self assert: (aGame shieldsOf: 'ship 2') equals: 3.
]

{ #category : 'tests' }
CardTest >> test006WhenShip1FightToShip3UsingShip2AsMErcenaryAndShip3WonThenShip1AndShip2Loss1Shield [

	| aGame mercenaryCard |
	mercenaryCard := MercenaryCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 2 3 2 7 2 4 );
		         wormHoleBetween: 9 and: 10;
		         deck: { mercenaryCard. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: mercenaryCard targeting: 'ship 2'.
	aGame playTurn. "ship 1 cae en 3"
	aGame playTurn. "ship 2 cae en 4"
	aGame playTurn. "ship 3 cae en 3 y pelea: ship 3 saca 7; ship 1 saca 2 + 4 de su mercenaria = 6"
	self assert: (aGame shieldsOf: 'ship 1') equals: 2.
	self assert: (aGame shieldsOf: 'ship 2') equals: 2.
	self assert: (aGame shieldsOf: 'ship 3') equals: 3.
]

{ #category : 'tests' }
CardTest >> test007WhenShip3AndShip1WanttheSameShipAsMercenaryThenRaiseError [

	| aGame mercenaryCard1 mercenaryCard2 |
	mercenaryCard1 := MercenaryCard new.
	mercenaryCard2 := MercenaryCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 1 2 );
		         wormHoleBetween: 9 and: 10;
		         deck: { mercenaryCard1. SpeedCard new. SpeedCard new. SpeedCard new. mercenaryCard2. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: mercenaryCard1 targeting: 'ship 2'.
	aGame playTurn. "ship 1 cae en 2"
	aGame playTurn. "ship 2 cae en 4"
	self
		should: [ aGame ship: 'ship 3' plays: mercenaryCard2 targeting: 'ship 2' ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'You can not use this ship as a mercenary' ]
]

{ #category : 'tests' }
CardTest >> test008WhenUseAccelerationCardThenAllThrowsIncrementsBy1 [

	| aGame accelerationCard |
	accelerationCard := AccelerationCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 1 2 3 );
		         wormHoleBetween: 9 and: 10;
		         deck: { accelerationCard. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: accelerationCard.
	aGame playTurn.
	aGame playTurn.
	aGame playTurn.
	self assert: (aGame positionOf: 'ship 1') equals: 3.
	self assert: (aGame positionOf: 'ship 2') equals: 4.
	self assert: (aGame positionOf: 'ship 3') equals: 5
]

{ #category : 'tests' }
CardTest >> test009WhenUseCancellationCardThenRemoveSpeedCard [

	| aGame speedCard cancellationCard |
	speedCard := SpeedCard new.
	cancellationCard := CancellationCard new.
	aGame := GameBuilder new
		         diceSequence: #( 3 );
		         wormHoleBetween: 9 and: 10;
		         deck: { speedCard. cancellationCard };
		         build.
	aGame ship: 'ship 1' plays: speedCard targeting: 'ship 1'.
	aGame ship: 'ship 1' plays: cancellationCard targeting: aGame activeCards first.
	aGame playTurn. "1 + 3, sin el +1 de la Speed cancelada"
	self assert: (aGame positionOf: 'ship 1') equals: 4
]

{ #category : 'tests' }
CardTest >> test010WhenUseCancellationCardWithAccelerationThenRemoveAcceleration [

	| aGame accelerationCard cancellationCard |
	accelerationCard := AccelerationCard new.
	cancellationCard := CancellationCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 1 3 );
		         wormHoleBetween: 9 and: 10;
		         deck: { accelerationCard. cancellationCard. AccelerationCard new. AccelerationCard new };
		         build.
	aGame ship: 'ship 1' plays: accelerationCard.
	aGame playTurn. "ship 1: 1 + 1 + 1 de la Acceleration = 3"
	aGame ship: 'ship 1' plays: cancellationCard targeting: aGame activeCards first.
	aGame playTurn. "ship 2: 1 + 3, ya sin Acceleration = 4"
	self assert: (aGame positionOf: 'ship 1') equals: 3.
	self assert: (aGame positionOf: 'ship 2') equals: 4
]

{ #category : 'tests' }
CardTest >> test011WhenUseCancellationCardWithMercenaryThenRemoveMercenary [

	| aGame mercenaryCard cancellationCard |
	mercenaryCard := MercenaryCard new.
	cancellationCard := CancellationCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 2 1 2 5 3 );
		         wormHoleBetween: 9 and: 10;
		         deck: { mercenaryCard. AccelerationCard new. cancellationCard. AccelerationCard new. AccelerationCard new. AccelerationCard new };
		         build.
	aGame ship: 'ship 1' plays: mercenaryCard targeting: 'ship 3'.
	aGame ship: 'ship 2' plays: cancellationCard targeting: aGame activeCards first.
	aGame playTurn. "ship 1 cae en 3"
	aGame playTurn. "ship 2 cae en 2"
	aGame playTurn. "ship 3 cae en 3: ya no son aliadas, pelean 5 contra 3"
	self assert: (aGame shieldsOf: 'ship 1') equals: 2.
	self assert: (aGame positionOf: 'ship 1') equals: 1.
	self assert: (aGame shieldsOf: 'ship 3') equals: 3
]

{ #category : 'tests' }
CardTest >> test012WhenUseCancellationCardAndNoActiveCardsThenRaiseError [

	| aGame cancellationCard |
	cancellationCard := CancellationCard new.
	aGame := GameBuilder new
		         deck: { SpeedCard new. cancellationCard };
		         build.
	self
		should: [ aGame ship: 'ship 1' plays: cancellationCard ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'Cannot play cancellation card with no active permanent cards' ]
]

{ #category : 'tests' }
CardTest >> test013WhenUseREDOCardThenItTakesTheEffectOfTheLastCardUsed [

	| aGame accelerationCard redoCard |
	accelerationCard := AccelerationCard new.
	redoCard := RedoCard new.
	aGame := GameBuilder new
		         diceSequence: #( 3 );
		         deck: { accelerationCard. redoCard };
		         build.
	aGame ship: 'ship 1' plays: accelerationCard.
	aGame ship: 'ship 1' plays: redoCard.
	aGame playTurn. "1 + 3 + 2 (Acceleration + su Redo) = 6"
	self assert: (aGame positionOf: 'ship 1') equals: 6
]

{ #category : 'tests' }
CardTest >> test014WhenUseRepeatCardBeforePlayingThenItDoesNotApplyTheLastEffectOnGame [

	| aGame repeatCard |
	repeatCard := RepeatCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         allCellsWith: HyperSpaceJump new;
		         deck: { AccelerationCard new. repeatCard. SpeedCard new. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: repeatCard targeting: 'ship 2'.
	self assert: (aGame positionOf: 'ship 2') equals: 1.
	self assert: (aGame shieldsOf: 'ship 2') equals: 3
]

{ #category : 'tests' }
CardTest >> test015WhenUseRepeatCardThenItApplyTheLastEffectOnGame [

	| aGame repeatCard |
	repeatCard := RepeatCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 6 7 );
		         allCellsWith: BlackHole new;
		         wormHoleBetween: 9 and: 10;
		         deck: { AccelerationCard new. repeatCard. SpeedCard new. SpeedCard new };
		         build.
	aGame playTurn. "ship 1: cae en 7, el BlackHole lo lleva a 3"
	aGame playTurn. "ship 2: cae en 8, el BlackHole lo lleva a 4"
	aGame ship: 'ship 1' plays: repeatCard targeting: 'ship 2'. "otro BlackHole a ship 2: de 4 a 1"
	self assert: (aGame positionOf: 'ship 2') equals: 1
]

{ #category : 'tests' }
CardTest >> test016WhenUseRepeatCardButThereIsNoEffectThenItDoesNotApplyTheLastEffectOnGame [

	| aGame repeatCard |
	repeatCard := RepeatCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 3 7 );
		         wormHoleBetween: 9 and: 10;
		         deck: { AccelerationCard new. repeatCard. SpeedCard new. SpeedCard new };
		         build.
	aGame playTurn. "ship 1 cae en 4"
	aGame playTurn. "ship 2 cae en 8"
	aGame ship: 'ship 1' plays: repeatCard targeting: 'ship 2'.
	self assert: (aGame positionOf: 'ship 2') equals: 8
]

{ #category : 'tests' }
CardTest >> test017WhenTheShipMovesThrowTheBoardAndITACrdGiverCellThenShipRecieveOneCard [

	| aGame |
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 3 );
		         allCellsWith: CardGiver new;
		         wormHoleBetween: 9 and: 10;
		         deck: { RepeatCard new. AccelerationCard new. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame playTurn. "ship 1 cae en 4 (CardGiver) y recibe la 5ta carta del mazo"
	self assert: (aGame cardsOf: 'ship 1') size equals: 3
]

{ #category : 'tests' }
CardTest >> test018WhenShipUseRepeatCardAndLastEffectWasACardGiverThenTheChosenShipReceivesACard [

	| aGame repeatCard |
	repeatCard := RepeatCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 3 );
		         allCellsWith: CardGiver new;
		         wormHoleBetween: 9 and: 10;
		         deck: { repeatCard. RedoCard new. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame playTurn. "ship 1 cae en 4 (CardGiver) y recibe la 5ta carta del mazo"
	aGame ship: 'ship 1' plays: repeatCard targeting: 'ship 2'. "se repite el CardGiver: ship 2 recibe la 6ta"
	self assert: (aGame cardsOf: 'ship 2') size equals: 3
]

{ #category : 'tests' }
CardTest >> test019WhenShipFightToAnotherShipButHasBonusThrowThenItCanWin [

	| aGame speedCard |
	speedCard := SpeedCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 3 );
		         wormHoleBetween: 9 and: 10;
		         deck: { RedoCard new. SpeedCard new. speedCard. SpeedCard new };
		         build.
	aGame playTurn. "ship 1 cae en 4"
	aGame ship: 'ship 2' plays: speedCard targeting: 'ship 1'. "es el turno de ship 2: le da +1 a ship 1"
	aGame playTurn. "ship 2 cae en 4 y pelea: ship 2 saca 3; ship 1 saca 3 + 1 = 4"
	self assert: (aGame shieldsOf: 'ship 2') equals: 2.
	self assert: (aGame shieldsOf: 'ship 1') equals: 3
]

{ #category : 'tests' }
CardTest >> test020WhenModifyingTheCardsOfAShipFromOutsideThenItsHandDoesNotChange [

	| aGame |
	aGame := GameBuilder new
		         deck: { SpeedCard new. RedoCard new };
		         build.
	(aGame cardsOf: 'ship 1') removeAll.
	self assert: (aGame cardsOf: 'ship 1') size equals: 2
]

{ #category : 'tests' }
CardTest >> test021WhenAMercenaryHasASpeedCardThenItsBonusCountsInTheBattle [

	| mercenaryCard speedCard aGame |
	mercenaryCard := MercenaryCard new.
	speedCard := SpeedCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 2 3 2 7 2 5 9 1 1 );
		         wormHoleBetween: 9 and: 10;
		         deck: { mercenaryCard. speedCard. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: mercenaryCard targeting: 'ship 2'.
	aGame ship: 'ship 1' plays: speedCard targeting: 'ship 2'.
	aGame playTurn. "ship 1 cae en 3"
	aGame playTurn. "ship 2 saca 3 + 1 de la Speed: cae en 5"
	aGame playTurn. "ship 3 cae en 3 y pelea: ship 3 saca 7; ship 1 saca 2 + su mercenaria 5 + 1 = 8"
	self assert: (aGame shieldsOf: 'ship 1') equals: 3.
	self assert: (aGame shieldsOf: 'ship 3') equals: 2
]

{ #category : 'tests' }
CardTest >> test022WhenRedoReplaysAPermanentCardThenCancellingTheOriginalKeepsTheRedoOne [

	| speedCard redoCard cancellationCard aGame |
	speedCard := SpeedCard new.
	redoCard := RedoCard new.
	cancellationCard := CancellationCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 3 );
		         deck: { speedCard. redoCard. cancellationCard. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: speedCard targeting: 'ship 1'.
	aGame ship: 'ship 1' plays: redoCard targeting: 'ship 1'. "dos Speed activas sobre ship 1"
	aGame ship: 'ship 2' plays: cancellationCard targeting: aGame activeCards first.
	aGame playTurn. "1 + 3 + 1 de la Speed que queda = 5"
	self assert: (aGame positionOf: 'ship 1') equals: 5
]

{ #category : 'tests' }
CardTest >> test023WhenShipPlaysAPermanentCardOutOfItsTurnThenRaiseError [

	| speedCard aGame |
	speedCard := SpeedCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         deck: { SpeedCard new. SpeedCard new. speedCard. SpeedCard new };
		         build.
	self
		should: [ aGame ship: 'ship 2' plays: speedCard targeting: 'ship 2' ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'Permanent cards can only be played during your turn' ]
]

{ #category : 'tests' }
CardTest >> test024WhenTheLastEffectWasACardGiverAfterABlackHoleThenRepeatAppliesTheCardGiver [

	| effects repeatCard aGame |
	effects := (1 to: 10) collect: [ :cell | NoEffect new ].
	effects at: 7 put: BlackHole new.
	effects at: 4 put: CardGiver new.
	repeatCard := RepeatCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 6 3 );
		         effects: effects;
		         wormHoleBetween: 9 and: 10;
		         deck: { repeatCard. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame playTurn. "ship 1: cae en 7 (BlackHole) -> 3"
	aGame playTurn. "ship 2: cae en 4 (CardGiver) y recibe una carta"
	aGame ship: 'ship 1' plays: repeatCard targeting: 'ship 1'.
	self assert: (aGame positionOf: 'ship 1') equals: 3.
	self assert: (aGame cardsOf: 'ship 1') size equals: 2
]

{ #category : 'tests' }
CardTest >> test025WhenRepeatAfterAWormHoleThenTheChosenShipGoesToTheSameExit [

	| repeatCard aGame |
	repeatCard := RepeatCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 2 );
		         wormHoleBetween: 3 and: 7;
		         deck: { repeatCard. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame playTurn. "ship 1 cae en 3 (wormhole) y sale por 7"
	aGame ship: 'ship 1' plays: repeatCard targeting: 'ship 2'.
	"ship 2 esta en 1: va a la misma salida (7), no a la primera punta (3)"
	self assert: (aGame positionOf: 'ship 2') equals: 7.
	self assert: (aGame lapOf: 'ship 2') equals: 1
]

{ #category : 'tests' }
CardTest >> test026WhenRepeatAfterAWormHoleUsedFromTheOtherEndThenTheChosenShipGoesToThatExit [

	| repeatCard aGame |
	repeatCard := RepeatCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 6 );
		         wormHoleBetween: 3 and: 7;
		         deck: { repeatCard. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame playTurn. "ship 1 cae en 7 (wormhole) y sale por 3"
	aGame ship: 'ship 1' plays: repeatCard targeting: 'ship 2'.
	self assert: (aGame positionOf: 'ship 2') equals: 3
]

{ #category : 'tests' }
CardTest >> test027WhenRepeatAfterAHyperJumpThenTheChosenShipJumpsTheSameDistance [

	| repeatCard aGame |
	repeatCard := RepeatCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 2 2 );
		         allCellsWith: (HyperJump with: {
						          (Distance parsecs: 8).
						          (Distance parsecs: 6).
						          (Distance parsecs: 2) });
		         wormHoleBetween: 9 and: 10;
		         laps: 2;
		         deck: { repeatCard. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame playTurn. "ship 1 cae en 3, salta 8 parsecs = 4 celdas -> 7"
	aGame ship: 'ship 1' plays: repeatCard targeting: 'ship 2'.
	"ship 2 salta los mismos 8 parsecs: de 1 a 5"
	self assert: (aGame positionOf: 'ship 2') equals: 5
]

{ #category : 'tests' }
CardTest >> test028WhenRepeatAfterAHyperJumpThenTheListOfDistancesDoesNotAdvance [

	| repeatCard aGame |
	repeatCard := RepeatCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 2 2 5 1 );
		         allCellsWith: (HyperJump with: {
						          (Distance parsecs: 8).
						          (Distance parsecs: 6).
						          (Distance parsecs: 2) });
		         wormHoleBetween: 9 and: 10;
		         laps: 2;
		         deck: { repeatCard. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame playTurn. "ship 1 cae en 3, salta 8 parsecs -> 7"
	aGame ship: 'ship 1' plays: repeatCard targeting: 'ship 2'. "ship 2: de 1 a 5"
	aGame playTurn.
	"ship 2 cae en 7: le toca la segunda distancia (6 parsecs = 3 celdas) -> 10.
	 Si el Repeat hubiera avanzado la lista, saltaria 2 parsecs, quedaria en 7 y pelearia con ship 1"
	self assert: (aGame positionOf: 'ship 2') equals: 10
]

{ #category : 'tests' }
CardTest >> test029WhenRepeatAfterAMoonWalkThenEveryShipExceptTheChosenOneGoesBack [

	| effects repeatCard aGame |
	effects := (1 to: 20) collect: [ :cell | NoEffect new ].
	effects at: 4 put: (MoonWalk move: 1).
	repeatCard := RepeatCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 7 9 3 );
		         effects: effects;
		         wormHoleBetween: 19 and: 20;
		         deck: { repeatCard. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame playTurn. "ship 1 cae en 8"
	aGame playTurn. "ship 2 cae en 10"
	aGame playTurn. "ship 3 cae en 4 (MoonWalk de 1): ship 1 pasa a 7 y ship 2 a 9"
	aGame ship: 'ship 1' plays: repeatCard targeting: 'ship 1'.
	"se repite el MoonWalk como si ship 1 hubiera caido en el: retroceden todas menos ella"
	self assert: (aGame positionOf: 'ship 1') equals: 7.
	self assert: (aGame positionOf: 'ship 2') equals: 8.
	self assert: (aGame positionOf: 'ship 3') equals: 3
]

{ #category : 'tests' }
CardTest >> test030WhenRepeatAfterAnAtomicBombThenEveryShipIsAffected [

	| effects repeatCard aGame |
	effects := (1 to: 20) collect: [ :cell | NoEffect new ].
	effects at: 4 put: AtomicBomb new.
	repeatCard := RepeatCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 22 3 );
		         effects: effects;
		         wormHoleBetween: 19 and: 20;
		         laps: 2;
		         deck: { repeatCard. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame playTurn. "ship 1: 1 + 22 = celda 3 de la vuelta 2"
	aGame playTurn. "ship 2 cae en 4 (AtomicBomb): las dos van a la celda 1 de su vuelta y pierden un escudo"
	aGame ship: 'ship 1' plays: repeatCard targeting: 'ship 2'.
	"se repite el AtomicBomb: afecta a todas, no solo a la elegida"
	self assert: (aGame positionOf: 'ship 1') equals: 1.
	self assert: (aGame lapOf: 'ship 1') equals: 2.
	self assert: (aGame shieldsOf: 'ship 1') equals: 1.
	self assert: (aGame positionOf: 'ship 2') equals: 1.
	self assert: (aGame shieldsOf: 'ship 2') equals: 1 .
	self assert: (aGame lapOf: 'ship 2') equals: 1.
]

{ #category : 'tests' }
CardTest >> test031WhenShipPlaysReversePolarityOnACellThenItBecomesAnActiveCard [

	| reversePolarityCard aGame |
	reversePolarityCard := ReversePolarityCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         deck: { reversePolarityCard. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: reversePolarityCard targeting: 7.
	self assert: aGame activeCards size equals: 1.
	self assert: (aGame cardsOf: 'ship 1') size equals: 1
]

{ #category : 'tests' }
CardTest >> test032WhenReversePolarityTargetsACellOutsideTheBoardThenRaiseError [

	| reversePolarityCard aGame |
	reversePolarityCard := ReversePolarityCard new.
	aGame := GameBuilder new
		         deck: { reversePolarityCard. SpeedCard new };
		         build.
	self
		should: [ aGame ship: 'ship 1' plays: reversePolarityCard targeting: 11 ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'There is no cell number 11 on the board' ].
	self assert: (aGame cardsOf: 'ship 1') size equals: 2
]

{ #category : 'tests' }
CardTest >> test033WhenShipPlaysReversePolarityOutOfItsTurnThenRaiseError [

	| reversePolarityCard aGame |
	reversePolarityCard := ReversePolarityCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         deck: { SpeedCard new. SpeedCard new. reversePolarityCard. SpeedCard new };
		         build.
	self
		should: [ aGame ship: 'ship 2' plays: reversePolarityCard targeting: 7 ]
		raise: Error
		withExceptionDo: [ :error |
			self
				assert: error messageText
				equals: 'Permanent cards can only be played during your turn' ]
]

{ #category : 'tests' }
CardTest >> test034WhenReversePolarityIsCancelledThenItIsNoLongerActive [

	| reversePolarityCard cancellationCard aGame |
	reversePolarityCard := ReversePolarityCard new.
	cancellationCard := CancellationCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         deck: { reversePolarityCard. SpeedCard new. cancellationCard. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: reversePolarityCard targeting: 7.
	aGame ship: 'ship 2' plays: cancellationCard targeting: aGame activeCards first.
	self assert: aGame activeCards isEmpty
]

{ #category : 'tests' }
CardTest >> test035WhenAShipLandsOnAReversedBlackHoleThenEveryOtherShipGoesBack [

	| effects reversePolarityCard aGame |
	effects := (1 to: 20) collect: [ :cell | NoEffect new ].
	effects at: 5 put: BlackHole new.
	reversePolarityCard := ReversePolarityCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 9 6 4 );
		         effects: effects;
		         wormHoleBetween: 19 and: 20;
		         deck: { reversePolarityCard. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: reversePolarityCard targeting: 5.
	aGame playTurn. "ship 1 cae en 10"
	aGame playTurn. "ship 2 cae en 7"
	aGame playTurn. "ship 3 cae en 5 (BlackHole invertido): retroceden 4 todas las demas"
	self assert: (aGame positionOf: 'ship 3') equals: 5.
	self assert: (aGame positionOf: 'ship 1') equals: 6.
	self assert: (aGame positionOf: 'ship 2') equals: 3
]

{ #category : 'tests' }
CardTest >> test036WhenAShipLandsOnAReversedHyperSpaceJumpThenEveryOtherShipMovesForwardAndLosesAShield [

	| effects reversePolarityCard aGame |
	effects := (1 to: 20) collect: [ :cell | NoEffect new ].
	effects at: 5 put: HyperSpaceJump new.
	reversePolarityCard := ReversePolarityCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 9 6 4 );
		         effects: effects;
		         wormHoleBetween: 19 and: 20;
		         deck: { reversePolarityCard. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: reversePolarityCard targeting: 5.
	aGame playTurn. "ship 1 cae en 10"
	aGame playTurn. "ship 2 cae en 7"
	aGame playTurn. "ship 3 cae en 5 (HyperSpaceJump invertido): las demas avanzan 4 y pierden un escudo"
	self assert: (aGame positionOf: 'ship 3') equals: 5.
	self assert: (aGame shieldsOf: 'ship 3') equals: 3.
	self assert: (aGame positionOf: 'ship 1') equals: 14.
	self assert: (aGame shieldsOf: 'ship 1') equals: 2.
	self assert: (aGame positionOf: 'ship 2') equals: 11.
	self assert: (aGame shieldsOf: 'ship 2') equals: 2
]

{ #category : 'tests' }
CardTest >> test037WhenAShipLandsOnAReversedCardGiverThenEveryOtherShipReceivesACard [

	| effects reversePolarityCard aGame |
	effects := (1 to: 20) collect: [ :cell | NoEffect new ].
	effects at: 5 put: CardGiver new.
	reversePolarityCard := ReversePolarityCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 9 6 4 );
		         effects: effects;
		         wormHoleBetween: 19 and: 20;
		         deck: { reversePolarityCard. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: reversePolarityCard targeting: 5.
	aGame playTurn. "ship 1 cae en 10"
	aGame playTurn. "ship 2 cae en 7"
	aGame playTurn. "ship 3 cae en 5 (CardGiver invertido): ship 1 y ship 2 reciben una carta cada una"
	self assert: (aGame cardsOf: 'ship 1') size equals: 2.
	self assert: (aGame cardsOf: 'ship 2') size equals: 3.
	self assert: (aGame cardsOf: 'ship 3') size equals: 2
]

{ #category : 'tests' }
CardTest >> test038WhenAShipLandsOnAReversedHyperJumpThenEveryOtherShipJumpsTheSameDistance [

	| effects reversePolarityCard aGame |
	effects := (1 to: 20) collect: [ :cell | NoEffect new ].
	effects at: 5 put: (HyperJump with: {
				 (Distance parsecs: 8).
				 (Distance parsecs: 6) }).
	reversePolarityCard := ReversePolarityCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 9 6 4 11 );
		         effects: effects;
		         wormHoleBetween: 19 and: 20;
		         laps: 2;
		         length: (Distance parsecs: 40);
		         deck: { reversePolarityCard. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: reversePolarityCard targeting: 5.
	aGame playTurn. "ship 1 cae en 10"
	aGame playTurn. "ship 2 cae en 7"
	aGame playTurn. "ship 3 cae en 5 (HyperJump invertido): las demas saltan 8 parsecs = 4 celdas"
	self assert: (aGame positionOf: 'ship 3') equals: 5.
	self assert: (aGame positionOf: 'ship 1') equals: 14.
	self assert: (aGame positionOf: 'ship 2') equals: 11.
	aGame playTurn.
	"ship 1: 14 + 11 = celda 5 de la vuelta 2: a las demas les toca la segunda distancia (6 parsecs = 3 celdas).
	 Si la lista hubiera avanzado una vez por cada nave, volveria a tocar 8 parsecs"
	self assert: (aGame positionOf: 'ship 2') equals: 14.
	self assert: (aGame positionOf: 'ship 3') equals: 8
]

{ #category : 'tests' }
CardTest >> test039WhenAReversedEffectBringsAShipToTheCellOfTheShipInTurnThenTheyDoNotFight [

	| effects reversePolarityCard aGame |
	effects := (1 to: 20) collect: [ :cell | NoEffect new ].
	effects at: 5 put: BlackHole new.
	reversePolarityCard := ReversePolarityCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 8 6 4 5 2 );
		         effects: effects;
		         wormHoleBetween: 19 and: 20;
		         deck: { reversePolarityCard. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: reversePolarityCard targeting: 5.
	aGame playTurn. "ship 1 cae en 9"
	aGame playTurn. "ship 2 cae en 7"
	aGame playTurn.
	"ship 3 cae en 5 (BlackHole invertido): ship 1 retrocede de 9 a 5, a la celda de ship 3.
	 ship 3 se queda en la celda del efecto y ship 1 fue movida por el efecto: no pelean"
	self assert: (aGame positionOf: 'ship 1') equals: 5.
	self assert: (aGame shieldsOf: 'ship 1') equals: 3.
	self assert: (aGame positionOf: 'ship 3') equals: 5.
	self assert: (aGame shieldsOf: 'ship 3') equals: 3.
	self assert: (aGame positionOf: 'ship 2') equals: 3
]

{ #category : 'tests' }
CardTest >> test040WhenAShipLandsOnAReversedMoonWalkThenOnlyThatShipGoesBackAndFightsWhereItLands [

	| effects reversePolarityCard aGame |
	effects := (1 to: 20) collect: [ :cell | NoEffect new ].
	effects at: 8 put: (MoonWalk move: 3).
	reversePolarityCard := ReversePolarityCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 4 6 7 6 2 );
		         effects: effects;
		         wormHoleBetween: 19 and: 20;
		         deck: { reversePolarityCard. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: reversePolarityCard targeting: 8.
	aGame playTurn. "ship 1 cae en 5"
	aGame playTurn. "ship 2 cae en 7"
	aGame playTurn.
	"ship 3 cae en 8 (MoonWalk de 3 invertido): solo ella retrocede, de 8 a 5, donde esta ship 1.
	 Fue desplazada por el efecto, asi que pelea: 6 contra 2, y gana"
	self assert: (aGame positionOf: 'ship 3') equals: 5.
	self assert: (aGame shieldsOf: 'ship 3') equals: 3.
	self assert: (aGame positionOf: 'ship 1') equals: 1.
	self assert: (aGame shieldsOf: 'ship 1') equals: 2.
	self assert: (aGame positionOf: 'ship 2') equals: 7
]

{ #category : 'tests' }
CardTest >> test041WhenAShipLandsOnAReversedAtomicBombThenNothingHappensAndItDoesNotFight [

	| effects reversePolarityCard aGame |
	effects := (1 to: 20) collect: [ :cell | NoEffect new ].
	effects at: 8 put: AtomicBomb new.
	reversePolarityCard := ReversePolarityCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' 'ship 3' );
		         diceSequence: #( 4 7 7 5 2 );
		         effects: effects;
		         wormHoleBetween: 19 and: 20;
		         deck: { reversePolarityCard. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: reversePolarityCard targeting: 8.
	aGame playTurn. "ship 1 cae en 5"
	aGame playTurn. "ship 2 cae en 8 (AtomicBomb invertido): no le pasa nada a nadie"
	aGame playTurn.
	"ship 3 tambien cae en 8, donde esta ship 2: no le pasa nada a nadie,
	 y como se queda en la celda del efecto, no pelea"
	self assert: (aGame positionOf: 'ship 1') equals: 5.
	self assert: (aGame shieldsOf: 'ship 1') equals: 3.
	self assert: (aGame positionOf: 'ship 2') equals: 8.
	self assert: (aGame shieldsOf: 'ship 2') equals: 3.
	self assert: (aGame positionOf: 'ship 3') equals: 8.
	self assert: (aGame shieldsOf: 'ship 3') equals: 3
]

{ #category : 'tests' }
CardTest >> test042WhenAShipLandsOnAReversedCellWithoutEffectThenNothingChangesAndItFightsAsUsual [

	| reversePolarityCard aGame |
	reversePolarityCard := ReversePolarityCard new.
	aGame := GameBuilder new
		         shipsNamed: #( 'ship 1' 'ship 2' );
		         diceSequence: #( 5 5 6 1 );
		         cells: 20;
		         wormHoleBetween: 19 and: 20;
		         deck: { reversePolarityCard. SpeedCard new. SpeedCard new. SpeedCard new };
		         build.
	aGame ship: 'ship 1' plays: reversePolarityCard targeting: 6.
	aGame playTurn. "ship 1 cae en 6 (vacia, invertida)"
	aGame playTurn. "ship 2 cae en 6, donde esta ship 1: invertir una celda vacia no cambia nada, pelean 6 contra 1"
	self assert: (aGame positionOf: 'ship 1') equals: 1.
	self assert: (aGame shieldsOf: 'ship 1') equals: 2.
	self assert: (aGame positionOf: 'ship 2') equals: 6
]
