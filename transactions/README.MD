# Урок 5. Транзакции и оптимизация запросов

## 1. Реализовать практические задания на примере других таблиц и запросов.

### Блокировка чтения

Для блокировки чтения нужно воспользоваться запросом `lock table <название_таблицы> read;`

![](https://github.com/LoC743/gb-basic-db/blob/transactions/transactions/images/1.png)
![](https://github.com/LoC743/gb-basic-db/blob/transactions/transactions/images/2.png)

При попытке обновить данные в этой таблице, запрос будет ожидать, пока блокировка не будет снята. Его ожидание можно увидеть в таблице `processlist`.
При этом запросы на получение данных будут доступны для выполнения.

![](https://github.com/LoC743/gb-basic-db/blob/transactions/transactions/images/3.png)
![](https://github.com/LoC743/gb-basic-db/blob/transactions/transactions/images/7.png)

При разблокировке командой `unlock tables;`, запрос который был в ожидании выполняется.

### Блокировка записи

Для блокировки записи требуется воспользоваться запросом `lock table <название_таблицы> write;`

![](https://github.com/LoC743/gb-basic-db/blob/transactions/transactions/images/4.png)
![](https://github.com/LoC743/gb-basic-db/blob/transactions/transactions/images/5.png)

При попытке получить данные из этой таблицы, запрос будет ожидать, пока блокировка не будет снята. Это так же можно увидеть в таблице `processlist`.
При этом можно выполнять запросы, которые будут изменять данные в таблице.

В запросе, который потребовал данные из таблицы, буду отражены самые последние данные, после всех изменений, которые были применены до снятия блокировки.

![](https://github.com/LoC743/gb-basic-db/blob/transactions/transactions/images/6.png)

## 2. Подумать, какие операции являются транзакционными, и написать несколько примеров с транзакционными запросами.

-   Обмен предметами между людьми. Если обе стороны готовы обменяться, то транзакция совершается. Если хотя бы одна сторона обмена отказывается, то транзакция откатывается.
-   Покупка `_` (вещей, подписки и тд) в магазине(интернет магазине). Если обе стороны готовы обменяться, то транзакция совершается. Если товара в наличии нет, или у покупателя не хватает денег на совершение покупки, то тразакция откатывается.

## 3. Проанализировать несколько запросов с помощью EXPLAIN.

Запрос:

```
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
WHERE _regions.title = 'Московская область';
```
