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


-- База данных «Сотрудники»:
-- 1. Выбрать среднюю зарплату по отделам.
SELECT 
    AVG(salary) average_salary,
    dept_manager.dept_no,
    departments.dept_name
FROM
    salaries
        JOIN
    dept_manager ON salaries.emp_no = dept_manager.emp_no
        JOIN
    departments ON departments.dept_no = dept_manager.dept_no
GROUP BY dept_manager.dept_no

-- 2. Выбрать максимальную зарплату у сотрудника.
-- Если выбрать одного сотрудника с максимальной зарплатой из всех сотрудников
SELECT 
    emp_no, salary max_salary
FROM
    salaries
WHERE
    salary IN (SELECT 
            MAX(salary)
        FROM
            salaries)
-- Если выбрать максимальную зарплату у каждого сотрудника
SELECT 
    MAX(salary) max_salary, employees.*
FROM
    salaries
        JOIN
    employees ON salaries.emp_no = employees.emp_no
GROUP BY employees.emp_no

-- 3. Удалить одного сотрудника, у которого максимальная зарплата.
DELETE FROM salaries 
WHERE
    (emp_no , salary) IN (SELECT 
        *
    FROM
        (SELECT 
            emp_no, salary
        FROM
            salaries
        
        WHERE
            salary IN (SELECT 
                MAX(salary)
            FROM
                salaries)) AS s)

-- 4. Посчитать количество сотрудников во всех отделах.
SELECT 
    COUNT(employees.emp_no), dept_emp.dept_no
FROM
    employees
        JOIN
    dept_emp ON employees.emp_no = dept_emp.emp_no
GROUP BY dept_emp.dept_no