import _ from 'lodash'
import stringUtils from './string'

import wordListRaw from 'french-wordlist/words.txt'

sortLetters = (word)->
	normalizedWord = stringUtils.normalize(word)
	_.sortBy(normalizedWord).join ''

getWordList = ->
	wordListRaw.split '\n'

getDictionary = (wordList)->
	dictionary = {}
	_.forEach wordList, (word)->
		sortedWord = sortLetters word
		if dictionary[sortedWord]?
			dictionary[sortedWord].push word
		else
			dictionary[sortedWord] = [word]
	dictionary


export default class Dictionary

	constructor: ->

	init: =>
		console.log 'Initializing dictionary'
		wordList = await getWordList()
		@dictionary = await getDictionary wordList
		console.log 'Dictionary object populated.'

	getCombinations: (string)=>
		console.log 'Getting combinations', string
		sortedWord = sortLetters string
		@dictionary[sortedWord]
