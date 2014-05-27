### Описание проекта ###
Задание: Баннерокрутилка
Приложение, в котором можно создавать рекламные кампании. 
Пользователь нажимает “New campaign”, заполняет поля:

1. Название
2. Ссылка
3. Картинка (ужимается до размера 200x200)

В приложении на главной странице должно быть поле с embed-кодом.
Клиенты размещают его у себя на сайте и этот код при загрузке страницы показывает случайную рекламную кампанию.

В приложении можно перейти на страницу кампании и увидеть там показатели:

1. Показы
2. Клики
3. Конверсия %

Данные должно обновляться в **реальном времени**.

### Развертывание ###
1. git clone https://mrwhitegit-admin@bitbucket.org/mrwhitegit-admin/advertising_platform.git
2. cd /advertising_platform
3. bundle install
4. Переименовать файл config/database.yml.example в database.yml и отредактировать.
5. Создаем базу
rake db:create
6. Прогоняем миграции
rake db:migrate
7. Устанавливаем redis
http://redis.io/download

### Запуск ###
1. rails s
2. Во втором терминале запускаем private_pub
(rackup private_pub.ru -s thin -E production)
3. В третьем терминале запускаем sidekiq
(bundle exec sidekiq) (не забываем перед этим запустить redis выполнив команду redis-server "ваш путь к config файлу")

### Проверка ###
1. Перейти на http://localhost:3000/ и создать неcколько компаний.
2. Перейти на страницу одной из компаний.
3. Далее открыть второе окно браузера рядом(для наглядности). И открыть в нем файл test.html который лежит в корневой директории проекта.
4. Протестировать работоспособность.

### apache benchmark ###
1. Запустить скрипт для нагрузочного тестирования ./ab
(Файл ab находится в корневой директории проекта)