make && \
  cd raw && git commit -am 'Update stats.' && git push && \
  cd ../formatted && git commit -am 'Sync.' --amend && git push --force
