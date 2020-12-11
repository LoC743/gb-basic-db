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

-- 2. Создать функцию, которая найдет менеджера по имени и фамилии.
CREATE PROCEDURE `search_manager` 
(
	OUT id INT,
    IN f_name VARCHAR(14), l_name VARCHAR(16)
)
BEGIN
	SELECT emp_no INTO id
    FROM employees
    WHERE first_name = f_name AND last_name = l_name;
END

-- CALL search_manager(@result, "Amstein", "Ghemri");
-- SELECT @result;

CREATE FUNCTION `get_manager` (f_name VARCHAR(14), l_name VARCHAR(16))
RETURNS INTEGER DETERMINISTIC
BEGIN
	DECLARE result_id INT;
	SELECT emp_no INTO result_id
    FROM employees
	WHERE first_name = f_name AND last_name = l_name;
RETURN result_id;
END

-- SELECT GET_MANAGER('Amstein', 'Ghemri')

-- 3. Создать триггер, который при добавлении нового сотрудника будет выплачивать
--  ему вступительный бонус, занося запись об этом в таблицу salary.
CREATE DEFINER=`root`@`localhost` TRIGGER `employees_AFTER_INSERT` AFTER INSERT ON `employees`
FOR EACH ROW
BEGIN
	INSERT INTO salaries (emp_no, salary, from_date, to_date)
    VALUES (NEW.emp_no, 1, NEW.hire_date, (SELECT DATE_ADD(NOW(), INTERVAL 30 DAY)));
END