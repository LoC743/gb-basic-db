# Урок 6. Масштабирование MySQL и NoSQL

## 1. Настроить и запустить master-сервер.

Настройка будет производиться с использованием Docker.

Для этого требуется создать контейнер с готовым образом(image) из [Docker Hub](https://hub.docker.com/r/mysql/mysql-server/)

`docker run --name=mysql-db -d mysql/mysql-server:latest`

После этого будет скачен образ(если требуется), и развернут контейнер.

Можем проверить статус контейнера командой: `docker ps -a`

| Поле         | Значение                                                                               |
| ------------ | -------------------------------------------------------------------------------------- |
| CONTAINER ID | Идентификатор контейнера                                                               |
| IMAGE        | Образ на котором базируется контейнер                                                  |
| COMMAND      | Команда которая передается контейнеру                                                  |
| CREATED      | Показывает как давно был создан контейнер                                              |
| STATUS       | Может принимать значения: created, restarting, running, removing, paused, exited, dead |
| PORTS        | Показывает используемые порты                                                          |
| NAME         | Название контейнера                                                                    |

![](https://github.com/LoC743/gb-basic-db/blob/my-sql-replica/no-sql/mysql-master/images/1.png)

Для того, чтобы первый раз попасть в MySQL нужно получить пароль который сгенерировала СУБД.

`docker logs mysql-db | grep 'GENERATED ROOT'`

После выполнения этой команды будет выведена информация из логов. В ней будет подсвечена строка `GENERATED ROOT PASSWORD: <пароль>`.

Чтобы попасть в контейнер требуется выполнить команду

`docker exec -it <id_контейнера> bash`

Теперь следует воспользоваться паролем, который мы получили из логов и зайти в mysql:

`mysql -u root -p`

Для того чтобы изменить текущий пароль потребуется SQL запрос:

`ALTER USER 'root'@'localhost' IDENTIFIED BY '<пароль>';`

Теперь следует изменить конфигурационный файл `my.cnf`. Он расположен по пути `etc/my.cnf`

Для его изменения можно воспользоваться текстовым редактором `nano`. Для его установки можно воспользоваться: `yum install nano`. После этого отредактируем файл: `nano etc/my.cnf`.

![](https://github.com/LoC743/gb-basic-db/blob/my-sql-replica/no-sql/mysql-master/images/2.png)

После этого потребуется перезапуск контейнера: `docker restart 8c2b00be809b`

Теперь следует настроить доступ к ведущему серверу:

```
mysql -u root -p

mysql> CREATE USER 'replication'@'%' IDENTIFIED BY 'replication';
mysql> GRANT REPLICATION SLAVE ON _._ TO 'replication'@'%';
FLUSH PRIVILEGES;
```

При первом создании репликации нужно заблокировать на изменение все таблицы на ведущем сервере.

```
USE <название_базы_данных>
FLUSH TABLES WITH READ LOCK;
```

Теперь можно осуществить вывод статуса ведущего сервера: `SHOW MASTER STATUS`

![](https://github.com/LoC743/gb-basic-db/blob/my-sql-replica/no-sql/mysql-master/images/3.png)

## 2. Установить MongoDB и повторить запросы из методички.

Для установки MongoDB можно опять воспользоваться Docker.

Для этого требуется создать контейнер с готовым образом(image) из [Docker Hub](https://hub.docker.com/_/mongo)

`docker run -p 27017:27017 --name mongodb -d mongo:latest`

![](https://github.com/LoC743/gb-basic-db/blob/my-sql-replica/no-sql/mysql-master/images/4.png)

Для входа в контейнер воспользуемся командой: `docker exec -it <id_контейнера> bash`

Для входа в саму MongoDB: `mongo`

Для создания базы данных используется команда: `use <название_базы>`

Для того чтобы подключиться к MongoDB через MongoDB Compass можно воспользоваться:

-   Строкой подключения: `mongodb://0.0.0.0:27017`
-   Заполнить поля для подключения вручную

![](https://github.com/LoC743/gb-basic-db/blob/my-sql-replica/no-sql/mysql-master/images/5.png)

Создадим базу `users` и пользователя(администратора).

```
> use users
switched to db users
> db.createUser({user:"admin", pwd:"1234", roles:["readWrite", "dbAdmin"]})
Successfully added user: { "user" : "admin", "roles" : [ "readWrite", "dbAdmin" ] }
```

После того как был создан администратор можно указывать `username` и `password` для входа.

![](https://github.com/LoC743/gb-basic-db/blob/my-sql-replica/no-sql/mysql-master/images/6.png)

Или использовать строку подключения: `mongodb://admin:1234@localhost:27017/?authSource=users&readPreference=primary&appname=MongoDB%20Compass&ssl=false`

Добавим новую запись в базу данных и выведем результат.

```
> db.users.insert({"name":"Tom", "age":28, languages: ["english", "spanish"]})
WriteResult({ "nInserted" : 1 })
> db.users.find()
{ "_id" : ObjectId("5fdc8bf588995eb3b4a858ad"), "name" : "Tom", "age" : 28, "languages" : [ "english", "spanish" ] }
```

Так же этот объект можно увидеть через MongoDB Compass, выбрав базу данных `users` и коллекцию `users`.

![](https://github.com/LoC743/gb-basic-db/blob/my-sql-replica/no-sql/mysql-master/images/7.png)

Добавим вложенный объект и воспользуемся поиском по ключу `compamy.name`

```
> db.users.insert({"company":{"name":"Microsoft","age": 25, languages: ["english", "spanish"]}})
WriteResult({ "nInserted" : 1 })
> db.users.find({"company.name": "Microsoft"})
{ "_id" : ObjectId("5fdc8dd488995eb3b4a858ae"), "company" : { "name" : "Microsoft", "age" : 25, "languages" : [ "english", "spanish" ] } }
```

![](https://github.com/LoC743/gb-basic-db/blob/my-sql-replica/no-sql/mysql-master/images/8.png)

Чтобы изменить данные, можно воспользоваться командой `update`

```
> db.users.update({name: "Tom"}, {$set: {name: "Jon"}})
WriteResult({ "nMatched" : 1, "nUpserted" : 0, "nModified" : 1 })
```

![](https://github.com/LoC743/gb-basic-db/blob/my-sql-replica/no-sql/mysql-master/images/9.png)

Для удаления документа из коллекции можно воспользоваться командой `remove`

```
> db.users.remove({_id:  ObjectId("5fdc8dd488995eb3b4a858ae")})
WriteResult({ "nRemoved" : 1 })
```

![](https://github.com/LoC743/gb-basic-db/blob/my-sql-replica/no-sql/mysql-master/images/11.png)

Вывод данных в терминале можно сделать более читаемым, если использовать метод `.pretty()`

`> db.users.find({}).pretty()`

![](https://github.com/LoC743/gb-basic-db/blob/my-sql-replica/no-sql/mysql-master/images/12.png)
