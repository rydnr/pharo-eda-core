Class {
	#name : #EDAAMongoEventStore,
	#superclass : #EDAPEventStore,
	#traits : 'EDACPrintOnHelper + EDACMongoHelper',
	#classTraits : 'EDACPrintOnHelper classTrait + EDACMongoHelper classTrait',
	#instVars : [
		'edaApplication',
		'settings'
	],
	#classInstVars : [
		'password',
		'host',
		'port',
		'debug',
		'enableReplication',
		'enableSingleton',
		'ensuringCurrentOnSave',
		'ensuringCurrentReferencesOnQueries',
		'forceEager',
		'lazySynchronize',
		'wireProtocolEnabled',
		'authenticationMechanism',
		'urls',
		'tls',
		'database',
		'user'
	],
	#category : #'EDAA-EventStore-Voyage'
}

{ #category : #'instance creation' }
EDAAMongoEventStore class >> withConfig: anEDASMongodbEventStoreSettingsJsonAdapter forApplication: anEDASASampleApplication [

	^ self basicNew
		  settings: anEDASMongodbEventStoreSettingsJsonAdapter;
		  edaApplication: anEDASASampleApplication;
		initialize;
		  yourself
]

{ #category : #persistence }
EDAAMongoEventStore >> allEventsOfTenant: aTenant [
	| eventsCriteria |
	eventsCriteria := (OrderedCollection
		with: 'tenant' -> aTenant greaseString)
		asDictionary.
	^ EDAEventSourcingEvent
		selectMany: eventsCriteria
		sortBy: (OrderedCollection with: #timestamp -> VOOrder ascending with: #_id -> VOOrder ascending) asDictionary
]

{ #category : #accessing }
EDAAMongoEventStore >> edaApplication [

	^ edaApplication
]

{ #category : #accessing }
EDAAMongoEventStore >> edaApplication: anObject [

	edaApplication := anObject
]

{ #category : #persistence }
EDAAMongoEventStore >> findEventsOfTenant: aTenant ofAggregate: anAggregateRootClass whereCriteria: aCriteriaDictionary [
	| eventsCriteria |
	eventsCriteria := Dictionary newFrom: aCriteriaDictionary.
	eventsCriteria at: 'tenant' put: aTenant greaseString.
	eventsCriteria at: 'aggregateRootClass' put: anAggregateRootClass greaseString.
	^ EDAEventSourcingEvent
		selectMany: eventsCriteria
		sortBy: (OrderedCollection with: #timestamp -> VOOrder ascending) asDictionary
]

{ #category : #persistence }
EDAAMongoEventStore >> findEventsOfTenant: aTenant ofAggregate: anAggregateRootClass whereId: aNumber [
	^ self
		findEventsOfTenant: aTenant ofAggregate: anAggregateRootClass
		whereCriteria: (OrderedCollection with: 'id' -> aNumber) asDictionary
]

{ #category : #persistence }
EDAAMongoEventStore >> initBackendRepository [

	| result |
	result := self mongoRepositoryClass
		          mongoUrls: (self csvToCollection: self settings urls)
		          database: self settings database
		          username: self settings user
		          password: self settings password.
	"result cache: EDAMongoNoCache new."
	result debug: self settings debug.
	self settings enableReplication
		ifTrue: [ result enableReplication ]
		ifFalse: [ "result disableReplication" ].
	self settings enableSingleton
		ifTrue: [ result enableSingleton ]
		ifFalse: [ result disableSingleton ].
	result ensuringCurrentOnSave: self settings ensuringCurrentOnSave.
	result ensuringCurrentReferencesOnQueries:
		self settings ensuringCurrentReferencesOnQueries.
	result ensuringCurrentReferencesOnQueries:
		self settings ensuringCurrentReferencesOnQueries.
	result lazySynchronize: self settings lazySynchronize.
	"	result wireProtocolEnabled: self settings wireProtocolEnabled."
	^ result
]

{ #category : #persistence }
EDAAMongoEventStore >> mongoRepositoryClass [
	^ EDAAVOMongoRepository
]

{ #category : #persistence }
EDAAMongoEventStore >> saveEvents: anEventCollection [
	anEventCollection do: [ :event | event save ]
]

{ #category : #accessing }
EDAAMongoEventStore >> settings [

	^ settings
]

{ #category : #accessing }
EDAAMongoEventStore >> settings: anObject [

	settings := anObject
]
