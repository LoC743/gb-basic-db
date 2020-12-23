# Задачи к собеседованию

## [Практическое задание](https://github.com/LoC743/gb-basic-db/blob/mysql-service/mysql-service/README.MD)

## Задача 1.

&nbsp;&nbsp;&nbsp;&nbsp;У вас есть социальная сеть, где пользователи (id, имя) могут ставить друг другу лайки. Создайте необходимые таблицы для хранения данной информации. Создайте запрос, который выведет информацию:

-   id пользователя;
-   имя;
-   лайков получено;
-   лайков поставлено;
-   взаимные лайки.

### Решение

Данная задача будет рассмотрена на примере социальной сети [Tinder](https://tinder.com/) и ей подобных.

#### Таблица User

| Поле          | Тип данных   | Дополнительные флаги        | Описание                                                                                   |
| ------------- | ------------ | --------------------------- | ------------------------------------------------------------------------------------------ |
| id            | INT          | Primary Key, Auto Increment | Идентификатор пользователя                                                                 |
| phone         | VARCHAR(15)  | Not Null, Unique            | Номер телефона                                                                             |
| email         | VARCHAR(150) | Not Null, Unique            | Электронный адрес                                                                          |
| first_name    | VARCHAR(150) | Not Null                    | Имя                                                                                        |
| last_name     | VARCHAR(150) | Not Null                    | Фамилия                                                                                    |
| birthday      | Date         | Not Null                    | День рождения                                                                              |
| gender        | BOOLEAN      | Not Null                    | Пол                                                                                        |
| description   | TEXT         | Not Null                    | Описание в профиле                                                                         |
| last_location | VARCHAR(20)  | Not Null                    | Последнее местоположение вида: `-77.0364,38.8951`, широта и долгота разделены символом `,` |

#### Таблица Likes

| Поле      | Тип данных | Дополнительные флаги         | Описание                                            |
| --------- | ---------- | ---------------------------- | --------------------------------------------------- |
| id        | INT        | Primary Key, Auto Increment  | Идентификатор лайка                                 |
| user_id   | INT        | Foreign Key (User), Not Null | Идентификатор пользователя, который поставил лайк   |
| target_id | INT        | Foreign Key (User), Not Null | Идентификатор пользователя, которому поставили лайк |

#### Таблица Matches

| Поле           | Тип данных | Дополнительные флаги         | Описание                           |
| -------------- | ---------- | ---------------------------- | ---------------------------------- |
| id             | INT        | Primary Key, Auto Increment  | Идентификатор взаимных лайков      |
| first_user_id  | INT        | Foreign Key (User), Not Null | Идентификатор первого пользователя |
| second_user_id | INT        | Foreign Key (User), Not Null | Идентификатор второго пользователя |

Если пользователи лайкнули друг друга. то создается запись в таблице Match. Если один из пользователей захочет убрать лайк, то запись из таблицы Matches удаляется.

Запрос который выводит

-   id пользователя;
-   имя;
-   лайков получено;
-   лайков поставлено;
-   взаимные лайки.

```sql
SELECT
    _user.id user_id,
    first_name,
    last_name,
    u_likes.user_likes,
    u_liked.user_liked,
    u_matches.matches_count
FROM
    _user
        LEFT JOIN
    (SELECT
        _user.id AS id, COUNT(*) AS user_likes
    FROM
        _user
    JOIN likes ON _user.id = likes.user_id
    GROUP BY _user.id) AS u_likes ON _user.id = u_likes.id
        LEFT JOIN
    (SELECT
        _user.id AS id, COUNT(*) AS user_liked
    FROM
        _user
    JOIN likes ON _user.id = likes.target_id
    GROUP BY _user.id) AS u_liked ON _user.id = u_liked.id
        LEFT JOIN
    (SELECT
        _user.id AS id, COUNT(*) AS matches_count
    FROM
        _user
    JOIN matches ON _user.id = matches.first_user_id
        OR _user.id = matches.second_user_id
    GROUP BY _user.id) AS u_matches ON _user.id = u_matches.id
```

## Задача 2

&nbsp;&nbsp;&nbsp;&nbsp;Для структуры из задачи 1 выведите список всех пользователей, которые поставили лайк пользователям A и B (id задайте произвольно), но при этом не поставили лайк пользователю C.

### Решение

```sql
SELECT DISTINCT
    users_likes_ab.id
FROM
    (SELECT
        user_likes_a.id
    FROM
        (SELECT
        user_id AS id
    FROM
        likes
    WHERE
        likes.target_id = 2) AS user_likes_a
    JOIN (SELECT
        user_id AS id
    FROM
        likes
    WHERE
        likes.target_id = 3) AS user_likes_b ON user_likes_a.id = user_likes_b.id) AS users_likes_ab
        JOIN
    (SELECT
        user_id AS id
    FROM
        likes
    WHERE
        target_id <> 5) AS user_not_likes_c ON users_likes_ab.id = user_not_likes_c.id
```

## Задача 3

&nbsp;&nbsp;&nbsp;&nbsp;Добавим сущности «Фотография» и «Комментарии к фотографии». Нужно создать функционал для пользователей, который позволяет ставить лайки не только пользователям, но и фото или комментариям к фото. Учитывайте следующие ограничения:

-   пользователь не может дважды лайкнуть одну и ту же сущность;
-   пользователь имеет право отозвать лайк;
-   необходимо иметь возможность считать число полученных сущностью лайков и выводить список пользователей, поставивших лайки;
-   в будущем могут появиться новые виды сущностей, которые можно лайкать.

### Решение

#### Таблица Photo

| Поле     | Тип данных   | Дополнительные флаги         | Описание                                |
| -------- | ------------ | ---------------------------- | --------------------------------------- |
| id       | INT          | Primary Key, Auto Increment  | Идентификатор изображения               |
| owner_id | INT          | Foreign Key (User), Not Null | Идентификатор владельца из таблицы User |
| url      | VARCHAR(255) | Not Null                     | URL изображения                         |
