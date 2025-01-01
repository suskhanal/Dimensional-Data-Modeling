CREATE TYPE scd_type AS (
                	quality_class quality_class,
                    is_active BOOLEAN,
                    start_year INTEGER,
                    end_year INTEGER
                        )


SELECT * FROM actors_history_scd;

WITH last_year_scd AS (
    SELECT * FROM actors_history_scd
    WHERE current_year = 1971
    AND end_year = 1971
),

historical_scd AS (
        SELECT
               actor,
               quality_class,
               is_active,
               start_year,
               end_year
        FROM actors_history_scd
        WHERE current_year = 1971
        AND end_year < 1971
     ),

	 this_year_data AS (
         SELECT * FROM actors
         WHERE current_year = 1971
     ),

	 unchanged_records AS (
         SELECT
                ty.actor,
                ty.quality_class,
                ty.is_active,
                ly.start_year,
                ty.current_year AS end_year
        FROM this_year_data ty
        JOIN last_year_scd ly
        ON ly.actor = ty.actor
         WHERE ty.quality_class = ly.quality_class
         AND ty.is_active = ly.is_active
     ),

	 changed_records AS (
        SELECT
                ty.actor,
                UNNEST(ARRAY[
                    ROW(
                        ly.quality_class,
                        ly.is_active,
                        ly.start_year,
                        ly.end_year

                        )::scd_type,
                    ROW(
                        ty.quality_class,
                        ty.is_active,
                        ty.current_year,
                        ty.current_year
                        )::scd_type
                ]) as records
        FROM this_year_data ty
        LEFT JOIN last_year_scd ly
        ON ly.actor = ty.actor
         WHERE (ty.quality_class <> ly.quality_class
          OR ty.is_active <> ly.is_active)
     ),

	 unnested_changed_records AS (

         SELECT actor,
                (records::scd_type).quality_class,
                (records::scd_type).is_active,
                (records::scd_type).start_year,
                (records::scd_type).end_year
                FROM changed_records
         ),
     new_records AS (

         SELECT
            ty.actor,
                ty.quality_class,
                ty.is_active,
                ty.current_year AS start_year,
                ty.current_year AS end_year
         FROM this_year_data ty
         LEFT JOIN last_year_scd ly
             ON ty.actor = ly.actor
         WHERE ly.actor IS NULL

     )

	 SELECT * FROM historical_scd

                  UNION ALL

     SELECT * FROM unchanged_records

                  UNION ALL

     SELECT * FROM unnested_changed_records

                  UNION ALL

     SELECT * FROM new_records
              