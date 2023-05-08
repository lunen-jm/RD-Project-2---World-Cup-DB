#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals) + SUM(opponent_goals) AS total_goals FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) AS avg_winner_goals FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) AS avg_winner_goals_rounded FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals) + AVG(opponent_goals)) AS avg_total_goals FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) AS max_goals FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "
  SELECT name 
  FROM (
    SELECT winner_id 
    FROM games 
    WHERE round = 'Final' 
      AND year = 2018
      ) 
    AS winning_team
  LEFT JOIN teams ON winning_team.winner_id = teams.team_id
")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "
  SELECT name 
  FROM (
    SELECT winner_id AS team_id 
    FROM games 
    WHERE round = 'Eighth-Final' 
      AND year = 2014
  UNION
    SELECT opponent_id AS team_id 
    FROM games 
    WHERE round = 'Eighth-Final' 
      AND year = 2014
      ) 
    AS eighth_teams
  LEFT JOIN teams ON eighth_teams.team_id = teams.team_id
  ORDER BY name
")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "
  SELECT name
  FROM (
    SELECT DISTINCT(winner_id) AS team_id
    FROM games
    )
    AS winning_teams
  LEFT JOIN teams USING(team_id)
  ORDER BY name
")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "
  SELECT year, name
  FROM (
    SELECT year, winner_id AS team_id
    FROM games
    WHERE round = 'Final'
    )
    AS winning_teams
  LEFT JOIN teams USING(team_id)
  ORDER BY year
")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%'")"
