"
Class:
I'm the parent class for EDA-based applications.

Responsibilities: 
- I'm in charge of bootstrapping the EDA application.
- I configure the EventStore, the repositories, the projections, the STOMP clients.

Collaborators:
- I use Pharo Settings to know how to access the event store, the projections, the STOMP queues and exchanges.
- I can send Announcements.

Public API and Key Messages

- EDAApplication class >> setup : Bootstraps and sets up the adapters for the Event Store, Projections, STOMP clients.
- EDAApplication class >> start: Starts accepting incoming commands.
- EDAApplication class >> stop: To stop accepting incoming commands.
- EDAApplications are not designed to be instantiated.

Internal Representation and Key Implementation Points.

- There're some settings mapped to EDAApplication. 
"
Class {
	#name : #EDAApplication,
	#superclass : #Object,
	#traits : 'EDACLogging',
	#classTraits : 'EDACLogging classTrait',
	#instVars : [
		'commandBuilder',
		'commandConsumer',
		'commandDispatcher',
		'eventAnnouncer',
		'eventProducer',
		'eventStore',
		'isConfigured',
		'isStarted',
		'projectorsByTenant',
		'applicationName',
		'portSettings',
		'settingsAnnouncer',
		'description',
		'iconProvider',
		'iconName',
		'projectionSynchronizationEnabled'
	],
	#category : #'EDA-Application-Core'
}

