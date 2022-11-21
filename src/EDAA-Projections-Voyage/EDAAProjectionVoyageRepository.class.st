Class {
	#name : #EDAAProjectionVoyageRepository,
	#superclass : #EDAProjectionRepository,
	#instVars : [
		'repository'
	],
	#category : #'EDAA-Projections-Voyage'
}

{ #category : #'class initialization' }
EDAAProjectionVoyageRepository >> doInitialize [
	self repository: self initBackendRepository
]

{ #category : #persistence }
EDAAProjectionVoyageRepository >> findAllOfTenant: aTenant [
	| criteria |
	criteria := Dictionary new.
	criteria at: 'tenant' put: aTenant.
	^ self selectMany: self where: criteria
]

{ #category : #persistence }
EDAAProjectionVoyageRepository >> initBackendRepository [
	self subclassResponsibility 
]

{ #category : #'class initialization' }
EDAAProjectionVoyageRepository >> initialize [
	super initialize.
	self doInitialize
]

{ #category : #persistence }
EDAAProjectionVoyageRepository >> removeProjection: aProjectionClass [
	repository removeAll: aProjectionClass
]

{ #category : #accessing }
EDAAProjectionVoyageRepository >> repository [
	^ repository
]

{ #category : #accessing }
EDAAProjectionVoyageRepository >> repository: aRepository [
	repository := aRepository
]

{ #category : #persistence }
EDAAProjectionVoyageRepository >> save: aProjection [
	aProjection save
]

{ #category : #persistence }
EDAAProjectionVoyageRepository >> selectMany: aProjectionClass where: aDictionary [
	^ aProjectionClass selectMany: aDictionary.
]

{ #category : #persistence }
EDAAProjectionVoyageRepository >> selectOfTenant: aTenant many: aProjectionClass where: aDictionary [
	| criteria |
	criteria := Dictionary newFrom: aDictionary.
	criteria at: 'tenant' put: aTenant.
	^ aProjectionClass selectMany: criteria.
]

{ #category : #persistence }
EDAAProjectionVoyageRepository >> selectOfTenant: aTenant one: aProjectionClass where: aDictionary [
	| criteria |
	criteria := Dictionary newFrom: aDictionary.
	criteria at: 'tenant' put: aTenant.
	^ aProjectionClass selectOne: criteria
]

{ #category : #persistence }
EDAAProjectionVoyageRepository >> selectOne: aProjectionClass where: aDictionary [
	^ aProjectionClass selectOne: aDictionary
]
