Class {
	#name : #EDAACandidate,
	#superclass : #Object,
	#instVars : [
		'key',
		'value'
	],
	#category : #'EDAA-Domain'
}

{ #category : #accessing }
EDAACandidate class >> defaultPriority [
	^ 100
]

{ #category : #'instance creation' }
EDAACandidate class >> withKey: aKey value: aValue [
	^ self new key: aKey; value: aValue; yourself
]

{ #category : #api }
EDAACandidate >> adapterClass [
	| result fromKey potentialAdapterClasses |
	fromKey := self adapterClassFromKey.
	result := (self isClassValid: fromKey)
		ifTrue: [ fromKey ]
		ifFalse: [ potentialAdapterClasses := self adapterClassesFromPragma
				select: [ :cls | self isClassValid: cls ].
			potentialAdapterClasses
				ifEmpty: [ nil ]
				ifNotEmpty: [ :c | c first ] ].
	^ result
]

{ #category : #api }
EDAACandidate >> adapterClassFromKey [
	^ self key asSymbol
]

{ #category : #api }
EDAACandidate >> adapterClassPragmas [
	| results annotatedClasses |
	results := OrderedCollection new.
	annotatedClasses := EDAAContainsAdapterClassPragma
		traitUsers.
	annotatedClasses
		do:
			[ :annotatedClass | results addAll: (self adapterClassPragmasIn: annotatedClass) ].
	^ results
]

{ #category : #api }
EDAACandidate >> adapterClassPragmas: aSymbol in: annotatedClass [
	| pragmas |
	pragmas := (Pragma
		allNamed: aSymbol
		inAndBelow: annotatedClass) asOrderedCollection.
	pragmas
		addAll:
			(Pragma
				allNamed: aSymbol
				inAndBelow: annotatedClass class).
	^ pragmas
		select: [ :pragma | pragma method selector = self key asSymbol ]
]

{ #category : #api }
EDAACandidate >> adapterClassPragmasIn: annotatedClass [
	| results |
	results := OrderedCollection new.
	(OrderedCollection
		with: #edaAdapterClass:priority:
		with: #edaAdapterClassWithPriority:
		with: #edaAdapterClass)
		do:
			[ :aSymbol | results addAll: (self adapterClassPragmas: aSymbol in: annotatedClass) ].
	^ results
]

{ #category : #api }
EDAACandidate >> adapterClasses [
	| results |
	results := self adapterClassesFromPragma.
	self adapterClassFromKey ifNotNil: [ :k | results addFirst: k ].
	^ results select: [ :cls | self isClassValid: cls ]
]

{ #category : #api }
EDAACandidate >> adapterClassesFromPragma [
	^ (self adapterClassPragmas
		sort: [ :a :b | self sortPragmasByPriority: a and: b ])
		collect: [ :p | self collectPragma: p ]
]

{ #category : #api }
EDAACandidate >> collectPragma: aPragma [
	^ aPragma arguments size > 1
		ifTrue: [ aPragma argumentAt: 1 ]
		ifFalse: [ | cls |
			cls := aPragma method classBinding value.
			cls isMeta
				ifTrue: [ cls allInstances first name asSymbol ]
				ifFalse: [ cls name asSymbol ] ]
]

{ #category : #api }
EDAACandidate >> defaultPriority [
	^ self class defaultPriority
]

{ #category : #api }
EDAACandidate >> isClassValid: aSymbol [
	^ (self toClass: aSymbol) isNotNil
]

{ #category : #accessing }
EDAACandidate >> key [
	^ key
]

{ #category : #accessing }
EDAACandidate >> key: anObject [
	key := anObject
]

{ #category : #api }
EDAACandidate >> sortPragmasByPriority: aPragma and: anotherPragma [
	| aPriority bPriority |
	aPriority := aPragma arguments size > 1
		ifTrue: [ aPragma argumentAt: aPragma arguments size ]
		ifFalse: [ self defaultPriority ].
	bPriority := anotherPragma arguments size > 1
		ifTrue: [ anotherPragma argumentAt: anotherPragma arguments size ]
		ifFalse: [ self defaultPriority ].
	^ aPriority < bPriority
]

{ #category : #converting }
EDAACandidate >> toAdapter [
	^ (self toClass: self adapterClass) new
]

{ #category : #api }
EDAACandidate >> toClass: aSymbol [
	^ (Smalltalk environment at: aSymbol ifAbsent: [ nil ])
]

{ #category : #accessing }
EDAACandidate >> value [
	^ value
]

{ #category : #accessing }
EDAACandidate >> value: anObject [
	value := anObject
]
