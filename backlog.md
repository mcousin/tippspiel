# Epics
* show stats on starting page
* create chat area on starting page, displaying also status messages (Matchday winner, new )
* show current matchday on starting page


# User Stories
## To Do

* create template for starting page at GET /users/1
* show part of ranking on starting page
* show current matchday on starting page

* highlight current user within ranking
* find better solution for forms for bets on matchdays view
* re-think ranking. More elegant solution for determining a user's rank?
* hide buttons for regular users only admins should see (already in users index -> good solution?)

* create league: name, has_many matchdays, has_many communities
* create community: name, has_many users, has_many leagues
* user has_many communities
* move ranking page to GET /community/1

## In Progress
* limit access rights for non-admin users (!=admin=>redirect_to_where??? last page?)

## Done
* show matches/bets on matchdays page for the selected matchday
* add sign up form (only non-admins should be creatable here!)
* add admin column to users table
* make sure form for bets on matchdays view works also for non-existing bets
* user twitter bootstrap buttons etc for matchday view
* make sure form for bets on matchdays view works also for non-existing bets
* create ranking page at GET /users/
* add model functionality to matchdays: ordering matchdays, current matchday ...