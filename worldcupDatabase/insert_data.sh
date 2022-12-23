#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    if [[ $WINNER != 'winner' ]]
    then
      if [[ -z $TEAM_NAME ]]
      then
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      fi 
    fi
  TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
    if [[ $OPPONENT != 'opponent' ]]
    then 
        if [[ -z $TEAM_NAME ]]
        then
        INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        fi
    fi
  TEAM_ID_WINNER=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  TEAM_ID_OPPONENT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ $ROUND != 'round' ]]
  then
  INSERT_GAMES=$($PSQL "INSERT INTO games(round, year, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$ROUND', $YEAR, $TEAM_ID_WINNER, $TEAM_ID_OPPONENT, $WINNER_GOALS, $OPPONENT_GOALS)")
  if [[ $INSERT_GAMES == 'INSERT 0 1' ]]
  then
  echo success
  fi
  fi
done