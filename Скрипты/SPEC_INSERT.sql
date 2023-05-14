--------------- INSERT 100000 --------------- 
CREATE OR REPLACE FUNCTION INSERT_USER()
RETURNS VOID AS $$
DECLARE
    I INTEGER := 1;
BEGIN
    WHILE I <= 100000 LOOP
        INSERT INTO Пользователи (Имя, Фамилия, Пароль, email, Роль) VALUES ('Имя  ' || I, 'Фамилия  ' || I, 'Пароль  ' || I, 'email  ' || I, 'Роль  ' || I);
        I := I + 1;
    END LOOP;
END;
$$ LANGUAGE PLPGSQL;

SELECT  INSERT_USER();
SELECT * FROM Пользователи