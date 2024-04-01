//Devuelve todas las películas
SELECT MOVIE_NAME FROM MOVIES m; 

//Devuelve todos los géneros existentes
SELECT GENRE_NAME FROM GENRES g;

//Devuelve la lista de todos los estudios de grabación que estén activos
SELECT STUDIO_NAME FROM STUDIOS WHERE STUDIO_ACTIVE = 1;

//Devuelve una lista de los 20 últimos miembros en anotarse al videoclub
SELECT MEMBER_NAME, MEMBER_DISCHARGE_DATE  FROM MEMBERS m 
ORDER BY MEMBER_DISCHARGE_DATE DESC LIMIT 20;

//Devuelve las 20 duraciones de películas más frecuentes, ordenados de mayor a menor.
SELECT DISTINCT m.MOVIE_DURATION FROM MOVIES m INNER JOIN MEMBERS_MOVIE_RENTAL mr
ON m.MOVIE_ID = mr.MOVIE_ID
ORDER BY m.MOVIE_DURATION DESC LIMIT 20;

//Devuelve las películas del año 2000 en adelante que empiecen por la letra A
SELECT MOVIE_NAME, MOVIE_LAUNCH_DATE FROM MOVIES 
WHERE MOVIE_LAUNCH_DATE > '2000-12-31' AND MOVIE_NAME like 'A%'

//Devuelve los actores nacidos un mes de Junio
SELECT ACTOR_NAME,ACTOR_BIRTH_DATE FROM ACTORS 
WHERE ACTOR_BIRTH_DATE LIKE '%-06-%'

//Devuelve los actores nacidos cualquier mes que no sea Junio y que sigan vivos.
SELECT ACTOR_NAME,ACTOR_BIRTH_DATE FROM ACTORS 
WHERE ACTOR_BIRTH_DATE NOT LIKE '%-06-%' 
AND ACTOR_DEAD_DATE IS NULL 

//Devuelve el nombre y la edad de todos los directores menores o iguales de 50 años que estén vivos
SELECT
    DIRECTOR_NAME,
    AGE
FROM
    (
    SELECT
        DIRECTOR_NAME,
        DATEDIFF(YEAR, DIRECTOR_BIRTH_DATE, TODAY()) AS "AGE",
        DIRECTOR_DEAD_DATE
    FROM
        DIRECTORS)
WHERE
    AGE <= 50
    AND DIRECTOR_DEAD_DATE IS NULL

//Devuelve el nombre y la edad de todos los actores menores de 50 años que hayan fallecido
SELECT
    ACTOR_NAME,
    AGE, 
    ACTOR_DEAD_DATE
FROM
    (
    SELECT
        ACTOR_NAME,
        DATEDIFF(YEAR, ACTOR_BIRTH_DATE, TODAY()) AS "AGE",
        ACTOR_DEAD_DATE, ACTOR_BIRTH_DATE
    FROM
        ACTORS)
WHERE
    AGE <= 50
    AND ACTOR_DEAD_DATE IS NOT NULL
    
//Devuelve el nombre de todos los directores menores o iguales de 40 años que estén vivos
SELECT
    DIRECTOR_NAME,
    AGE
FROM
    (
    SELECT
        DIRECTOR_NAME,
        DATEDIFF(YEAR, DIRECTOR_BIRTH_DATE, TODAY()) AS "AGE",
        DIRECTOR_DEAD_DATE
    FROM
        DIRECTORS)
WHERE
    AGE <= 40
    AND DIRECTOR_DEAD_DATE IS NULL
    
//Indica la edad media de los directores vivos
SELECT
    avg(AGE)
FROM
    (
    SELECT
        DIRECTOR_NAME,
        DATEDIFF(YEAR, DIRECTOR_BIRTH_DATE, TODAY()) AS "AGE",
        DIRECTOR_DEAD_DATE
    FROM
        DIRECTORS)
WHERE
   DIRECTOR_DEAD_DATE IS NULL

