#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != winner ]]
  then
    WINNERID=$($PSQL "SELECT team_id FROM teams WHERE teams.name = '$WINNER'")

    if [[ -z $WINNERID ]]
    then
      echo Inserting $WINNER into teams
      WRESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      WINNERID=$($PSQL "SELECT team_id FROM teams WHERE teams.name = '$WINNER'")
    fi

    OPPONENTID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    if [[ -z $OPPONENTID ]]
    then
      echo Inserting $OPPONENT into teams
      ORESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      OPPONENTID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    fi

  GAMESRESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$YEAR', '$ROUND', '$WINNERID', '$OPPONENTID','$WINNER_GOALS', '$OPPONENT_GOALS')") 

  fi
  
done