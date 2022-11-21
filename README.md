# PharoEDA Adapters

This project discovers and provides adapters for PharoEDA applications's ports.

## Motivation

PharoEDA applications use ports and adapters, so they are decoupled from the actual technologies used.
This project provides adapters to choose from when launching `EDAApplication` instances.

## Design

PharoEDA-Adapters will inspect its environment and try to build functioning adapters. Once an adapter is properly built, it'll emit an event. PharoEDA has built-in support for consuming and projecting those events.

## Usage

First, load it with Metacello:

```smalltalk
Metacello new repository: 'github://rydnr/pharo-eda-adapters:main'; baseline: #PharoEDAAdapters; load
```

Then, run it with

```smalltalk
PharoEDAAdapters run
```

## Work in progress

- Support for current PharoEDA adapters: MongoDB, STOMP.

## Credits

- Background of the Pharo image by <a href="https://pixabay.com/users/pexels-2286921/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=1283313">Pexels</a> from <a href="https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=1283313">Pixabay</a>.
