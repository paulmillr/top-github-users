all: get format

get: get-users get-stats
get-users:
	coffee get-users.coffee
get-stats:
	coffee get-stats.coffee

format: format-languages format-users
format-languages:
	coffee format-languages.coffee
format-users:
	coffee format-users.coffee
