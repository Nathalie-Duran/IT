
CREATE TABLE IF NOT EXISTS CREDIT_CARD  (
id varchar(250) PRIMARY KEY not null
,iban varchar(250) null
,pan varchar(250) null
,pin varchar(250) null
,cvv varchar(250) null
,expiring_date varchar(250) null
,FOREIGN KEY(id) REFERENCES transaction(id)
);

