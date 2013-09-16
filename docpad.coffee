moment = require 'moment'

# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
docpadConfig = {

	# =================================
	# Template Data
	# These are variables that will be accessible via our templates
	# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

	templateData:

		# Specify some site properties
		site:
			# The production url of our website
			url: "http://blog.hypercubed.com"

			# The default title of our website
			title: "Hypercubed"

			# The website description (for SEO)
			description: ""

			# The website keywords (for SEO) separated by commas
			keywords: ""

			# The website author's name
			author: "J. Harshbarger"

			# The website author's email
			email: "hypercubed@gmail.com"

			# Styles
			styles: [
				"//netdna.bootstrapcdn.com/twitter-bootstrap/2.3.2/css/bootstrap-combined.no-icons.min.css"
				"//netdna.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.css"
				"/styles/tomorrow-night-eighties.css"
				"/styles/style.css"
			]

			# Scripts
			scripts: [
				"//cdnjs.cloudflare.com/ajax/libs/jquery/1.9.1/jquery.min.js",
				"//cdnjs.cloudflare.com/ajax/libs/modernizr/2.6.2/modernizr.min.js",
				"/vendor/twitter-bootstrap/js/bootstrap-affix.js",
				"/scripts/script.js"
			]
			
			services:
				disqus: 'hypercubedblog'
				googleAnalytics: 'UA-102465-1'

		# -----------------------------
		# Helper Functions

		# Get the prepared site/document title
		# Often we would like to specify particular formatting to our pages title
		# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the sites title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
			# if our document does not have its own title, then we should just use the sites title
			else
				@site.title

		# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the sites description
			@document.description or @site.description

		# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')
		
		getFormattedDate: (date, format) ->
			moment(date || @document.date).format(format || "MMM DD YYYY")

	# =================================
	# Collections
	# These are special collections that our website makes available to us

	collections:
		pages: (database) ->
			database.findAllLive({pageOrder: $exists: true}, [pageOrder:1,title:1])
            
		posts: (database) ->
			database.findAllLive({status:{$has:'publish'},tags:{$nin:['Links']}}, [date:-1]).on "add", (model) ->
				model.setMetaDefaults({layout: "post", standalone: true, collection: 'posts'})

		links: (database) ->
			database.findAllLive({status:{$has:'publish'},tags:{$in:['Links']}}, [date:-1]).on "add", (model) ->
				model.setMetaDefaults({layout: "post", standalone: true, collection: 'links'})

		drafts: (database) ->
			database.findAllLive({status:{$has:'draft'}}, [date:-1]).on "add", (model) ->
				model.setMetaDefaults({layout: "post", standalone: true, collection: 'drafts'})
					
	environments:
		development:
			templateData:
				site:
					services:
						googleAnalytics: false
					url:
						'/'
			#ignoreCustomPatterns: /2009|2008/
			ignoreCustomPatterns: /2010|200./
		static:
			ignoreCustomPatterns: /drafts/
}


# Export our DocPad Configuration
module.exports = docpadConfig