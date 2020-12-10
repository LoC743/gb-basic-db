-- База данных «Страны и города мира»:
-- 1. Сделать запрос, в котором мы выберем все данные о городе – регион, страна.
SELECT 
    _cities.id city_id,
    _cities.country_id,
    _countries.title country_title,
    _cities.important,
    _cities.region_id,
    _regions.title region_title,
    _cities.title city_title
FROM
    _cities
        JOIN
    _countries ON _cities.country_id = _countries.id
        JOIN
    _regions ON _cities.region_id = _regions.id;


-- 2. Выбрать все города из Московской области.
SELECT 
    _cities.id,
    _cities.country_id,
    _cities.important,
    _cities.region_id,
    _regions.title region_title,
    _cities.title city_title
FROM
    _cities
        JOIN
    _regions ON _cities.region_id = _regions.id
HAVING _regions.title = 'Московская область'
--  Либо
SELECT 
    *
FROM
    _cities
WHERE
    region_id = 1053480