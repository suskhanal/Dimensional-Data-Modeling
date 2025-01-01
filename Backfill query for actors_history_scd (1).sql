WITH streak_started AS (
    	   SELECT actor,
           current_year,
           quality_class,
           LAG(quality_class, 1) OVER
               (PARTITION BY actor ORDER BY current_year) <> quality_class
               OR LAG(quality_class, 1) OVER
               (PARTITION BY actor ORDER BY current_year) IS NULL
               AS did_change
    FROM actors
),

streak_identified AS (
         SELECT
                actor,
                quality_class,
                current_year,
            SUM(CASE WHEN did_change THEN 1 ELSE 0 END)
                OVER (PARTITION BY actor ORDER BY current_year) as streak_identifier
         FROM streak_started
     ),

	 aggregated AS (
         SELECT
            actor,
            quality_class,
            streak_identifier,
            MIN(current_year) AS start_date,
            MAX(current_year) AS end_date
         FROM streak_identified
         GROUP BY 1,2,3
     )

	 SELECT * FROM aggregated;