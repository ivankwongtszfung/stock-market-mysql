create database asgn1;
use asgn1;
CREATE TABLE guest (
    guestId int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name varchar(255) NOT NULL,
    teleNo int NOT NULL,
    addresses varchar(255) NOT NULL,
    birthday DATE NOT NULL,
    NIC varchar(255)
);


CREATE TABLE customer (
    customerId int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name varchar(255) NOT NULL,
    teleNo int NOT NULL,
    password varchar(25) NOT NULL,
    addresses varchar(255) NOT NULL,
    birthday DATE NOT NULL,
    NIC varchar(255)
);


CREATE TABLE broker (
    licenseNo int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name varchar(255) NOT NULL,
    teleNo int NOT NULL,
    password varchar(25) NOT NULL,
    address varchar(255) NOT NULL,
    birthday DATE NOT NULL,
    NIC varchar(255)
);

CREATE TABLE customerBroker(
    customerBrokerId int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customerId int NOT NULL,
    licenseNo int NOT NULL,
    FOREIGN KEY (customerId) REFERENCES customer(customerId),
    FOREIGN KEY (licenseNo) REFERENCES broker(licenseNo)
);


CREATE TABLE corporation (
    RegNo int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name varchar(255) NOT NULL,
    teleNo int NOT NULL,
    address varchar(255) NOT NULL,
    NIC varchar(255)
);


CREATE TABLE stock (
    symbol varchar(255) NOT NULL,
    indexNo int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    value numeric(15,2) NOT NULL,
    lot numeric(15,2) NOT NULL,
    price numeric(15,2) NOT NULL,
    amountOfTrade numeric(15,2) NOT NULL,
    currentTimestamp  DATETIME not null
);

CREATE TABLE stock_log(
  logId int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  symbol varchar(255) NOT NULL,
  indexNo int NOT NULL,
  value numeric(15,2) NOT NULL,
  lot numeric(15,2) NOT NULL,
  price numeric(15,2) NOT NULL,
  amountOfTrade numeric(15,2) NOT NULL,
  currentTimestamp  DATETIME not null
);


CREATE TABLE corporationStock(
  regNo int not null,
  indexNo int not null,
  FOREIGN KEY (regNo) REFERENCES corporation(regNo),
  FOREIGN KEY (indexNo) REFERENCES stock(indexNo)
);

CREATE TABLE adminstrator (
    staffNo int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name varchar(255) NOT NULL,
    teleNo int NOT NULL,
    password varchar(25) NOT NULL,
    address varchar(255) NOT NULL,
    birthday DATE NOT NULL,
    NIC varchar(255)
);

CREATE TABLE event(
    eventId int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name varchar(255) NOT NULL,
    dateOfEvent DATE NOT NULL,
    venue varchar(255) NOT NULL,
    description varchar(255),
    fee numeric(15,2),
    regNo int not null
);

CREATE TABLE enrollment(
    enrollmentId int not null AUTO_INCREMENT PRIMARY KEY,
    eventId int not null,
    customerId int not null ,
    paid boolean not null,
    FOREIGN KEY (eventId) REFERENCES event(eventId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
);

CREATE TABLE profolio(
    profolioId int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    cash numeric(15,2),
    FOREIGN KEY (profolioId) REFERENCES customer(customerId)
);

CREATE TABLE share(
    shareId int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    shares varchar(255) NOT NULL,
    indexNo int not null,
    upperOrder numeric(15,2),
    lowerOrder numeric(15,2)

);

CREATE TABLE customerStock(
  customerStockId int not null PRIMARY key,
  profolioId int NOT NULL,
  shareId int NOT NULL,
  FOREIGN KEY (profolioId) REFERENCES profolio(profolioId),
  FOREIGN KEY (shareId) REFERENCES share(shareId)
);
