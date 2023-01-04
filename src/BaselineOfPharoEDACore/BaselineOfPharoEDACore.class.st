Class {
	#name : #BaselineOfPharoEDACore,
	#superclass : #BaselineOf,
	#category : #BaselineOfPharoEDACore
}

{ #category : #baselines }
BaselineOfPharoEDACore class >> declareGroupsIn: spec [

	spec
		group: 'core'
		with: #( #'EDA-Application' #'EDA-Commands' #'EDA-Events' );
		group: 'tests'
		with: #( #'EDA-Commands-Tests' #'EDA-Commands-Tests-Tests'
			   #'EDA-Application-Tests' #'EDA-Domain-Tests' #'EDA-Projections-Tests' );
		group: 'gtoolkit'
		with: #( 'core' 'tests' #'EDA-Domain-GT-Extensions' );
		group: 'default' with: #( 'core' 'tests' )
]

{ #category : #baselines }
BaselineOfPharoEDACore class >> declarePackagesIn: spec [

	spec
		package: #'EDA-Events'
		with: [ 
			spec requires: #( 'PharoEDACommon' 'PharoEDAApi' 'PharoEDAPorts' ) ];
		package: #'EDA-Commands'
		with: [ spec requires: #( 'PharoEDACommon' 'PharoEDAApi' ) ];
		package: #'EDA-Projections-Tests'
		with: [ spec requires: #( 'PharoEDACommon' ) ];
		package: #'EDA-TestSupport'
		with: [ spec requires: #( 'PharoEDAPorts' 'NeoJSON' 'ObjectDiff' ) ];
		package: #'EDA-Application' with: [ 
			spec requires:
					#( 'EDA-Events' 'EDA-Commands' 'PharoEDACommon' ) ];
		package: #'EDA-Commands-Tests'
		with: [ 
			spec requires: #( 'BabyMock2' 'PharoEDACommon' 'EDA-TestSupport' ) ];
		package: #'EDA-Commands-Tests-Tests'
		with: [ spec requires: #( 'EDA-Commands-Tests' ) ];
		package: #'EDA-Application-Tests'
		with: [ 
			spec requires: #( 'BabyMock2' 'PharoEDACommon' 'EDA-TestSupport' ) ];
		package: #'EDA-Domain-Tests'
		with: [ 
			spec requires: #( 'BabyMock2' 'PharoEDACommon' 'EDA-TestSupport' ) ];
		package: #'EDA-Domain-GT-Extensions'
		with: [ spec requires: #( 'BabyMock2' 'PharoEDACommon' ) ]
]

{ #category : #baselines }
BaselineOfPharoEDACore class >> includeBabyMock2: spec [

	spec project: 'BabyMock2' with: [ 
		spec
			className: #ConfigurationOfBabyMock2;
			versionString: #stable;
			repository: 'http://smalltalkhub.com/mc/zeroflag/BabyMock2/main/' ].
	^ spec
]

{ #category : #baselines }
BaselineOfPharoEDACore class >> includeNeoJSON: spec [

	spec
		baseline: 'NeoJSON'
		with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].
	^ spec
]

{ #category : #baselines }
BaselineOfPharoEDACore class >> includeObjectDiff: spec [

	spec
		baseline: 'ObjectDiff'
		with: [ spec repository: 'github://rydnr/object-diff:main/src' ].
	^ spec
]

{ #category : #baselines }
BaselineOfPharoEDACore class >> includePharoEDAApi: spec [

	spec
		baseline: 'PharoEDAApi'
		with: [ spec repository: 'github://rydnr/pharo-eda-api:main' ].
	^ spec
]

{ #category : #baselines }
BaselineOfPharoEDACore class >> includePharoEDACommon: spec [

	spec
		baseline: 'PharoEDACommon'
		with: [ spec repository: 'github://rydnr/pharo-eda-common:main' ].
	^ spec
]

{ #category : #baselines }
BaselineOfPharoEDACore class >> includePharoEDAPorts: spec [

	spec
		baseline: 'PharoEDAPorts'
		with: [ spec repository: 'github://rydnr/pharo-eda-ports:main' ].
	^ spec
]

{ #category : #baselines }
BaselineOfPharoEDACore class >> includeSpec: spec [

	spec
		baseline: 'Spec2'
		with: [ spec repository: 'github://pharo-spec/Spec:Pharo10' ].
	^ spec
]

{ #category : #baselines }
BaselineOfPharoEDACore >> baseline: spec [

	<baseline>
	spec for: #common do: [ 
		spec blessing: #baseline.
		spec postLoadDoIt: #postload:package:.
		self class
			includeSpec: spec;
			includeBabyMock2: spec;
			includeObjectDiff: spec;
			includeNeoJSON: spec;
			includePharoEDACommon: spec;
			includePharoEDAApi: spec;
			includePharoEDAPorts: spec;
			declarePackagesIn: spec;
			declareGroupsIn: spec ]
]

{ #category : #baselines }
BaselineOfPharoEDACore >> postload: loader package: packageSpec [

	| location |
	location := (IceRepository registry detect: [ :each | 
		             each name = 'pharo-eda' ]) location.
	EDACIconProvider addDefaultLocation: location / 'resources' / 'icons'.
	EDACTranslationProvider addDefaultLocation:
		location / 'resources' / 'l10n'
]
