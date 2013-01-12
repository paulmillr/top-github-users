var util = require('./util')
var stats = require('./github-users-stats.json')

var parseContributions = function(html) {
  var m = html.match(/<span class="num">([\d,]+) Total<\/span>/) || []
  return parseInt((m[1] || '').replace(/,/g, '')) || 0
};

var getUsername = function(url) {
  var parts = url.split('/')
  return parts[parts.length - 1]
};

var saveContributions = function(html, url) {
  var username = getUsername(url)
  stats[username].contributions = parseContributions(html)
};

var getProfileUrls = function(usernames) {
  return usernames.map(function(username) {
    return 'https://github.com/' + username
  })
};

util.getPages(getProfileUrls(Object.keys(stats)), saveContributions, function() {
  util.saveStats('github-users-stats.json', stats)
})
