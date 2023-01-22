-- DELETE BLOCK

BEGIN
  FOR cur_rec IN (SELECT object_name, object_type 
                  FROM   user_objects
                  WHERE  object_type IN ('TABLE', 'VIEW', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'SEQUENCE', 'TRIGGER', 'TYPE')) LOOP
    BEGIN
      IF cur_rec.object_type = 'TABLE' THEN
        IF instr(cur_rec.object_name, 'STORE') = 0 then
          EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '" CASCADE CONSTRAINTS';
        END IF;
      ELSIF cur_rec.object_type = 'TYPE' THEN
        EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '" FORCE';
      ELSE
        EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"';
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line('FAILED: DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"');
    END;
  END LOOP;
END;

-- DB

set serveroutput on;

create or replace type address_object as object(
    street varchar2(40),
    street_no number,
    post_code number(6),
    city varchar2(20)
);

CREATE SEQUENCE seq_customers INCREMENT BY 1 START WITH 1;

create table customers(
    customer_id number primary key not null,
    first_name varchar2(20),
    last_name varchar2(20),
    phone_number number(9,0),
    email varchar(40),
    CONSTRAINT check_email CHECK (email LIKE '%@%.com' OR email LIKE '%@%.pl'),
    address address_object,
    weight number(5, 2),
    CONSTRAINT check_weight CHECK (weight > 0),
    height number(5, 2)
    CONSTRAINT check_height CHECK (height > 0)
);

select * from customers;
insert into customers values(seq_customers.nextval, 'Jan', 'Kowalski', 123456789, 'jan.kowalski@gmail.com', address_object('sloneczna', 7, 2, '12-345'), 80, 1.8);


-- #############################################################################################################################

CREATE OR REPLACE TYPE eq_t AS OBJECT (
 id      number,
 name    varchar2(20),
 price   number,
 rent    char(1),
 MAP MEMBER FUNCTION get_id RETURN NUMBER,
 MEMBER FUNCTION show RETURN VARCHAR2,
 MEMBER FUNCTION get_type RETURN VARCHAR2,
 MEMBER FUNCTION get_name RETURN VARCHAR2,
 MEMBER FUNCTION get_price RETURN NUMBER,
 MEMBER FUNCTION get_rent RETURN CHAR,
 MEMBER FUNCTION get_ski_type RETURN VARCHAR2,
 MEMBER FUNCTION get_ski_length RETURN NUMBER,
 MEMBER FUNCTION get_helmet_size RETURN NUMBER,
 MEMBER FUNCTION get_boots_size RETURN NUMBER)
 NOT FINAL;
 
CREATE OR REPLACE TYPE BODY eq_t AS
 MAP MEMBER FUNCTION get_id RETURN NUMBER IS BEGIN RETURN id; END;
-- function that can be overriden by subtypes
 MEMBER FUNCTION show RETURN VARCHAR2 IS
 BEGIN
   RETURN 'Id: ' || TO_CHAR(id) || ', Name: ' || name;
 END;
 MEMBER FUNCTION get_type RETURN VARCHAR2 IS BEGIN RETURN 'equipment'; END;
 MEMBER FUNCTION get_name RETURN VARCHAR2 IS BEGIN RETURN name; END;
 MEMBER FUNCTION get_price RETURN NUMBER IS BEGIN RETURN price; END;
 MEMBER FUNCTION get_rent RETURN CHAR IS BEGIN RETURN rent; END;
 MEMBER FUNCTION get_ski_type RETURN VARCHAR2 IS BEGIN RETURN 'None'; END;
 MEMBER FUNCTION get_ski_length RETURN NUMBER IS BEGIN RETURN 0; END;
 MEMBER FUNCTION get_helmet_size RETURN NUMBER IS BEGIN RETURN 0; END;
 MEMBER FUNCTION get_boots_size RETURN NUMBER IS BEGIN RETURN 0; END;
END;


CREATE TYPE ski_t UNDER eq_t (
   length number,
   ski_type varchar2(12),
   OVERRIDING MEMBER FUNCTION show RETURN VARCHAR2,
   OVERRIDING MEMBER FUNCTION get_type RETURN VARCHAR2,
   OVERRIDING MEMBER FUNCTION get_ski_type RETURN VARCHAR2,
   OVERRIDING MEMBER FUNCTION get_ski_length RETURN NUMBER)
   NOT FINAL;
   
CREATE TYPE BODY ski_t AS
 OVERRIDING MEMBER FUNCTION show RETURN VARCHAR2 IS
 BEGIN
    RETURN (self AS eq_t).show || ' Length: ' || length || ' Type: ' || ski_type ;
 END;
 OVERRIDING MEMBER FUNCTION get_type RETURN VARCHAR2 IS BEGIN RETURN 'ski'; END;
 OVERRIDING MEMBER FUNCTION get_ski_type RETURN VARCHAR2 IS BEGIN RETURN ski_type; END;
 OVERRIDING MEMBER FUNCTION get_ski_length RETURN NUMBER IS BEGIN RETURN length; END;
END;

