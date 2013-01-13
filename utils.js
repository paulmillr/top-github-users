// Thanks to https://gist.github.com/2657075

var fs = require('fs')
var https = require('https')
var GROUP_MAX = 1000


exports.getPages = function(urls, stepCallback, finalCallback) {
  var totalCount = urls.length
  var fetchedCount = 0

  var groupCount = Math.ceil(totalCount / GROUP_MAX)
  var groups = []

  if (totalCount > GROUP_MAX) {
    for (var i = 1; i <= groupCount; i++) {
      groups.push(urls.slice((i - 1) * GROUP_MAX, i * GROUP_MAX))
    }
  }
  else {
    groups.push(urls)
  }

  getGroup()


  function getGroup() {
    var group = groups.shift()
    if (group) {
      getUrls(group, getGroup)
    }
  }

  function getUrls(urls, groupCallback) {
    var count = urls.length;
    var i = 0;

    var getUrl = function(url, callback) {
      console.log('  Fetching ' + url);

      https.get(url, function(res) {
        var html = ''
        res.on('data', function(data) {
          html += data
        });

        res.on('end', function() {
          console.log('  ' + ++fetchedCount + '/' + totalCount
              + ' Fetched ' + url)
          callback(html)
        });

      }).on('error', function(e) {
        console.log('Got error: ' + e.message)
        process.exit(1)
      });
    };

    urls.forEach(function(url) {
      getUrl(url, function(html) {
        stepCallback(html, url)
        i += 1;
        if (i === count) {
          groupCallback()
        }

        if (fetchedCount === totalCount) {
          finalCallback();
        }
      })
    });
  }
}


exports.writeStats = function(filename, stats) {
  fs.writeFileSync(filename, JSON.stringify(stats, null, 2));
  console.log('  Saved to ' + filename);
}

