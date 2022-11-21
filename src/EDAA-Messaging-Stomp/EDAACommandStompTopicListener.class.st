"
* Class: EDAACommandStompTopicListener

A EDAAStompTopicListener specific for receiving EDA commands.

* Responsibility: 

Manage how to listen to incoming commands, while acting as the configuration container for the EDA command queue.
"
Class {
	#name : #EDAACommandStompTopicListener,
	#superclass : #EDAAStompTopicListener,
	#traits : 'EDAAContainsAdapterClassPragma',
	#classTraits : 'EDAAContainsAdapterClassPragma classTrait',
	#category : #'EDAA-Messaging-Stomp'
}

{ #category : #meta }
EDAACommandStompTopicListener class >> commandListener [
	<edaAdapterClass>
	^ self
]
