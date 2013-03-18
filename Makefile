all: get format

get:
	coffee get-users.coffee
	coffee get-stats.coffee

format:
	coffee format-languages.coffee
	coffee format-users.coffee
