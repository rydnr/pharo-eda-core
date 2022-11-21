Class {
	#name : #EDAACandidateTest,
	#superclass : #TestCase,
	#traits : 'EDAAContainsAdapterClassPragma',
	#classTraits : 'EDAAContainsAdapterClassPragma classTrait',
	#category : #'EDAA-Domain-Tests'
}

{ #category : #annotations }
EDAACandidateTest class >> arbitraryKey [
	"Maps 'arbitraryKey' to #EDAAMemoryventStore"

	<edaAdapterClass: #EDAAMemoryEventStore priority: 101>
	^ self
]

{ #category : #annotations }
EDAACandidateTest class >> classSideArbitraryKey [
	"Maps 'classSideArbitraryKey' to #EDAAMemoryventStore"

	<edaAdapterClass: #EDAAMemoryEventStore priority: 102>
	^ self
]

{ #category : #tests }
EDAACandidateTest >> EDAAMongoEventStore [
	"See testAdapterMatchingKeyIsPreferred"

	<edaAdapterClass: #EDAAMongoEventStore priority: 1000>
	^ self
]

{ #category : #tests }
EDAACandidateTest >> arbitraryKey [
	"Maps 'arbitraryKey' to #EDAAMongoEventStore"

	<edaAdapterClass: #EDAAMongoEventStore priority: 2000>
	^ self
]

{ #category : #tests }
EDAACandidateTest >> testAdapterClassAsCandidateKey [
	| candidate |
	candidate := EDAACandidate withKey: 'EDAAMongoEventStore' value: nil.
	self assert: candidate adapterClass equals: #EDAAMongoEventStore.
	candidate := EDAACandidate withKey: 'EDAAMemoryEventStore' value: nil.
	self assert: candidate adapterClass equals: #EDAAMemoryEventStore.
]

{ #category : #tests }
EDAACandidateTest >> testAdapterClassFromPragma [
	| candidate |
	candidate := EDAACandidate withKey: 'arbitraryKey' value: nil.
	self assert: candidate adapterClass equals: #EDAAMemoryEventStore.
	candidate := EDAACandidate
		withKey: 'classSideArbitraryKey'
		value: nil.
	self assert: candidate adapterClass equals: #EDAAMemoryEventStore
]

{ #category : #tests }
EDAACandidateTest >> testAdapterMatchingKeyIsPreferred [
	| candidate |
	candidate := (EDAACandidate withKey: 'EDAAMongoEventStore' value: nil)
		adapterClass.
	self assert: candidate equals: #EDAAMongoEventStore
]

{ #category : #tests }
EDAACandidateTest >> testBuilderMethod [
	| key candidate value |
	key := 'candidateKey'.
	value := 'candidateValue'.
	candidate := EDAACandidate withKey: key value: value.
	self
		assert: candidate key equals: key;
		assert: candidate value equals: value
]

{ #category : #tests }
EDAACandidateTest >> testCommandListenerIsAvailable [
	| candidate adapter |
	candidate := (EDAACandidate withKey: 'commandListener' value: nil).
	adapter := candidate toAdapter.
	self
		assert: adapter isNotNil;
		assert: adapter class equals: EDAACommandStompTopicListener
]

{ #category : #tests }
EDAACandidateTest >> testCommandListenerIsConfigured [

	| candidate values adapter |
	values := Dictionary new.
	values
		at: 'host' put: 'localhost';
		at: 'port' put: 61613;
		at: 'user' put: 'user';
		at: 'password' put: 'secret';
		at: 'queue' put: 'messages-to-eda';
		at: 'durable' put: true;
		at: 'ack' put: 'client-individual';
		at: 'prefetchCount' put: 1;
		at: 'timeout' put: 60;
		at: 'debug' put: true;
		at: 'restartOnError' put: false.
	candidate := EDAACandidate withKey: 'commandListener' value: values.
	adapter := candidate toAdapter.
	self
		assert: adapter isNotNil;
		assert: adapter class equals: EDAACommandStompTopicListener;
		assert: adapter host equals: 'localhost';
		assert: adapter port equals: 61613;
		assert: adapter user equals: 'user';
		assert: adapter password equals: 'secret';
		assert: adapter queue equals: 'messages-to-eda';
		assert: adapter durable;
		assert: adapter ack equals: 'client-individual';
		assert: adapter prefetchCount equals: 1;
		assert: adapter timeout equals: 60;
		assert: adapter debug;
		assert: adapter restartOnErrors not
]

{ #category : #tests }
EDAACandidateTest >> testEventPublisherIsAvailable [
	| candidate adapter |
	candidate := (EDAACandidate withKey: 'eventPublisher' value: nil).
	adapter := candidate toAdapter.
	self
		assert: adapter isNotNil;
		assert: adapter class equals: EDAAEventStompTopicPublisher
]

{ #category : #tests }
EDAACandidateTest >> testPriorityIsUsedToPickThePragmaAdapter [
	| candidate |
	candidate := (EDAACandidate withKey: 'arbitraryKey' value: nil)
		adapterClassesFromPragma first.
	self assert: candidate equals: #EDAAMemoryEventStore
]

{ #category : #tests }
EDAACandidateTest >> testSeveralAdaptersWithTheSameKeyAreSupported [
	| candidates |
	candidates := (EDAACandidate withKey: 'arbitraryKey' value: nil)
		adapterClasses.
	self assert: (candidates includes: #EDAAMongoEventStore).
	self assert: (candidates includes: #EDAAMemoryEventStore)
]
