fs = require('fs').promises
_ = require 'lodash'
stringUtils = require './string'

wordListPath = require 'french-wordlist'

sortLetters = (word)->
	normalizedWord = stringUtils.normalize(word)
	_.sortBy(normalizedWord).join()

getWordList = ->
	data = await fs.readFile wordListPath, 'utf8'
	data.split '\n'

getDictionary = (wordList)->
	dictionary = {}
	dictionaryPromise = Promise.resolve()
	_.forEach wordList, (word)->
		dictionaryPromise = dictionaryPromise.then ->
			sortedWord = sortLetters word
			if dictionary[sortedWord]?
				dictionary[sortedWord].push word
			else
				dictionary[sortedWord] = [word]
			dictionary
	dictionaryPromise

((string)->
	wordList = await getWordList()
	dictionary = await getDictionary wordList
	console.log 'Dictionary object is populated.'

	sortedWord = sortLetters string

	result = dictionary[sortedWord]
	console.log '>>> Result:', result
) 'permanente'
