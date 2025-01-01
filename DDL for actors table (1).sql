SELECT * FROM actor_films;

-- DROP TYPE films;

CREATE TYPE films AS (
    film TEXT,
    year INTEGER,
    votes INTEGER, 
    rating Real,
    filmid TEXT
);

-- DROP TYPE quality_class;

CREATE TYPE quality_class AS
    ENUM ('star', 'good', 'average', 'bad');
	
DROP TABLE actors;

CREATE TABLE actors (
	actor TEXT,
    actorid TEXT,
 	films films[],
	quality_class quality_class,
	Is_active BOOLEAN,
    current_year INTEGER,
    PRIMARY KEY(actorid, current_year)
);


