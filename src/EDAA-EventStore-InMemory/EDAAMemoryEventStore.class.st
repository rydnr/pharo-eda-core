Class {
	#name : #EDAAMemoryEventStore,
	#superclass : #EDAPEventStore,
	#category : #'EDAA-EventStore-InMemory'
}

{ #category : #persistence }
EDAAMemoryEventStore >> allEvents [
	^ EDAEventSourcingEvent selectAll
]

{ #category : #accessing }
EDAAMemoryEventStore >> findEventsOfTenant: aTenant ofAggregate: anAggregate whereCriteria: aDictionary [
	^ self shouldBeImplemented
]

{ #category : #persistence }
EDAAMemoryEventStore >> findEventsOfTenant: aTenant ofAggregate: anAggregateRootClass whereId: aNumber [
	^ EDAEventSourcingEvent
		selectMany: [ :event |
			event aggregateRootClass = anAggregateRootClass asString
				and: [ event tenant = aTenant and: [ event id = aNumber ] ] ]
]

{ #category : #persistence }
EDAAMemoryEventStore >> initBackendRepository [
	| result |
	result := VOMemoryRepository new.
	result enableSingleton.
	^ result
]

{ #category : #persistence }
EDAAMemoryEventStore >> saveEvents: anEventCollection [
	anEventCollection do: [ :event | event save ]
]
