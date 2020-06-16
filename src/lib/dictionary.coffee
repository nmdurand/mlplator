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
	_.forEach wordList, (word)->
		sortedWord = sortLetters word
		if dictionary[sortedWord]?
			dictionary[sortedWord].push word
		else
			dictionary[sortedWord] = [word]
	dictionary

module.exports =
	class Dictionary

		init: ->
			console.log 'Initializing dictionary'
			wordList = await getWordList()
			@dictionary = await getDictionary wordList
			console.log 'Dictionary object populated.'

		getCombinations: (string)->
			sortedWord = sortLetters string
			@dictionary[sortedWord]
