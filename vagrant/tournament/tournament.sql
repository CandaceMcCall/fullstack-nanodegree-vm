-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

-- Create database

create database tournament;

\c tournament;

-- Player table
create table players 
(id serial, 		-- Player ID
name text);		-- Player Name

-- Matches table

create table matches
(winner integer,	-- ID of Winner
loser integer		-- ID of Loser
);

-- Player Wins View

create view wins as
select winner as id,count(*) as num_wins
from matches
group by winner
order by winner;

-- Player results view

create view player_results as
select players.id,'L' as result
from players,matches
where players.id = matches.loser
union
select players.id,'W' as result
from players,matches
where players.id = matches.winner
order by 1,2;

-- Matches played

create view matches_played as
select id,count(*) as num_played
from player_results
group by id
order by id;

-- Standungs view

CREATE VIEW standings AS
SELECT players.id,players.name,COALESCE(wins.num_wins,0) num_wins,
	COALESCE(matches_played.num_played,0) num_played
FROM players LEFT JOIN wins ON (players.id = wins.id) 
	LEFT JOIN matches_played ON (players.id = matches_played.id)
order by 3 desc;
