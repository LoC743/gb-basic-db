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
