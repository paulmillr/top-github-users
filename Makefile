all: download stats

download:
	node download-users-stats.js
	node download-users-contributions.js

stats:
	node update-language-stats.js
	node convert-markdown.js
