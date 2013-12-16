all: get format

get:
	coffee get-users.coffee
	coffee get-details.coffee

format:
	coffee format-languages.coffee
	coffee format-users.coffee

sync: sync-raw sync-formatted
force-sync: force-sync-raw sync-formatted

sync-raw:
	cd raw && git commit -am 'Update stats.' && git push

force-sync-raw:
	cd raw && git commit -am 'Update stats.' --amend && git push --force

sync-formatted:
	cd formatted && git commit -am 'Sync.' --amend && git push --force

