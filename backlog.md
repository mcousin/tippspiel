# Epics
* show stats on starting page
* create chat area on starting page, displaying also status messages (Matchday winner, new )
* show current matchday on starting page


# User Stories
## To Do
* add sign up form (only non-admins should be creatable here!)
* add admin column to users table
* limit access rights for non-admin users

* create ranking page at GET /users/
* create template for starting page at GET /users/1
* show part of ranking on starting page
* show current matchday on starting page


* user twitter bootstrap buttons etc for matchday view
* add dropdown for users on matchdays view (edit only current_user's bets, of course!)


* add model functionality to matchdays: ordering matchdays, current matchday ...

* create league: name, has_many matchdays, has_many communities
* create community: name, has_many users, has_many leagues
* user has_many communities
* move ranking page to GET /community/1

## In Progress

## Done
* show matches/bets on matchdays page for the selected matchday
* make sure form for bets on matchdays view works also for non-existing bets