//Indica la edad media de los actores que han fallecido
SELECT
    avg(AGE)
FROM
    (
    SELECT
        DIRECTOR_NAME,
        DATEDIFF(YEAR, DIRECTOR_BIRTH_DATE, TODAY()) AS "AGE",
        DIRECTOR_DEAD_DATE
    FROM
        DIRECTORS)
WHERE
   DIRECTOR_DEAD_DATE IS NOT NULL

//Devuelve el nombre de todas las películas y el nombre del estudio que las ha realizado
SELECT m.MOVIE_NAME, STUDIO_NAME FROM MOVIES m INNER JOIN STUDIOS s
ON m.STUDIO_ID = s.STUDIO_ID;

//Devuelve los miembros que alquilaron al menos una película entre el año 2010 y el 2015
SELECT m.MOVIE_NAME, me.MEMBER_NAME FROM MOVIES m 
INNER JOIN MEMBERS_MOVIE_RENTAL mr ON m.MOVIE_ID = mr.MOVIE_ID
INNER JOIN MEMBERS me ON me.MEMBER_ID = mr.MEMBER_ID
WHERE mr.MEMBER_RENTAL_DATE BETWEEN '2010-01-01' AND '2015-01-01'

//Devuelve cuantas películas hay de cada país
SELECT DISTINCT n.NATIONALITY_NAME, SUM(m.MOVIE_ID) AS total_Peliculas FROM MOVIES m 
INNER JOIN NATIONALITIES n ON m.NATIONALITY_ID = n.NATIONALITY_ID
GROUP BY n.NATIONALITY_NAME

//Devuelve todas las películas que hay de género documental
SELECT m.MOVIE_NAME FROM MOVIES m 
INNER JOIN GENRES g ON m.GENRE_ID = g.GENRE_ID
WHERE g.GENRE_NAME = 'Documentary'
    
//Devuelve todas las películas creadas por directores nacidos a partir de 1980 y que todavía están vivos
SELECT m.MOVIE_NAME FROM MOVIES m 
INNER JOIN DIRECTORS d ON m.DIRECTOR_ID = d.DIRECTOR_ID
WHERE d.DIRECTOR_BIRTH_DATE > '1980-01-01' AND d.DIRECTOR_DEAD_DATE IS NULL

//Indica si hay alguna coincidencia de nacimiento de ciudad (y si las hay, indicarlas) entre los miembros del videoclub y los directores.
SELECT me.MEMBER_TOWN,d.DIRECTOR_BIRTH_PLACE FROM MEMBERS me
INNER JOIN MEMBERS_MOVIE_RENTAL mr ON me.MEMBER_ID = mr.MEMBER_ID 
INNER JOIN MOVIES m ON m.MOVIE_ID = mr.MOVIE_ID
INNER JOIN DIRECTORS d ON d.DIRECTOR_ID = m.DIRECTOR_ID
WHERE d.DIRECTOR_BIRTH_PLACE = me.MEMBER_TOWN

//Devuelve el nombre y el año de todas las películas que han sido producidas por un estudio que actualmente no esté activo
SELECT m.MOVIE_NAME, m.MOVIE_LAUNCH_DATE, s.STUDIO_NAME FROM STUDIOS s
INNER JOIN MOVIES m ON m.STUDIO_ID = s.STUDIO_ID
WHERE s.STUDIO_ACTIVE = 0;

//Devuelve una lista de las últimas 10 películas que se han alquilado
SELECT m.MOVIE_NAME, mr.MEMBER_RENTAL_DATE FROM MOVIES m 
INNER JOIN MEMBERS_MOVIE_RENTAL mr ON m.MOVIE_ID = mr.MOVIE_ID
ORDER BY mr.MEMBER_RENTAL_DATE DESC LIMIT 10;

