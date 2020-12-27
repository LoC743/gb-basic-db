# Задачи к собеседованию

## [Практическое задание](https://github.com/LoC743/gb-basic-db/blob/mysql-service/mysql-service/README.MD)

### [SQL файл, для создания таблиц, котороые описаны дальше](https://github.com/LoC743/gb-basic-db/blob/mysql-service/mysql-service/init_interview_tables.sql)

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

#### Таблица Comments

| Поле      | Тип данных | Дополнительные флаги          | Описание                                   |
| --------- | ---------- | ----------------------------- | ------------------------------------------ |
| id        | INT        | Primary Key, Auto Increment   | Идентификатор изображения                  |
| target_id | INT        | Foreign Key (User), Not Null  | Идентификатор изображения из таблицы Photo |
| user_id   | INT        | Foreign Key (Photo), Not Null | Идентификатор пользователя из таблицы User |
| text      | TEXT       | Not Null                      | Текст комментарий                          |

#### Обновленная таблица Likes

| Поле              | Тип данных  | Дополнительные флаги         | Описание                                            |
| ----------------- | ----------- | ---------------------------- | --------------------------------------------------- |
| id                | INT         | Primary Key, Auto Increment  | Идентификатор лайка                                 |
| user_id           | INT         | Foreign Key (User), Not Null | Идентификатор пользователя, который поставил лайк   |
| target_id         | INT         | Foreign Key (User)           | Идентификатор пользователя, которому поставили лайк |
| photo_target_id   | INT         | Foreign Key (Photo)          | Идентификатор изображения, которому поставили лайк  |
| comment_target_id | INT         | Foreign Key (Comments)       | Идентификатор комментария, которому поставили лайк  |
| type              | VARCHAR(20) | Not Null                     | Отображает тип записи, которой был поставлен лайк   |

#### Возможные значения для Likes.type

| Тип     | Описание                            |
| ------- | ----------------------------------- |
| user    | Запись относится к таблице User     |
| photo   | Запись относится к таблице Photo    |
| comment | Запись относится к таблице Comments |

#### Пользователь не может дважды лайкнуть одну и ту же сущность

Для решения этой проблемы можно добавить следующий триггер:

```sql
DROP TRIGGER IF EXISTS `interview`.`likes_BEFORE_INSERT`;

DELIMITER $$
USE `interview`$$
CREATE DEFINER=`root`@`localhost` TRIGGER `likes_BEFORE_INSERT` BEFORE INSERT ON `likes` FOR EACH ROW BEGIN
IF EXISTS (
    SELECT 1 FROM interview.likes
    where (type = "photo" and target_id = NEW.photo_target_id and user_id = NEW.user_id)
    OR (type = "comment" and target_id = NEW.comment_target_id and user_id = NEW.user_id)
    OR (type = "user" and target_id = NEW.target_id and user_id = NEW.user_id)
    ) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Error: You can't like this item twice.";
end if;
END$$
DELIMITER ;
```

#### Пользователь имеет право отозвать лайк

Для этого достаточно в обычный DELETE запрос подставить идентификатор пользователя и идентификатор сущности, лайк с которой требуется удалить. Также можно указать ее тип.

```sql
DELETE FROM likes WHERE user_id = 4 AND target_id = 5 AND type = "user";
```

#### Необходимо иметь возможность считать число полученных сущностью лайков и выводить список пользователей, поставивших лайки

Для того чтобы получить число пользователей, которые поставили какой-то сущности лайк можно воспользоваться запросом:

```sql
SELECT COUNT(*) FROM likes WHERE TYPE = "user" AND target_id = 3;
```

Для получения списка пользователей, которые поставили какой-то сущности лайк можно воспользоваться запросом:

```sql
SELECT
    *
FROM
    likes
WHERE
    type = 'user' AND target_id = 3;
```

Для этих запросов можно указать любой тип из Likes.type.

#### В будущем могут появиться новые виды сущностей, которые можно лайкать

Для того чтобы добавить новые сущности достаточно просто создать таблицу с новой сущностью. В таблице Likes потребуется добавить новое поле, которое будет внешним ключом для новой сущности. Также потребуется создать новый тип - Likes.type. И можно добавить условие для новой сущности в триггер(чтобы 2 раза не создавалась запись при лайке).

<details>
  <summary>Reveal spoiler</summary>
  Но мне кажется, что будет эффективнее сделать простые запросы и вынести лишние проверки как часть логики на backend-е.
</details>
