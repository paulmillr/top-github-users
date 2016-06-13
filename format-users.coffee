#!/usr/bin/env coffee
fs = require 'fs'

# Reducer.
minimum = (min, current) ->
  if current < min
    current
  else
    min

top = (stats, field, type) ->
  get = (stat) ->
    value = stat[field]
    if type is 'list' then value.length else value

  format = (stat) ->
    value = get stat
    switch type
      when 'thousands' then "#{(value / 1000)}k"
      else value

  stats
    .slice()
    .sort (a, b) ->
      get(b) - get(a)
    .slice(0, 15)
    .map (stat) ->
      login = stat.login
      "[#{login}](https://github.com/#{login}) (#{format stat})"
    .join ', '

stats2markdown = (datafile, mdfile, title) ->
  stats = require(datafile)
  minFollowers = stats.map((_) -> _.followers).reduce(minimum, 1000)
  maxNumber = 256

  today = new Date()
  from = new Date()
  from.setYear today.getFullYear() - 1

  out = """
  # Most active GitHub users ([git.io/top](http://git.io/top))

  The count of contributions (summary of Pull Requests, opened issues and commits) to public repos at GitHub.com from **#{from.toGMTString()}** till **#{today.toGMTString()}**.

  Only first 1000 GitHub users according to the count of followers are taken.
  This is because of limitations of GitHub search. Sorting algo in pseudocode:

  ```javascript
  githubUsers
    .filter(user => user.followers > #{minFollowers})
    .sortBy('contributions')
    .slice(0, #{maxNumber})
  ```

  Made with data mining of GitHub.com ([raw data](https://gist.github.com/4524946), [script](https://github.com/paulmillr/top-github-users)) by [@paulmillr](https://github.com/paulmillr) with contribs of [@lifesinger](https://github.com/lifesinger) and [@ahmetalpbalkan](https://github.com/ahmetalpbalkan). Updated once per week.

  <table cellspacing="0"><thead>
  <th scope="col">#</th>
  <th scope="col">User</th>
  <th scope="col">Contribs</th>
  <!-- Language currently disabled: GitHub returns 'Shell' for most users <th scope="col">Language</th> -->
  <th scope="col">Location</th>
  <th scope="col" width="30">Picture</th>
  </thead><tbody>\n
  """

  rows = stats
  .filter((stat) -> stat.contributions < 20000).slice(0, maxNumber).map (stat, index) ->
    """
    <tr>
      <th scope="row">##{index + 1}</th>
      <td><a href="https://github.com/#{stat.login}">#{stat.login}</a>#{if stat.name then ' (' + stat.name + ')' else ''}</td>
      <td>#{stat.contributions}</td>
      <!-- <td>#{stat.language}</td> -->
      <td>#{stat.location}</td>
      <td><img width="30" height="30" src="#{stat.gravatar.replace('?s=400', '?s=30')}"></td>
    </tr>
    """.replace(/\n/g, '')

  out += "#{rows.join('\n')}\n</tbody></table>\n\n"

  out += """## Top 10 users from this list by other metrics:

* **Followers:** #{top stats, 'followers', 'thousands'}
* **Organisations:** #{top stats, 'organizations', 'list'}
  """

  fs.writeFileSync mdfile, out
  console.log 'Saved to', mdfile

stats2markdown './raw/github-users-stats.json', './formatted/active.md'
