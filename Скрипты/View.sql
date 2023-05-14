-- Представление, которое показывает количество лотов, выставленных на аукционе:

CREATE VIEW num_lots_on_auction AS
SELECT COUNT(*) AS num_lots, ID_аукциона
FROM Аукционы
GROUP BY ID_аукциона;

select * from num_lots_on_auction
select * from Пользователи


-- Представление, которое показывает информацию о последней ставке для каждого лота:
CREATE VIEW last_bid_for_lot AS
SELECT Л.ID_Лота, Л.Наименование, S.Ставка, S.Время_ставки, S.ID_Пользователя
FROM Лоты Л
LEFT JOIN Ставки S ON Л.ID_Лота = S.ID_аукциона
WHERE S.ID_Ставки = (SELECT MAX(ID_Ставки) FROM Ставки WHERE ID_аукциона = Л.ID_Лота);

select * from last_bid_for_lot;

-- Представление, которое показывает количество ставок, сделанных каждым пользователем:
CREATE VIEW num_bids_per_user AS
SELECT COUNT(*) AS num_bids, ID_Пользователя
FROM Ставки
GROUP BY ID_Пользователя;

select * from num_bids_per_user;

-- Представление, которое показывает список пользователей с их ролями и количеством сделанных ими ставок:
CREATE VIEW user_role_and_num_bids AS
SELECT P.ID_Пользователя, P.Имя, P.Фамилия, P.Роль, COUNT(*) AS num_bids
FROM Пользователи P
JOIN Ставки S ON P.ID_Пользователя = S.ID_Пользователя
GROUP BY P.ID_Пользователя, P.Имя, P.Фамилия, P.Роль;

select * from user_role_and_num_bids;
