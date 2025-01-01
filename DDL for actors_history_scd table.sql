CREATE TABLE actors_history_scd
(
	actor TEXT,
	quality_class quality_class,
	is_active BOOLEAN,
	start_year INTEGER,
	end_year INTEGER,
	current_year INTEGER
);

SELECT * FROM actors_history_scd;
