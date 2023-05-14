----- Создание функций --------

-- Создание лота --
CREATE OR REPLACE FUNCTION create_lot(
    _name VARCHAR(255),
    _description VARCHAR,
    _image_path VARCHAR(255)
) RETURNS INTEGER AS $$
DECLARE
    _lot_id INTEGER;
BEGIN
    INSERT INTO Лоты (Наименование, Описание, Изображение)
    VALUES (_name, _description, _image_path)
    RETURNING ID_Лота INTO _lot_id;
    RETURN _lot_id;
END;
$$ LANGUAGE plpgsql;

SELECT create_lot('Изумруд', 'Сапфир', 'https://w.forfun.com/fetch/94/94c56e15f13f1de4740a76742b0b594f.jpeg');

--------- Функции выводов --------

--- Функция для вывода всех лотов в бд:
CREATE OR REPLACE FUNCTION get_lots_list() RETURNS TABLE (
    lot_id INTEGER,
    name VARCHAR(255),
    description VARCHAR,
    image VARCHAR(255)
) AS $$
BEGIN
    RETURN QUERY SELECT ID_Лота, Наименование, Описание, Изображение FROM Лоты;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_lots_list();


--- Функция для вывода всех пользователей в бд:
CREATE FUNCTION get_all_users() RETURNS SETOF Пользователи AS $$
BEGIN
    RETURN QUERY SELECT * FROM Пользователи;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_all_users();


--- Функция для вывода всех аукционов в бд:
CREATE FUNCTION get_all_auctions() RETURNS SETOF Аукционы AS $$
BEGIN
    RETURN QUERY SELECT * FROM Аукционы;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_all_auctions();


--- Функция для вывода всех ставок в бд:
CREATE FUNCTION get_all_bets() RETURNS SETOF Ставки AS $$
BEGIN
    RETURN QUERY SELECT * FROM Ставки;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_all_bets();



------- Спец. Функции (Индивидуальные) -------

--- Функция Функция получения списка активных аукционов: данная функция позволит получить список всех активных аукционов. Аукцион считается активным, если его дата окончания еще не наступила и его статус 1.
CREATE FUNCTION get_active_auctions() RETURNS SETOF Аукционы AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM Аукционы
    WHERE Дата_Конца_Торгов > now() AND Статус = 1;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_active_auctions();


--- Функция определения победителя аукциона:

CREATE FUNCTION get_auction_winner(
    p_id_auction integer
) RETURNS Пользователи AS $$
DECLARE
    v_winner Пользователи%ROWTYPE;
BEGIN
    SELECT Пользователи.*
    INTO v_winner
    FROM Пользователи
    JOIN Ставки ON Пользователи.ID_Пользователя = Ставки.ID_Пользователя
    WHERE Ставки.ID_аукциона = p_id_auction
    ORDER BY Ставки.Ставка DESC
    LIMIT 1;
    
    RETURN v_winner;
END;
$$ LANGUAGE plpgsql;

SELECT get_auction_winner(2);

--- Функция обновления статуса аукциона:
CREATE FUNCTION update_auction_status(
    p_id_auction integer,
    p_new_status integer
) RETURNS VOID AS $$
BEGIN
    UPDATE Аукционы
    SET Статус = p_new_status
    WHERE ID_аукциона = p_id_auction;
END;
$$ LANGUAGE plpgsql;

SELECT update_auction_status(1, 1);


--- Получение максимальной ставки на аукционе

CREATE FUNCTION get_max_bid_for_auction(auction_id INTEGER) RETURNS NUMERIC(32,2) AS $$
DECLARE
    max_bid NUMERIC(32,2);
BEGIN
    SELECT MAX(Ставка) INTO max_bid FROM Ставки WHERE ID_аукциона = auction_id;
    RETURN max_bid;
END;
$$ LANGUAGE plpgsql;

SELECT get_max_bid_for_auction(2);


--- Получение минимальной ставки на аукционе

CREATE FUNCTION get_min_bid_for_auction(auction_id INTEGER) RETURNS NUMERIC(32,2) AS $$
DECLARE
    min_bid NUMERIC(32,2);
BEGIN
    SELECT MIN(Ставка) INTO min_bid FROM Ставки WHERE ID_аукциона = auction_id;
    RETURN min_bid;
END;
$$ LANGUAGE plpgsql;

SELECT get_min_bid_for_auction(2);


--- Функция получения списка всех ставок для конкретного лота

CREATE FUNCTION get_bids_for_lot(lot_id INTEGER) RETURNS TABLE (
    ID_Ставки INTEGER,
    ID_Пользователя INTEGER,
    Ставка NUMERIC(32,2),
    Время_ставки TIMESTAMP,
    Статус INTEGER,
    ID_Аукциона INTEGER
) AS $$
BEGIN
    RETURN QUERY SELECT * FROM Ставки WHERE ID_аукциона IN (
        SELECT ID_аукциона FROM Аукционы WHERE ID_Лота = lot_id
    );
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_bids_for_lot(1);


--- Функция получения списка всех аукционов для конкретного пользователя:
CREATE FUNCTION get_auctions_for_user(user_id INTEGER) RETURNS TABLE (
    ID_Аукциона INTEGER
) AS $$
BEGIN
    RETURN QUERY SELECT ID_аукциона FROM Аукционы WHERE ID_Пользователя = user_id;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM get_auctions_for_user(1);


--- Функция повышения ставки
CREATE FUNCTION increase_bid(auction_id INTEGER, user_id INTEGER, new_bid NUMERIC(32,2)) RETURNS VOID AS $$
BEGIN
  UPDATE Ставки SET Ставка = Ставка + new_bid, Время_ставки = NOW()
  WHERE ID_аукциона = auction_id AND ID_Пользователя = user_id;
END;
$$ LANGUAGE plpgsql;

SELECT increase_bid(2, 1, 50.00);

select * from Ставки


--- Функция шифрования пароля


select * from Пользователи;

CREATE OR REPLACE FUNCTION hash_password(password text)
RETURNS text AS $$
BEGIN
  RETURN crypt(password, gen_salt('bf', 8));
END;
$$ LANGUAGE plpgsql;

call add_user ('Кирилл', 'Кузнецов', 'kira123', 'Kira123@mail.ru', 'Покупатель');


-- Функций экстренного прекращения аукциона (для админов)

CREATE OR REPLACE FUNCTION end_auction(auction_id INTEGER) 
RETURNS VOID AS $$
BEGIN
    UPDATE Аукционы SET Статус = 0 WHERE ID_аукциона = auction_id;
END;
$$ LANGUAGE PLPGSQL;

SELECT end_auction(2);  -- где 2 - идентификатор аукциона, который нужно закрыть


--- Функция(триггер на регитсрацию на одну почту) 
CREATE OR REPLACE FUNCTION check_duplicate_email() 
RETURNS TRIGGER 
AS $$
BEGIN
    IF EXISTS (SELECT * FROM Пользователи WHERE email = NEW.email) THEN
        RAISE EXCEPTION 'Пользователь с таким email уже зарегистрирован';
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_duplicate_email
BEFORE INSERT ON Пользователи
FOR EACH ROW
EXECUTE FUNCTION check_duplicate_email();