--Indica cuál es la media de duración de las películas de cada director
SELECT d.DIRECTOR_NAME,AVG(m.MOVIE_DURATION) AS duracion_peliculas
FROM DIRECTORS d INNER JOIN MOVIES m
ON d.DIRECTOR_ID = m.DIRECTOR_ID
group BY d.DIRECTOR_NAME

--Indica cuál es el nombre y la duración mínima de la película que ha sido alquilada en los últimos 2 años por los miembros del videoclub 
--(La "fecha de ejecución" en este script es el 25-01-2019)
SELECT m.MOVIE_NAME, MIN(m.MOVIE_DURATION) FROM MOVIES m 
INNER JOIN MEMBERS_MOVIE_RENTAL mr ON m.MOVIE_ID = mr.MOVIE_ID
WHERE mr.MEMBER_RENTAL_DATE BETWEEN '2017-01-01' AND '2019-01-25'
GROUP BY m.MOVIE_NAME

--Indica el número de películas que hayan hecho los directores durante las décadas de los 60, 70 y 80 que contengan la palabra "The" en cualquier parte del título
SELECT COUNT(m.MOVIE_NAME) FROM MOVIES m 
INNER JOIN DIRECTORS d ON m.DIRECTOR_ID = d.DIRECTOR_ID
WHERE m.MOVIE_LAUNCH_DATE  BETWEEN  '1960-01-01' AND '1980-01-01'
AND m.MOVIE_NAME like '%The%'

--Lista nombre, nacionalidad y director de todas las películas
SELECT DISTINCT n.NATIONALITY_NAME, m.MOVIE_NAME, d.DIRECTOR_NAME FROM MOVIES m 
INNER JOIN NATIONALITIES n ON m.NATIONALITY_ID = n.NATIONALITY_ID
INNER JOIN DIRECTORS d ON d.DIRECTOR_ID = m.DIRECTOR_ID 

--Muestra las películas con los actores que han participado en cada una de ellas
SELECT m.MOVIE_NAME, a.ACTOR_NAME FROM MOVIES m 
INNER JOIN MOVIES_ACTORS ac ON ac.MOVIE_ID = m.MOVIE_ID 
INNER JOIN ACTORS a ON ac.ACTOR_ID = a.ACTOR_ID 

--Indica cuantos premios han ganado cada uno de los estudios con las películas que han creado
SELECT COUNT(a.AWARD_WIN), s.STUDIO_NAME  FROM AWARDS a
INNER JOIN MOVIES m ON a.MOVIE_ID = m.MOVIE_ID 
INNER JOIN STUDIOS s ON s.STUDIO_ID = m.STUDIO_ID
GROUP BY s.STUDIO_NAME 

--Indica el número de premios a los que estuvo nominado un actor, pero que no ha conseguido (Si una película está nominada a un premio, su actor también lo está)
SELECT  COUNT(a.AWARD_ALMOST_WIN) n_nominaciones, ac.ACTOR_NAME  FROM AWARDS a
INNER JOIN MOVIES m ON a.MOVIE_ID = m.MOVIE_ID 
INNER JOIN MOVIES_ACTORS ma ON ma.MOVIE_ID = m.MOVIE_ID 
INNER JOIN ACTORS ac ON ac.ACTOR_ID  = ma.ACTOR_ID 
GROUP BY ac.ACTOR_NAME 

--Indica cuantos actores y directores hicieron películas para los estudios no activos
SELECT count(ac.ACTOR_ID) as n_actores,count(d.DIRECTOR_ID) AS n_directores FROM STUDIOS s
INNER JOIN MOVIES m ON s.STUDIO_ID = m.STUDIO_ID
INNER JOIN MOVIES_ACTORS ma ON ma.MOVIE_ID = m.MOVIE_ID 
INNER JOIN ACTORS ac ON ac.ACTOR_ID  = ma.ACTOR_ID 
INNER JOIN DIRECTORS d ON d.DIRECTOR_ID = m.DIRECTOR_ID 
WHERE s.STUDIO_ACTIVE = 0
GROUP BY s.STUDIO_NAME 
