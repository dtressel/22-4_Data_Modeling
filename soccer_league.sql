DROP DATABASE IF EXISTS soccer_league;

CREATE DATABASE soccer_league;

\c soccer_league

CREATE TABLE teams
(
  id SERIAL PRIMARY KEY,
  team_name TEXT NOT NULL
);


CREATE TABLE players
(
  id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  team_id INT NOT NULL REFERENCES teams
);

CREATE TABLE referees
(
  id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL
);

CREATE TABLE matches
(
  id SERIAL PRIMARY KEY,
  match_date DATE,
  end_in_tie BOOLEAN NOT NULL,
  team1_id INT NOT NULL REFERENCES teams,
  team2_id INT NOT NULL REFERENCES teams,
  winning_team_id INT REFERENCES teams,
  losing_team_id INT REFERENCES teams
);

CREATE TABLE season
(
  id SERIAL PRIMARY KEY,
  begin_date DATE NOT NULL,
  end_date DATE NOT NULL
);

CREATE TABLE goals
(
  id SERIAL PRIMARY KEY,
  match_id INT NOT NULL REFERENCES matches,
  player_id INT NOT NULL REFERENCES players
);

CREATE TABLE referee_match
(
  id SERIAL PRIMARY KEY,
  referee_id INT NOT NULL REFERENCES referees,
  match_id INT NOT NULL REFERENCES matches
);

INSERT INTO teams
  (team_name)
VALUES
  ('Lettuce Heads'),
  ('Spicy Cucumbers'),
  ('Fighting Pineapples'),
  ('Blazin Raisins');

INSERT INTO matches
  (end_in_tie, team1_id, team2_id, winning_team_id, losing_team_id)
VALUES
  (false, 1, 2, 1, 2),
  (false, 3, 4, 4, 3),
  (true, 1, 3, NULL, NULL),
  (false, 2, 4, 4, 2),
  (true, 1, 4, NULL, NULL),
  (false, 2, 3, 2, 3);

-- standings table
SELECT team, won, lost, tied,
  CAST(
    (CAST(won AS FLOAT) + 
    (CAST(tied AS FLOAT) / 2)
    ) / (
    CAST(won AS FLOAT) + 
    CAST(lost AS FLOAT) + 
    CAST(tied AS FLOAT)) 
  AS FLOAT(4)) AS win_percentage
FROM (
  SELECT
    teams.team_name AS team,
    COALESCE(won, 0) AS won, 
    COALESCE(lost, 0) AS lost,
    COALESCE(tied, 0) AS tied
  FROM teams 
  FULL JOIN (
    SELECT team_name, COUNT(*) AS tied
    FROM matches
    JOIN teams ON teams.id = team1_id
    GROUP BY team_name, team1_id, end_in_tie
    HAVING end_in_tie = true
    UNION
    SELECT team_name, COUNT(*) AS tied
    FROM matches
    JOIN teams ON teams.id = team2_id
    GROUP BY team_name, team2_id, end_in_tie
    HAVING end_in_tie = true
  ) AS t ON t.team_name = teams.team_name
  FULL JOIN (
    SELECT team_name, COUNT(*) AS lost
    FROM matches
    JOIN teams ON teams.id = losing_team_id
    GROUP BY team_name, losing_team_id
    HAVING losing_team_id > 0
  ) AS l ON l.team_name = teams.team_name
  FULL JOIN (
    SELECT team_name, COUNT(*) AS won
    FROM matches
    JOIN teams ON teams.id = winning_team_id
    GROUP BY team_name, winning_team_id
    HAVING winning_team_id > 0
  ) AS w ON w.team_name = teams.team_name
  GROUP BY team, won, lost, tied
) AS standings
ORDER BY win_percentage DESC;