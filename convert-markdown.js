var fs = require('fs')

var stats2markdown = function(datafile, mdfile, title) {
  var stats = require(datafile)

  var out = '# ' + title + '\n\n'
  out += 'GitHub has released [contributions](https://github.com/blog/1360-introducing-contributions) (summary of Pull Requests, opened issues and commits).\n\n'

  var today = new Date()
  var from = new Date()
  from.setYear(today.getFullYear() - 1)
  out += 'This is the count of contributions to public repos at GitHub.com from **' + from.toGMTString() + '** till **' + today.toGMTString() + '**.\n\n'

  out += 'To repeat:\n\n'
  out += '1. Take the first 1000 users in GitHub according to the count of followers (those with 150+ followers).\n'
  out += '2. Sort them by number of public contributions.\n\n'

  out += 'Made with data mining of GitHub.com ([raw data](https://gist.github.com/4524946), [script](https://github.com/paulmillr/top-github-users)).\n\n'
  out += 'By [@paulmillr](https://github.com/paulmillr) & [@lifesinger](https://github.com/lifesinger). Updated every sunday.\n\n'

  out += '<table cellspacing="0"><thead>'
  out += '<th scope="col">#</th>'
  out += '<th scope="col">Username</th>'
  out += '<th scope="col">Contributions</th>'
  out += '<th scope="col">Language</th>'
  out += '<th scope="col">Location</th>'
  out += '<th scope="col" width="30"></th>'
  out += '</thead><tbody>\n'

  stats.forEach(function(stat, index) {
    out += '<tr>'
    out += '<th scope="row">#' + (index + 1) + '</th>'
    out += '<td><a href="https://github.com/' + stat.username + '">' + stat.username + '</a>' + (stat.aka ? ' (' + stat.aka + ')' : '') + '</td>'
    out += '<td>' + stat.contributions + '</td>'
    out += '<td>' + stat.language + '</td>'
    out += '<td>' + (stat.location === 'Unknown' ? '' : stat.location) + '</td>'
    out += '<td><img width="30" height="30" src="' + stat.gravatar.replace('?s=140', '?s=30') + '"></td>'
    out += '</tr>\n'
  })

  out += '</tbody></table>'

  fs.writeFileSync(mdfile, out);
  console.log('Saved to ' + mdfile);
};

stats2markdown('./raw/github-users-stats.json', './formatted/active.md', 'Most active GitHub users');
