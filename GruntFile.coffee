path = require 'path'
_ = require 'lodash'

HtmlWebpackPlugin = require 'html-webpack-plugin'

LIVERELOAD_PORT = parseInt(process.env.LRPORT ?= 29103)

WEBPACK_CONFIG =
	context: path.join __dirname,'src'
	entry: './scripts/main.coffee'
	output:
		filename: 'main.js'
	target: 'web'
	module:
		rules: [
			test: /\.coffee$/,
			loader: 'coffee-loader'
			options:
				transpile:
					presets: ['@babel/preset-env']
					plugins: ['@babel/plugin-transform-runtime']
		,
			test: /\.s?css$/
			use: [
				'style-loader',
				'css-loader',
				'sass-loader'
			]
		,
			test: /\.txt$/i,
			use: 'raw-loader'
		]
	plugins: [
		new HtmlWebpackPlugin
			template: 'index.html'
			favicon: './images/favicon.png'
	]
	resolve:
		extensions: ['.js','.coffee']
		modules: ['src','node_modules']

getWebpackConfig = (options={})->
	config = _.cloneDeep WEBPACK_CONFIG

	if options.devMode
		config.mode = 'development'
		config.output.path = path.resolve '<%= config.buildFolder %>/public'
		config.devtool = 'inline-source-map'
	else
		config.mode = 'production'
		config.output.path = path.resolve '<%= config.distFolder %>/public'

	config


module.exports = (grunt)->
	require('load-grunt-tasks')(grunt)
	require('time-grunt')(grunt)

	grunt.initConfig
		config:
			srcFolder: 'src'
			buildFolder: 'build'

		clean:
			build: ['<%= config.buildFolder %>']

		webpack:
			appDev: getWebpackConfig
				devMode: true

			appProd: getWebpackConfig()

		'webpack-dev-server':
			options:
				webpack: getWebpackConfig
					devMode: true
				host: '0.0.0.0'
				open: true
				port: 8484
				compress: true
				disableHostCheck: true

		watch:
			public_build:
				options:
					livereload: LIVERELOAD_PORT
				files: ['<%= config.srcFolder %>/**/*']
				tasks: ['webpack:appDev']

		grunt.registerTask 'serve', [
			'webpack-dev-server:appDev'
		]

		grunt.registerTask 'build', [
			'clean'
			'webpack:appProd'
		]
