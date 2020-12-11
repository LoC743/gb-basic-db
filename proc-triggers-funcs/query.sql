-- 1. Создать VIEW на основе запросов, которые вы сделали в ДЗ к уроку 3.
CREATE VIEW `cities_in_moscow_region` AS
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