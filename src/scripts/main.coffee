import '../styles/main.scss'

import $ from 'jquery'

import Dictionary from './lib/dictionary'

( ->
	dictionary = new Dictionary()
	await dictionary.init()

	$('.actionButton').on 'click', ->
		str = $('.inputField').val()

		results = dictionary.getCombinations str
		if results
			$('.results').empty()
			if results.length is 1
				$('.results').append "<div class='subTitle'>1 mot trouvé :</div>"
			else
				$('.results').append "<div class='subTitle'>#{results.length} mots trouvés :</div>"
			for result in results
				$('.results').append "<div class='word'>#{result}</div>"
		else
			$('.results').empty()
			$('.results').html 'Aucun mot trouvé.'

)()
