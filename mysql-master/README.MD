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