{ #category : #accessing }
EDAApplication class >> applicationName [
	self subclassResponsibility
]

{ #category : #setup }
EDAApplication class >> buildCommandDispatcherWithEventStore: anEventStore eventProducer: anEventProducer andProjectorClass: aClass [
	| handlerScanner handlerFactory commandRegistry |
	handlerScanner := EDAPragmaCommandHandlerMethodsScanner
		scannerPragma: #useAsCommandHandlerFor:
		from: EDAAggregateRoot.
	handlerFactory := EDACommandHandlerFactory
		factoryWithEventStore: anEventStore
		eventBus: anEventProducer.
	commandRegistry := EDACommandHandlersRegistry
		withScanner: handlerScanner
		factory: handlerFactory
		andProjectorClass: aClass.
	^ EDACommandDispatcher
		withRegistry: commandRegistry
		eventStore: anEventStore
		eventProducer: anEventProducer
		andProjectorClass: aClass
]

{ #category : #accessing }
EDAApplication class >> defaultEnvironment [
	^ DUEnvironment new
]

{ #category : #logging }
EDAApplication class >> logDebugMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings debugEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'DEBUG'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAApplication class >> logErrorMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings errorEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'ERROR'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAApplication class >> logInfoMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings infoEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'INFO '
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAApplication class >> logTraceMessage: aMessage beautify: aBoolean [
	EDACLoggingSettings traceEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'TRACE'
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #logging }
EDAApplication class >> logWarningMessage: aMessage beautify: aBoolean [
	^ EDACLoggingSettings warningEnabled
		ifTrue: [ self
				logMessage: aMessage
				inCategory: 'WARN '
				inStream: self defaultStream
				beautify: aBoolean ]
]

{ #category : #'instance creation' }
EDAApplication class >> new [
	MessageNotUnderstood
		signal: 'Use ' , self class printString , '>>withName: or ' , self class printString , '>>unnamed instead'
]

{ #category : #'instance creation' }
EDAApplication class >> unnamed [
	^ self withName: self applicationName

]

{ #category : #'instance creation' }
EDAApplication class >> withName: anApplicationName [
	| result |
	(EDAApplications uniqueInstance edaApplications
		select: [ :app | app applicationName = anApplicationName ])
		ifEmpty: [ result := self basicNew initialize.
			result applicationName: anApplicationName.
			EDAApplications uniqueInstance register: result ]
		ifNotEmpty: [ :c | result := c first ].
	^ result
]

{ #category : #'instance creation' }
EDAApplication class >> withName: anApplicationName andDescription: aDescription [
	| result |
	(EDAApplications uniqueInstance edaApplications
		select: [ :app | app applicationName = anApplicationName ])
		ifEmpty: [ result := self basicNew initialize.
			result applicationName: anApplicationName; description: aDescription.
			EDAApplications uniqueInstance register: result ]
		ifNotEmpty: [ :c | result := c first. result description: aDescription ].
	^ result
]

{ #category : #'instance creation' }
EDAApplication class >> withName: anApplicationName description: aDescription andIconName: anIconName [

	| result |
	(EDAApplications uniqueInstance edaApplications select: [ :app | 
		 app applicationName = anApplicationName ])
		ifEmpty: [ 
			result := self basicNew initialize.
			result
				applicationName: anApplicationName;
				description: aDescription;
				iconName: anIconName.
			EDAApplications uniqueInstance register: result ]
		ifNotEmpty: [ :c | 
			result := c first.
			result
				description: aDescription;
				iconName: anIconName ].
	^ result
]

{ #category : #accessing }
EDAApplication >> applicationName [
	^ applicationName ifNil: [ self class applicationName ]
]

{ #category : #accessing }
EDAApplication >> applicationName: aString [
	applicationName := aString
]

{ #category : #accessing }
EDAApplication >> commandBuilder [

	^ commandBuilder ifNil: [ 
		  self commandBuilder: (EDADefaultCommandBuilder forApplication: self).
		  commandBuilder ]
]

{ #category : #accessing }
EDAApplication >> commandBuilder: aBuilder [

	commandBuilder := aBuilder
]

{ #category : #subclassresponsibility }
EDAApplication >> commandClassPrefix [

	^ ''
]

{ #category : #accessing }
EDAApplication >> commandConsumer [
	^ commandConsumer
]

{ #category : #accessing }
EDAApplication >> commandConsumer: anObject [
	commandConsumer := anObject
]

{ #category : #accessing }
EDAApplication >> commandDispatcher [
	^ commandDispatcher
]

{ #category : #accessing }
EDAApplication >> commandDispatcher: anObject [
	commandDispatcher := anObject
]

{ #category : #accessing }
EDAApplication >> commandListenerSettings [

	^ self portSettings commandListenerSettings
]

{ #category : #files }
EDAApplication >> configFolder [

	^ self rootFolder / 'config'
]

{ #category : #files }
EDAApplication >> contractsFolder [

	^ self rootFolder / 'contracts'
]

{ #category : #accessing }
EDAApplication >> description [

	^ description ifNil: [ self applicationName ]
]

{ #category : #accessing }
EDAApplication >> description: aString [

	description := aString
]

{ #category : #'class initialization' }
EDAApplication >> doInitialize [

	self iconProvider: EDACIconProvider new.
	self isStarted: false.
	self isConfigured: false.
	self resetPortSettings.
	self projectorsByTenant: Dictionary new.
	self setupEventAnnouncer
]

{ #category : #setup }
EDAApplication >> doSetup [

	self setupLogging.
	self setupEventAnnouncer.
	self setupEventProducer.
	self setupEventStore.
	self setupProjectors.
	self enableSynchronization ifTrue: [ self synchronizeProjections ].
	self setupCommandDispatcher.
	self setupCommandConsumer.
	self setupEventSubscriptions.
	self setupCommandBuilder
]

{ #category : #accessing }
EDAApplication >> enableSynchronization [

	^ projectionSynchronizationEnabled ifNil: [ self enableSynchronization: true. projectionSynchronizationEnabled ]
]

{ #category : #accessing }
EDAApplication >> enableSynchronization: aBoolean [

	projectionSynchronizationEnabled := aBoolean
]

{ #category : #accessing }
EDAApplication >> environmentSettings [

	^ self portSettings environmentSettings
]

{ #category : #accessing }
EDAApplication >> eventAnnouncer [
	^ eventAnnouncer
]

{ #category : #accessing }
EDAApplication >> eventAnnouncer: anObject [
	eventAnnouncer := anObject
]

{ #category : #subclassresponsibility }
EDAApplication >> eventBaseClass [

	^ self subclassResponsibility
]

{ #category : #subclassresponsibility }
EDAApplication >> eventClassPrefix [

	^ ''
]

{ #category : #accessing }
EDAApplication >> eventProducer [
	^ eventProducer
]

{ #category : #accessing }
EDAApplication >> eventProducer: anObject [
	eventProducer := anObject
]

{ #category : #accessing }
EDAApplication >> eventPublisherSettingsPort [
	^ self resolveEventPublisherSettingsPort
]

{ #category : #accessing }
EDAApplication >> eventStore [
	^ eventStore
]

{ #category : #accessing }
EDAApplication >> eventStore: anObject [
	eventStore := anObject
]

{ #category : #accessing }
EDAApplication >> eventStoreSettingsPort [
		^ self portSettingsPort eventStoreSettingsPort
]

{ #category : #accessing }
EDAApplication >> eventStoreSettingsPort: anAdapter [
	anAdapter = self portSettingsPort eventStoreSettingsPort
		ifTrue: [ ^ self ].
	self notifyEventStoreSettingsPortListener: anAdapter
]

{ #category : #accessing }
EDAApplication >> icon [

	^ iconProvider iconNamed: self iconName
]

{ #category : #accessing }
EDAApplication >> iconName [

	^ iconName
]

{ #category : #accessing }
EDAApplication >> iconName: aString [

	iconName := aString
]

{ #category : #accessing }
EDAApplication >> iconProvider [

	^ iconProvider
]

{ #category : #accessing }
EDAApplication >> iconProvider: anObject [

	iconProvider := anObject
]

{ #category : #initialization }
EDAApplication >> initialize [
	super initialize.
	self doInitialize
]

{ #category : #accessing }
EDAApplication >> isConfigured [
	^ isConfigured
]

{ #category : #accessing }
EDAApplication >> isConfigured: aBoolean [
	isConfigured := aBoolean
]

{ #category : #accessing }
EDAApplication >> isStarted [
	^ isStarted
]

{ #category : #accessing }
EDAApplication >> isStarted: aBoolean [
	isStarted := aBoolean
]

{ #category : #logging }
EDAApplication >> logSettings [
	self
		logDebugMessage: 'Command consumer: ' , self commandConsumer greaseString.
	self
		logDebugMessage: 'Command dispatcher: ' , self commandDispatcher greaseString.
	self
		logDebugMessage:
			'Command listener client debug: '
				, self commandListenerClientDebug greaseString.
	self
		logDebugMessage: 'Event announcer: ' , self eventAnnouncer greaseString.
	self
		logDebugMessage: 'Event producer: ' , self eventProducer greaseString.
	self logDebugMessage: 'Event store: ' , self eventStore greaseString.
	self
		logDebugMessage:
			'Projection synchronization enabled: '
				, self enableSynchronization greaseString.
	self
		logDebugMessage: 'Projectors: ' , self projectorsByTenant greaseString
]

{ #category : #accessing }
EDAApplication >> loggingSettingsPort [
	^ self resolveLoggingSettingsPort
]

{ #category : #accessing }
EDAApplication >> notifyEnvironmentChangedFrom: oldValue to: newValue [

	self settingsAnnouncer announce:
		(EDASEnvironmentChanged old: oldValue new: newValue on: self)
]

{ #category : #accessing }
EDAApplication >> portSettings [

	^ portSettings ifNil: [ 
		  | result |
		  result := EDASPortSettingsInMemoryAdapter withAnnouncer:
			            self settingsAnnouncer.
		  self portSettings: result.
		  result ]
]

{ #category : #accessing }
EDAApplication >> portSettings: anAdapter [

	portSettings := anAdapter
]

{ #category : #accessing }
EDAApplication >> projectionSettingsPort [
	^ self resolveProjectionsSettingsPort
]

{ #category : #accessing }
EDAApplication >> projectorsByTenant [
	| result |
	result := projectorsByTenant.
	result
		ifNil: [ result := Dictionary new.
			self projectorsByTenant: result ].
	^ result
]

{ #category : #accessing }
EDAApplication >> projectorsByTenant: aDictionary [
	projectorsByTenant := aDictionary
]

{ #category : #reset }
EDAApplication >> reset [
	self resetPortResolver.
	self resetLogging.
	self resetEventProducer.
	self resetEventStore.
	self resetRepositories.
	self resetProjections.
	self resetProjectors.
	self resetCommandDispatcher.
	self resetCommandConsumer.
	self resetEventSubscriptions.
	self resetEventAnnouncer.
	self resetSettingsAnnouncer.
	self isConfigured: false
]

{ #category : #'reset - commands' }
EDAApplication >> resetCommandConsumer [
	self commandConsumer ifNotNil: [ :c | c close ].
	self commandConsumer: nil
]

{ #category : #'reset - commands' }
EDAApplication >> resetCommandDispatcher [
	self commandDispatcher: nil
]

{ #category : #'reset - events' }
EDAApplication >> resetEventAnnouncer [
	self eventAnnouncer: nil
]

{ #category : #'reset - events' }
EDAApplication >> resetEventProducer [
	self eventProducer ifNotNil: [ :producer | producer close ].
	self eventProducer: nil
]

{ #category : #'reset - events' }
EDAApplication >> resetEventStore [
	self eventStore: nil
]

{ #category : #'reset - events' }
EDAApplication >> resetEventSubscriptions [
	self subclassResponsibility
]

{ #category : #reset }
EDAApplication >> resetLogging [
	EDALogEvent announcer
		unsubscribe: EDALogEvent
]

{ #category : #reset }
EDAApplication >> resetPortSettings [

	self portSettings: nil
]

{ #category : #'reset - projections' }
EDAApplication >> resetProjections [
	"nothing to do"
	
]

{ #category : #'reset - projections' }
EDAApplication >> resetProjectorOfTenant: aTenant [
	| projector |
	projector := self projectorsByTenant at: aTenant ifAbsent: [ nil ].
	projector
		ifNotNil: [ :p | p class synchronizationInProgressOfTenant: aTenant is: false .
	self projectorsByTenant removeKey: aTenant ]
]

{ #category : #'reset - projections' }
EDAApplication >> resetProjectors [
	self retrieveAllTenants do: [ :t | self resetProjectorOfTenant: t ]


]

{ #category : #'reset - repositories' }
EDAApplication >> resetRepositories [
	EDAAggregateRepository allSubclassesDo: [ :repo | repo eventStore: nil ]
]

{ #category : #'reset - events' }
EDAApplication >> resetSettingsAnnouncer [
	self settingsAnnouncer: nil
]

{ #category : #accessing }
EDAApplication >> resolveSettingsPort: aPort [

	| candidates candidate |
	candidates := (aPort traitUsers select: [ :cls | cls accepts: aPort inApp: self ])
		              sorted.
	candidate := candidates
		             ifEmpty: [ nil ]
		             ifNotEmpty: [ :col | col first ].
	^ candidate ifNil: [ nil ] ifNotNil: [ :c | c withApp: self ]
]

{ #category : #'multitenancy support' }
EDAApplication >> retrieveAllTenants [

	^ OrderedCollection with: 'default'
]

{ #category : #files }
EDAApplication >> rootFolder [

	^ FileSystem workingDirectory / self applicationName
]

{ #category : #accessing }
EDAApplication >> settingsAnnouncer [
	settingsAnnouncer ifNil: [ self settingsAnnouncer: (EDASSettingsAnnouncer forApp: self) ].
	^ settingsAnnouncer
]

{ #category : #accessing }
EDAApplication >> settingsAnnouncer: anAnnouncer [
	settingsAnnouncer := anAnnouncer 
]

{ #category : #setup }
EDAApplication >> setup [
	self isConfigured ifNil: [ self isConfigured: false ].
	self isConfigured ifTrue: [ ^ self ].
	self doSetup.
	self isConfigured: true
]

{ #category : #'setup - commands' }
EDAApplication >> setupCommandBuilder [

	^ self commandBuilder: (EDADefaultCommandBuilder forApplication: self)
]

{ #category : #'setup - commands' }
EDAApplication >> setupCommandConsumer [

	^ self setupCommandConsumerWithCommandListener:
		  (EDAACommandStompTopicListener withConfig: self portSettings commandListenerSettings forApplication: self)
]

{ #category : #'setup - commands' }
EDAApplication >> setupCommandConsumerWithCommandListener: listener [

	| materializer |
	listener client debug:
		self portSettings commandListenerSettings debug.
	materializer := EDAJsonCommandMaterializer forApplication: self.
	self commandConsumer: (EDAPCommandConsumer
			 busListener: listener
			 commandMaterializer: materializer
			 commandDispatcher: self commandDispatcher
			 andSettings: self commandListenerSettings)
]

{ #category : #setup }
EDAApplication >> setupCommandDispatcher [

	| handlerScanner handlerFactory commandRegistry |
	handlerScanner := EDAPragmaCommandHandlerMethodsScanner
		                  scannerPragma: #useAsCommandHandlerFor:
		                  from: EDAAggregateRoot.
	handlerFactory := EDACommandHandlerFactory
		                  factoryWithEventStore: self eventStore
		                  eventBus: self eventProducer.
	commandRegistry := EDACommandHandlersRegistry
		                   withScanner: handlerScanner
		                   factory: handlerFactory
		                   andProjectorClass: EDACompositeProjector.
	self commandDispatcher:
		(EDACommandDispatcher withRegistry: commandRegistry eventStore: self eventStore eventProducer: self eventProducer andProjectorClass: EDACompositeProjector)
]

{ #category : #'setup - events' }
EDAApplication >> setupEventAnnouncer [
	self eventAnnouncer: Announcer new
]

{ #category : #'setup - events' }
EDAApplication >> setupEventProducer [
	| eventPublisher eventSerializer |
	eventPublisher := EDAAEventStompTopicPublisher new.
	eventSerializer := EDAJsonEventSerializer new.
	self eventProducer: (EDAPEventProducer publisher: eventPublisher serializer: eventSerializer announcer: self eventAnnouncer)
]

{ #category : #'setup - events' }
EDAApplication >> setupEventStore [

	self eventStore: self portSettings eventStoreSettings buildAdapter.
	EDAAggregateRepository allSubclassesDo: [ :repo | 
		repo setupEventStore: self eventStore ]
]

{ #category : #'setup - events' }
EDAApplication >> setupEventSubscriptions [
	self subclassResponsibility 
]

{ #category : #setup }
EDAApplication >> setupLogging [
	EDALogEvent announcer
		when: EDALogEvent
		do: [ :event | self logInfoMessage: event greaseString ]
]

{ #category : #'setup - projections' }
EDAApplication >> setupProjectorOfTenant: aTenant [
	self
		projectorsByTenant at: aTenant put:
			(EDACompositeProjector
				ofTenant: aTenant
				withAllProjectorsAndEventStore: self eventStore)
]

{ #category : #'setup - projections' }
EDAApplication >> setupProjectors [
	self retrieveAllTenants do: [ :tenant | self setupProjectorOfTenant: tenant ]
]

{ #category : #api }
EDAApplication >> start [
	self setup.
	self isStarted ifNil: [ self isStarted: false ].
	self isStarted
		ifTrue: [ ^ self ].
	self commandConsumer
		ifNotNil: [ :c | 
			c start.
			self isStarted: true ].
	self logInfoMessage: self applicationName , ' started'
]

{ #category : #api }
EDAApplication >> stop [
	self isStarted ifNil: [ self isStarted: false ].
	self isStarted
		ifFalse: [ ^ self ].
	self commandConsumer ifNotNil: [ :arg | arg stop ].
	self isStarted: false.
	self logInfoMessage: self applicationName , ' stopped'
]

{ #category : #'setup - projections' }
EDAApplication >> synchronizeProjections [
	self retrieveAllTenants
		do: [ :tenant |
			| projector |
			projector := self projectorsByTenant at: tenant ifAbsent: [ nil ].
			projector ifNotNil: [ :p | p projectOfTenant: tenant ] ]
]

{ #category : #'setup - projections' }
EDAApplication >> synchronizeProjectionsOfTenant: aTenant [
	| projector |
	projector := self projectorsByTenant at: aTenant ifAbsent: [ nil ].
	projector ifNotNil: [ :p | p projectOfTenant: aTenant ]
]