CREATE TYPE helmet_t UNDER eq_t (
   helmet_size number,
   OVERRIDING MEMBER FUNCTION show RETURN VARCHAR2,
   OVERRIDING MEMBER FUNCTION get_type RETURN VARCHAR2,
   OVERRIDING MEMBER FUNCTION get_helmet_size RETURN NUMBER)
   NOT FINAL;
   
CREATE TYPE BODY helmet_t AS
 OVERRIDING MEMBER FUNCTION show RETURN VARCHAR2 IS
 BEGIN
    RETURN (self AS eq_t).show || ' Size: ' || helmet_size;
 END;
 OVERRIDING MEMBER FUNCTION get_type RETURN VARCHAR2 IS BEGIN RETURN 'helmet'; END;
 OVERRIDING MEMBER FUNCTION get_helmet_size RETURN NUMBER IS BEGIN RETURN helmet_size; END;
END;

CREATE TYPE boots_t UNDER eq_t (
   boots_size number,
   OVERRIDING MEMBER FUNCTION show RETURN VARCHAR2,
   OVERRIDING MEMBER FUNCTION get_type RETURN VARCHAR2,
   OVERRIDING MEMBER FUNCTION get_boots_size RETURN NUMBER)
   NOT FINAL;
   
CREATE TYPE BODY boots_t AS
 OVERRIDING MEMBER FUNCTION show RETURN VARCHAR2 IS
 BEGIN
    RETURN (self AS eq_t).show || ' Size: ' || boots_size;
 END;
 OVERRIDING MEMBER FUNCTION get_type RETURN VARCHAR2 IS BEGIN RETURN 'boots'; END;
 OVERRIDING MEMBER FUNCTION get_boots_size RETURN NUMBER IS BEGIN RETURN boots_size; END;
END;

-- creaing table with equipment
create table eq_tab of eq_t(id primary key not null);
alter table eq_tab add constraint check_rent check (rent LIKE 'Y' OR rent LIKE 'N');

CREATE SEQUENCE seq_eq INCREMENT BY 1 START WITH 1;

-- exaple inserts
insert into eq_tab values(ski_t(0, '4FRNT', 100, 'N', 230, 'allride'));
insert into eq_tab values(helmet_t(1, 'Smith Vantage MIPS', 20, 'Y', 15));
insert into eq_tab values(boots_t(2, 'Fischer', 10, 'N', 46));

-- example selects
select * from eq_tab;
select eq.show() from eq_tab eq;
select eq.show() from eq_tab eq where eq.id = 1;
delete from eq_tab e where e.id = (select id from eq_tab eq where eq.id = 1);
select eq.get_type() from eq_tab eq;
select eq.show() from eq_tab eq where eq.get_type() = 'helmet';
select eq.get_type(), eq.get_name(), eq.get_price(), eq.get_rent() from eq_tab eq;

-- example of call package procedures for owner
begin
OWNER_COMMANDS.ADD_ITEM(ski_t(77, '4FRNT', 100, 'N', 230, 'allride'));
OWNER_COMMANDS.ADD_ITEM(ski_t(78, '4FRNT', 100, 'N', 230, 'allmountain'));
OWNER_COMMANDS.ADD_ITEM(ski_t(79, '4FRNT', 100, 'N', 230, 'inny typ'));
OWNER_COMMANDS.ADD_ITEM(ski_t(80, '4FRNT', 100, 'N', 230, 'race'));
end;

begin
OWNER_COMMANDS.UPDATE_ITEM(77, ski_t(99, '4FRNT', 200, 'Y', 230, 'allride'));
OWNER_COMMANDS.UPDATE_ITEM(100, ski_t(99, '4FRNT', 200, 'Y', 230, 'allride'));
end;

begin
OWNER_COMMANDS.DEL_ITEM(0);
OWNER_COMMANDS.DEL_ITEM(100);
end;

begin
OWNER_COMMANDS.VIEW_ITEM(2);
end;

-- ############################################################################################################################
create or replace type rented_id_type as varray(3) of number;
CREATE SEQUENCE seq_rentals INCREMENT BY 1 START WITH 1;

create table rentals(
    rental_id number primary key not null,
    customer_id number not null,
    CONSTRAINT check_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),
    rented_ids rented_id_type,
    rental_start_date date,
    rental_end_date date,
    return_date date
);

begin
    OWNER_COMMANDS.VIEW_RENTALS;
end;

select * from customers;
select * from eq_tab;
select * from rentals;

begin
    CUSTOMER_COMMANDS.RENT_SKI(
        customer_id => 1,
        ski_id => 0,
        boots_id => 1,
        helmet_id => 2,
        rental_start_date => sysdate,
        rental_end_date => sysdate);
end;

begin
    CUSTOMER_COMMANDS.VIEW_RENTALS(
        search_customer_id => 1); 
end;

begin
    CUSTOMER_COMMANDS.RETURN_SKI(
        rent_id => 1,
        new_return_date => sysdate);
end;

select eq.show() from eq_tab eq where eq.get_type() = 'ski';

begin 
    CUSTOMER_COMMANDS.SEARCH_SKIS(
    height => 240,
    ski_type => 'allmountain',
    sex => 'M'
);
end;
