all: get format

get:
	coffee get-users.coffee
	coffee get-details.coffee

format:
	coffee format-languages.coffee
	coffee format-users.coffee

sync:
	cd raw && git commit -am 'Update stats.' && git push && \
	cd ../formatted && git commit -am 'Sync.' --amend && git push --force
