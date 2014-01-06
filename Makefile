1:
	mv temp-logins.json old-logins.json
	coffee get-users.coffee
	coffee check-logins.coffee

2:
	coffee get-details.coffee

3:
	coffee format-languages.coffee
	coffee format-users.coffee

4: sync-raw sync-formatted

sync: sync-raw sync-formatted
force-sync: force-sync-raw sync-formatted

sync-raw:
	cd raw && git commit -am 'Update stats.' && git push

force-sync-raw:
	cd raw && git commit -am 'Update stats.' --amend && git push --force

sync-formatted:
	cd formatted && git commit -am 'Sync.' --amend && git push --force

