Dictionary = require './lib/dictionary'

((string)->
	dictionary = new Dictionary()
	await dictionary.init()

	result = dictionary.getCombinations string
	console.log '>>>', result.length,'Mots trouvés :', result
) 'nrevrolaeutinoi'
