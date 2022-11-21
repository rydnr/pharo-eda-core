Class {
	#name : #EDAAVOMongoRepository,
	#superclass : #VOMongoRepository,
	#traits : 'EDACPrintOnHelper',
	#classTraits : 'EDACPrintOnHelper classTrait',
	#category : #'EDAA-EventStore-Voyage'
}

{ #category : #voyage }
EDAAVOMongoRepository class >> voyageCollectionName [
	^ 'EDAEventSourcingEvent'
]

{ #category : #voyage }
EDAAVOMongoRepository >> collectionNameFor: aClass [
	^ aClass voyageCollectionName
]

{ #category : #persistence }
EDAAVOMongoRepository >> selectMany: aClass where: aBlock sortBy: sortBlock [
	^ self selectManyOperation
		queryClass: aClass;
		where: aBlock;
		sortBlock: sortBlock;
		execute

]
