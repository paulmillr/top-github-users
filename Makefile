all: download stats

download:
	coffee download-top-users.coffee
	coffee download-users-stats.coffee

stats:
	coffee update-language-stats.coffee
	coffee convert-markdown.coffee
