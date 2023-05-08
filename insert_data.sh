#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# clearing tables
echo $($PSQL "TRUNCATE teams, games")

# Adding Teams Data
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 

  # first making teams table

  if [[ $WINNER != winner ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    if [[ -z $WINNER_ID ]]
    then
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        echo "Inserted into teams, $WINNER"
      fi
    fi
  fi
  # now doing opponents
  if [[ $OPPONENT != opponent ]]
  then
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPP_ID ]]
    then
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM == "INSERT 0 1" ]]
      then
        OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        echo "Inserted into teams, $OPPONENT"
      fi
    fi
  fi

  # now making games table

  if [[ $YEAR != year ]]
  then
    GAME_INSERT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
      values($YEAR, '$ROUND', $WINNER_ID, $OPP_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      echo "Inserted into games, Year: $YEAR, Round: $ROUND, Winner: $WINNER_ID, Opponent: $OPP_ID, Winner Goals: $WINNER_GOALS, Opponent Goals: $OPPONENT_GOALS"
  fi

done
