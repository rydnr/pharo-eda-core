"
Class: EDAEventStompTopicPublisher

Customization of EDAStompTopicPublisher, for publishing events to other services.

Responsibility:

It's used to publish events reflecting changes in aggregate roots upon receiving input commands.
"
Class {
	#name : #EDAAEventStompTopicPublisher,
	#superclass : #EDAAStompTopicPublisher,
	#traits : 'EDAAContainsAdapterClassPragma',
	#classTraits : 'EDAAContainsAdapterClassPragma classTrait',
	#category : #'EDAA-Messaging-Stomp'
}

{ #category : #meta }
EDAAEventStompTopicPublisher class >> eventPublisher [
	<edaAdapterClass: #EDAAEventStompTopicPublisher priority: 100>
	^ self
]

{ #category : #API }
EDAAEventStompTopicPublisher >> publishEvent: anEvent [
	^ self publishMessage: anEvent
]

{ #category : #API }
EDAAEventStompTopicPublisher >> publishEvent: anEvent inTransaction: id [
	^ self publishMessage: anEvent inTransaction: id

]

{ #category : #API }
EDAAEventStompTopicPublisher >> publishEvent: anEvent withRoutingKey: route [
	^ self publishMessage: anEvent withRoutingKey: route

]

{ #category : #API }
EDAAEventStompTopicPublisher >> publishEventsAtomically: eventCollection [
	^ self publishMessagesAtomically: eventCollection
]
