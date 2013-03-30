all: get format

get:
	coffee get-users.coffee
	coffee get-details.coffee

format:
	coffee format-languages.coffee
	coffee format-users.coffee
