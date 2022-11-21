Extension { #name : #EDAProjection }

{ #category : #'*EDAA-Projections-Voyage' }
EDAProjection class >> isVoyageRoot [
	^ self subclassResponsibility
]

{ #category : #'*EDAA-Projections-Voyage' }
EDAProjection class >> voyageCollectionName [
	^ self subclassResponsibility
]

{ #category : #'*EDAA-Projections-Voyage' }
EDAProjection class >> voyageRepository [
	^ self repository repository
]
