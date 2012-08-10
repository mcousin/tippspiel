# Epics
* show stats on starting page
* create chat area on starting page, displaying also status messages (Matchday winner, new )


# User Stories
## To Do
* show only part of ranking on starting page (set @users variable accordingly)
* CSV import for matches/matchdays
* use flash messages (notice and alert)
* change submit button label on user profile
* highlight current user within ranking
* re-think ranking. More elegant solution for determining a user's rank?
* create league: name, has_many matchdays, has_many communities
* create community: name, has_many users, has_many leagues
* user has_many communities
* move ranking page to GET /community/1

## In Progress


## Done
* create template for starting page at GET /users/1
* show part of ranking on starting page
* show current matchday on starting page
* show matches/bets on matchdays page for the selected matchday
* add sign up form (only non-admins should be creatable here!)
* add admin column to users table
* make sure form for bets on matchdays view works also for non-existing bets
* user twitter bootstrap buttons etc for matchday view
* make sure form for bets on matchdays view works also for non-existing bets
* create ranking page at GET /users/
* add model functionality to matchdays: ordering matchdays, current matchday ...
* find better solution for forms for bets on matchdays view
* limit access rights for non-admin users (!=admin=>redirect_to_where??? last page?)
* show ranking on starting page
