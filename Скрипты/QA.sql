EXPLAIN ANALYZE SELECT email FROM Пользователи WHERE email ILIKE '%email%';

create index ind_mail Пользователи(email)