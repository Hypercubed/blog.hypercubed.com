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

			# Here are some old site urls that you would like to redirect from
			oldUrls: [
				'www.website.com',
				'website.herokuapp.com'
			]

			# The default title of our website
			title: "Hypercubed Blog"

			# The website description (for SEO)
			description: """
				When your website appears in search results in say Google, the text here will be shown underneath your website's title.
				"""

			# The website keywords (for SEO) separated by commas
			keywords: """
				place, your, website, keywoards, here, keep, them, related, to, the, content, of, your, website
				"""

			# The website author's name
			author: "J. Harshbarger"

			# The website author's email
			email: "hypercubed@gmail.com"

			# Styles
			styles: [
				"/styles/twitter-bootstrap.css"
				"/vendor/font-awesome/css/font-awesome.min.css"
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
			moment(date || @document.date).format(format || "MMM Do YYYY")

	# =================================
	# Collections
	# These are special collections that our website makes available to us

	collections:
		pages: (database) ->
			database.findAllLive({pageOrder: $exists: true}, [pageOrder:1,title:1])
            
		posts: (database) ->
			database.findAllLive({status:{$has:'publish'},tags:{$nin:['Links']}}, [date:-1]).on "add", (model) ->
				model.setMetaDefaults({layout: "post", standalone: true})

		links: (database) ->
			database.findAllLive({status:{$has:'publish'},tags:{$in:['Links']}}, [date:-1]).on "add", (model) ->
				model.setMetaDefaults({layout: "post", standalone: true})

	# =================================
	# Plugins

	plugins:
		downloader:
			downloads: [
				{
					name: 'Twitter Bootstrap'
					path: 'src/raw/vendor/twitter-bootstrap'
					url: 'https://codeload.github.com/twitter/bootstrap/tar.gz/master'
					tarExtractClean: true
				},
				{
					name: 'Font Awesome'
					path: 'src/raw/vendor/font-awesome'
					url: 'https://codeload.github.com/FortAwesome/Font-Awesome/tar.gz/master'
					tarExtractClean: true
				}
			]


	# =================================
	# DocPad Events

	# Here we can define handlers for events that DocPad fires
	# You can find a full listing of events on the DocPad Wiki
	events:

		# Server Extend
		# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server} = opts
			docpad = @docpad

			# As we are now running in an event,
			# ensure we are using the latest copy of the docpad configuraiton
			# and fetch our urls from it
			latestConfig = docpad.getConfig()
			oldUrls = latestConfig.templateData.site.oldUrls or []
			newUrl = latestConfig.templateData.site.url

			# Redirect any requests accessing one of our sites oldUrls to the new site url
			server.use (req,res,next) ->
				if req.headers.host in oldUrls
					res.redirect(newUrl+req.url, 301)
				else
					next()
					
	environments:
		development:
			templateData:
				site:
					services:
						googleAnalytics: false
					url:
						'http://localhost:9778'
			ignoreCustomPatterns: /2010|2009|2008|2007|2006|2005|2000/
			#ignoreCustomPatterns: /2005/

}


# Export our DocPad Configuration
module.exports = docpadConfig