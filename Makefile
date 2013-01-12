all: download stats

download:
	node update-users-stats.js
	node update-users-contributions.js

stats:
	node update-sorted-stats.js
	node update-language-stats.js
	node markdown-converter.js
