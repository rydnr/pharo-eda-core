Class {
	#name : #EDAAVOProjectionMongoRepository,
	#superclass : #VOMongoRepository,
	#category : #'EDAA-Projections-Voyage'
}

{ #category : #persistence }
EDAAVOProjectionMongoRepository >> collectionNameFor: aClass [
	^ aClass voyageCollectionName
]

{ #category : #persistence }
EDAAVOProjectionMongoRepository >> findAllProjections: aClass ofTenant: aTenant [
	| criteria |
	criteria := Dictionary new.
	criteria at: 'tenant' put: aTenant.
	^ self
		selectMany: aClass
		where: criteria
		sortBy:
			(OrderedCollection
				with: #timestamp -> VOOrder ascending
				with: #_id -> VOOrder ascending) asDictionary
]

{ #category : #persistence }
EDAAVOProjectionMongoRepository >> selectMany: aClass where: aBlock sortBy: sortBlock [
	^ self selectManyOperation
		queryClass: aClass;
		where: aBlock;
		sortBlock: sortBlock;
		execute

]
