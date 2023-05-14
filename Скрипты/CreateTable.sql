create table Лоты (
    ID_Лота serial primary key,
    Наименование VARCHAR(255) not null,
    Описание VARCHAR,
    Изображение VARCHAR(255)
)tablespace Аукционы;

create table Пользователи (
	ID_Пользователя serial primary key,
	Имя VARCHAR(50) not null,
	Фамилия VARCHAR,
	Пароль VARCHAR(50) not null,
	email VARCHAR not null,
	Роль VARCHAR not null
)tablespace Пользователи;

create table Ставки (
	ID_Ставки serial primary key,
	ID_Пользователя serial references Пользователи(ID_Пользователя),
	Ставка numeric (32,2),
	Время_ставки timestamp not null,
	Статус integer,
	ID_аукциона serial
)tablespace Ставки;

create table Аукционы (
	ID_аукциона serial primary key,
	ID_Пользователя serial,
	Дата_Начала_Торгов timestamp not null,
	Дата_Конца_Торгов timestamp not null,
	Статус integer,
	ID_Лота serial references Лоты(Id_Лота),
	Начальная_цена numeric (32,2)
)tablespace Аукционы;


drop table Ставки
drop table Аукционы
drop table Пользователи
drop table Лоты


ALTER TABLE Ставки ADD CONSTRAINT fk_ID_аукциона FOREIGN KEY (ID_аукциона) references Аукционы(ID_аукциона);
ALTER TABLE Аукционы add constraint fk_id_лот foreign key (ID_Лота) references Лоты (ID_Лота)
Alter Table Аукционы add constraint fk_id_Пользователя foreign key(ID_Пользователя) references Пользователи(ID_Пользователя);


CREATE TABLESPACE Пользователи
  OWNER postgres
  LOCATION 'E:\STUDY\KURS_DATABASE\Tablespace\USER'
  
CREATE TABLESPACE Аукционы
  OWNER postgres
  LOCATION 'E:\STUDY\KURS_DATABASE\Tablespace\Bet';
  
CREATE TABLESPACE Ставки
  OWNER postgres
  LOCATION 'E:\STUDY\KURS_DATABASE\Tablespace\AUCTION';