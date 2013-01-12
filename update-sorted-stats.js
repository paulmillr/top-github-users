var util = require('./util');
var MIN_CONTRIBUTIONS = 0;

var sortStats = function(filename, outfile) {
  var stats = require(filename);
  var sorted = Object.keys(stats)
    .filter(function(username) {
      return stats[username].contributions > MIN_CONTRIBUTIONS;
    })
    .sort(function(a, b) {
      return stats[b].contributions - stats[a].contributions;
    })
    .map(function(username) {
      return stats[username];
    });

  util.saveStats(outfile, sorted);
};

sortStats('./github-users-stats.json', 'github-users-sorted-stats.json');
