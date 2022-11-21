Extension { #name : #EDAEventSourcingEvent }

{ #category : #'*EDAA-EventStore-Voyage' }
EDAEventSourcingEvent class >> isVoyageRoot [
	^ true
]

{ #category : #'*EDAA-EventStore-Voyage' }
EDAEventSourcingEvent class >> voyageRepository [
	^ voyageRepository
]

{ #category : #'*EDAA-EventStore-Voyage' }
EDAEventSourcingEvent class >> voyageRepository: aVoyageRepository [
	voyageRepository := aVoyageRepository
]
