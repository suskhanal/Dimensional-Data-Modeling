
INSERT INTO actors (actor, actorid, films,quality_class,Is_active, current_year) 
WITH last_year AS (
    SELECT * FROM actors
    WHERE current_year = 1970
),
this_year AS (
    SELECT 
        actor,
        actorid,
        year AS current_year,
        ARRAY_AGG(ROW(
            film,
            year,
            votes,
            rating,
            filmid
        )::films) AS films,
		AVG(rating) AS avg_rating
    FROM actor_films
    WHERE year = 1971
    GROUP BY actor, actorid, year
)
SELECT 
    COALESCE(ty.actor, ly.actor) AS actor,
    COALESCE(ty.actorid, ly.actorid) AS actorid,

	CASE 
        WHEN ly.films IS NULL THEN ty.films
        WHEN ty.films IS NOT NULL THEN ly.films || ty.films
        ELSE ly.films
    END AS films,

	CASE
	WHEN ty.avg_rating IS NOT NULL AND ty.avg_rating >8 THEN 'star'
	WHEN ty.avg_rating IS NOT NULL AND ty.avg_rating > 7 THEN'good' 
	WHEN ty.avg_rating IS NOT NULL AND ty.avg_rating > 6 THEN 'average'
	ELSE 'bad'
	END::quality_class,
	
	CASE
        WHEN ty.actorid IS NULL THEN 0::BOOLEAN
        ELSE 1::BOOLEAN
    END AS is_active,
	
    COALESCE(ty.current_year, ly.current_year + 1) AS current_year

	
FROM this_year ty 
FULL OUTER JOIN last_year ly 
ON ty.actorid = ly.actorid

SELECT * FROM actors;

WITH unnested AS(
SELECT actor,
UNNEST(films) as films
FROM actors
WHERE current_year = 1971

)

SELECT actor,
(films::films).*
FROM unnested;