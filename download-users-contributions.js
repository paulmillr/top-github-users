var utils = require('./utils');

var stats = require('./temp-github-users-no-contribs.json');
var MIN_CONTRIBUTIONS = 1;

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

var sortStats = function(stats) {
  return Object.keys(stats)
    .filter(function(username) {
      return stats[username].contributions >= MIN_CONTRIBUTIONS;
    })
    .sort(function(a, b) {
      return stats[b].contributions - stats[a].contributions;
    })
    .map(function(username) {
      return stats[username];
    });
};

utils.getPages(getProfileUrls(Object.keys(stats)), saveContributions, function() {
  utils.writeStats('./raw/github-users-stats.json', sortStats(stats));
})
