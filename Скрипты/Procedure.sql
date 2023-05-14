-------- Процедуры с пользователями --------

-- Создание пользователей
CREATE OR REPLACE PROCEDURE Add_user (
  "Имя" VARCHAR,
  "Фамилия" VARCHAR,
  "Пароль" VARCHAR,
  "email" VARCHAR,
  "роль" VARCHAR
) AS $$
BEGIN 
  INSERT INTO "Пользователи"("Имя", "Фамилия", "Пароль", "email", "Роль")
  VALUES ("Имя", "Фамилия", "Пароль", "email", "роль");
END;
$$ LANGUAGE plpgsql;

drop procedure Add_user;
call Add_user ('Gena', 'Lehov', '123123123123', 'Gnom123@mail.ru', 'Покупатель');
select * from Пользователи;

-- Удаление пользователей пользователей
CREATE OR REPLACE PROCEDURE delete_user(user_id INT)
AS $$
BEGIN
    DELETE FROM Пользователи WHERE ID_Пользователя = user_id;
END;
$$ LANGUAGE plpgsql;

drop procedure delete_user;
CALL delete_user(1);

-- Редактирование пользователя
CREATE OR REPLACE PROCEDURE update_user(
    user_id INT,
    new_name VARCHAR(50),
    new_last_name VARCHAR,
    new_password VARCHAR(50),
    new_email VARCHAR,
    new_role VARCHAR
)
AS $$
BEGIN
    UPDATE Пользователи 
    SET 
        Имя = new_name,
        Фамилия = new_last_name,
        Пароль = new_password,
        email = new_email,
        Роль = new_role
    WHERE 
        ID_Пользователя = user_id;
END;
$$ LANGUAGE plpgsql;

CALL update_user(2, 'Павел', 'Павлов', '123', 'pavel123@mail.ru', 'Продавец');
select * from Пользователи;


-------- Процедуры с аукционами --------

-- Создание аукциона
CREATE OR REPLACE PROCEDURE create_auction(
    lot_id INT,
    user_id INT,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    start_price NUMERIC(32,2),
    status INT
)
AS $$
BEGIN
    INSERT INTO Аукционы (ID_Лота, ID_Пользователя, Дата_Начала_Торгов, Дата_Конца_Торгов, Начальная_цена, Статус)
    VALUES (lot_id, user_id, start_time, end_time, start_price, status);
END;
$$ LANGUAGE plpgsql;


CALL create_auction(2, 1, '2023-05-01 18:00:00', '2023-05-03 24:00:00', 8000.00,0 );
select * from Аукционы;
select * from Лоты;


-- Редактирования аукциона
CREATE OR REPLACE PROCEDURE edit_auction(
    _id INT,
    _lot_id INT,
    _user_id INT,
    _start_time TIMESTAMP,
    _end_time TIMESTAMP,
    _start_price NUMERIC(32,2),
    _status INT
)
AS $$
BEGIN
    UPDATE Аукционы
    SET ID_Лота = _lot_id,
        ID_Пользователя = _user_id,
        Дата_Начала_Торгов = _start_time,
        Дата_Конца_Торгов = _end_time,
        Начальная_цена = _start_price,
        Статус = _status
    WHERE ID_аукциона = _id;
END;
$$ LANGUAGE plpgsql;

CALL edit_auction(1, 1, 1, '2023-05-01 00:00:00', '2023-05-07 00:00:00', 300.00, 1);
select * from Аукционы;

-- Удаление аукциона
CREATE OR REPLACE PROCEDURE delete_auction(auction_id INT)
AS $$
BEGIN
    DELETE FROM Ставки WHERE ID_аукциона = auction_id;
    DELETE FROM Аукционы WHERE ID_аукциона = auction_id;
END;
$$ LANGUAGE plpgsql;

call delete_auction (1);

------- Процедуры с лотами --------

-- Cозданиие лота в первой функции.

-- Редактирование лота

CREATE OR REPLACE PROCEDURE update_lot(
    lot_id INTEGER,
    name VARCHAR(255),
    description VARCHAR,
    image VARCHAR(255)
)
AS $$
BEGIN
    UPDATE Лоты 
    SET Наименование = name, Описание = description, Изображение = image
    WHERE ID_Лота = lot_id;
END;
$$ LANGUAGE plpgsql;

CALL update_lot(1, 'Hennesy', 'Выдержка 30 лет', 'https://w.forfun.com/fetch/94/94c56e15f13f1de4740a76742b0b594f.jpeg');
select * from Лоты;


-- Удаление лота

CREATE OR REPLACE PROCEDURE delete_lot(
    lot_id INT
)
AS $$
BEGIN
    DELETE FROM Лоты WHERE ID_Лота = lot_id;
END;
$$ LANGUAGE plpgsql;

CALL delete_lot(1);


------- Процедуры со ставками --------

-- Создание ставки
CREATE OR REPLACE PROCEDURE create_bid(
    user_id INTEGER,
    bid_amount NUMERIC(32,2),
    bid_time TIMESTAMP WITH TIME ZONE,
    auction_id INTEGER,
    status INTEGER
) LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Ставки (ID_Пользователя, Ставка, Время_ставки, Статус, ID_аукциона)
    VALUES (user_id, bid_amount, bid_time, status, auction_id);
END;
$$;

CALL create_bid(1, 100.00, CURRENT_TIMESTAMP, 2, 1);
select * from Ставки;

-- Удаление ставки
CREATE OR REPLACE PROCEDURE delete_bid(
    bid_id INTEGER
) LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Ставки WHERE ID_Ставки = bid_id;
END;
$$;

CALL delete_bid(1);



