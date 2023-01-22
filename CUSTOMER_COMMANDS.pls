CREATE OR REPLACE 
PACKAGE CUSTOMER_COMMANDS AS 
Type cur_type is ref cursor;

PROCEDURE RENT_SKI(
    customer_id number,
    ski_id number,
    boots_id number,
    helmet_id number,
    rental_start_date date,
    rental_end_date date
);

PROCEDURE RETURN_SKI(
    rent_id number,
    new_return_date date
);

PROCEDURE VIEW_RENTALS(
    search_customer_id number
);

PROCEDURE SEARCH_SKIS(
    height number,
    ski_type varchar2,
    sex char
);

END CUSTOMER_COMMANDS;
