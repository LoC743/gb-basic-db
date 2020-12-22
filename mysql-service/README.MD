# Урок 7. Обзор движков MySQL, управление и обслуживание. Подготовка к собеседованию.

## [Задачи к собеседованию](https://github.com/LoC743/gb-basic-db/blob/mysql-service/mysql-service/Interview.MD)

## 1. Создать нового пользователя и задать ему права доступа на базу данных «Страны и города мира».

```sql
CREATE USER "newuser"@"localhost" IDENTIFIED BY "password";
GRANT ALL PRIVILEGES ON geodata.* TO "newuser"@"localhost";
FLUSH PRIVILEGES;
```

Первой строкой создается пользователь. Ему задается имя пользователя, имя хоста и пароль. Также могут быть заданы [дополнительные параметры](https://dev.mysql.com/doc/refman/8.0/en/create-user.html)

Второй строкой пользователю с заданым именем и именем хоста выдается доступ к указанной базе данных и ее таблице. В данном случае это база данных geodata, и \* означает что дан доступ ко всем таблицам этой БД. [Список всех привилегий](https://dev.mysql.com/doc/refman/8.0/en/grant.html#grant-privileges)

Третья строка обновляет состояние прав доступа.

![](https://github.com/LoC743/gb-basic-db/blob/mysql-service/mysql-service/images/1.png)

## 2. Сделать резервную копию базы, удалить базу и пересоздать из бекапа.

Была создана тестовая БД

Которая содержит в себе таблицу `new_table`:

| Поле | Тип         |
| ---- | ----------- |
| id   | INT         |
| test | VARCHAR(45) |

И добавлены следующие строки:

```sql
INSERT INTO new_table VALUES (1, "Test");
INSERT INTO new_table VALUES (2, "foo");
INSERT INTO new_table VALUES (3, "bar");
```

Для создание резервной копии БД можно использовать `mysqldump`

![](https://github.com/LoC743/gb-basic-db/blob/mysql-service/mysql-service/images/2.png)

Теперь можно удалить БД

```sql
DROP DATABASE test;
```

![](https://github.com/LoC743/gb-basic-db/blob/mysql-service/mysql-service/images/3.png)

Для восстановления БД из [dump-а](https://github.com/LoC743/gb-basic-db/blob/mysql-service/mysql-service/test-dump.sql) потребуется снова создать БД:

```sql
CREATE DATABASE test;
```

И выполнить загрузку [dump-а](https://github.com/LoC743/gb-basic-db/blob/mysql-service/mysql-service/test-dump.sql) в созданную БД

```
/usr/local/mysql/bin/mysql -u root -p test < test-dump.sql
```

![](https://github.com/LoC743/gb-basic-db/blob/mysql-service/mysql-service/images/4.png)
