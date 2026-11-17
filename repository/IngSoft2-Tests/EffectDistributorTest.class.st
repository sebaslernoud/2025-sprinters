Class {
	#name : 'EffectDistributorTest',
	#superclass : 'TestCase',
	#category : 'IngSoft2-Tests',
	#package : 'IngSoft2-Tests'
}

{ #category : 'tests' }
EffectDistributorTest >> test000WhenDistributingEffectsThenEveryCellReceivesOne [

	| effects |
	effects := (EffectDistributor
		            withDistribution: {
				            (Distribution at: NoEffect with: 0.4).
				            (Distribution at: BlackHole with: 0.6) }
		            on: 5) recieveAmountOfEffects.
	self assert: effects size equals: 5
]

{ #category : 'tests' }
EffectDistributorTest >> test001WhenDistributingEffectsThenTheyFollowTheirProbabilities [

	| effects ratioOf tolerance |
	effects := (EffectDistributor
		            withDistribution: {
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
				            (Distribution at: AtomicBomb with: 0.02) }
		            on: 1000) recieveAmountOfEffects.
	ratioOf := [ :effectClass |
	           (effects count: [ :effect | effect class = effectClass ]) / 1000 ].
	tolerance := 0.05.
	self assert: ((ratioOf value: CardGiver) between: 0.10 - tolerance and: 0.10 + tolerance).
	self assert: ((ratioOf value: BlackHole) between: 0.20 - tolerance and: 0.20 + tolerance).
	self assert: ((ratioOf value: NoEffect) between: 0.38 - tolerance and: 0.38 + tolerance)
]
