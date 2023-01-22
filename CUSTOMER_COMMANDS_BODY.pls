CREATE OR REPLACE
PACKAGE BODY CUSTOMER_COMMANDS AS

  PROCEDURE RENT_SKI(
    customer_id number,
    ski_id number,
    boots_id number,
    helmet_id number,
    rental_start_date date,
    rental_end_date date
) AS
    is_rented char := 'Y';
    rented_exception EXCEPTION;
  BEGIN
     select rent into is_rented from eq_tab where id=ski_id;
     if is_rented = 'Y' then
        RAISE rented_exception;
     end if;
     select rent into is_rented from eq_tab where id=boots_id;
     if is_rented = 'Y' then
        RAISE rented_exception;
     end if;
     select rent into is_rented from eq_tab where id=helmet_id;
     if is_rented = 'Y' then
        RAISE rented_exception;
     end if;
     
     update eq_tab set rent='Y' where id=ski_id;
     update eq_tab set rent='Y' where id=boots_id;
     update eq_tab set rent='Y' where id=helmet_id;
     
     insert into rentals values(seq_rentals.nextval, customer_id, rented_id_type(ski_id, boots_id, helmet_id), rental_start_date, rental_end_date);
     DBMS_OUTPUT.PUT_LINE('Equipment successfully rented');
  EXCEPTION  
    WHEN rented_exception THEN
        DBMS_OUTPUT.PUT_LINE('Equipment already rented');
        return;
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Equipment not found');
  END RENT_SKI;

  PROCEDURE RETURN_SKI(
    rent_id number,
    return_date date
) AS
    rented rented_id_type;
    single_price number;
    payment number := 0;
  BEGIN   
    select rented_ids into rented from rentals where rentals.rental_id = rent_id;
    for i in 1..rented.count loop
        update eq_tab set rent='N' where id=rented(i);
        select price into single_price from eq_tab where eq_tab.id=rented(i);
        payment := payment + single_price;
    end loop;
    
    update rentals set rental_end_date=return_date where rental_id=rentals.rental_id;
    dbms_output.put_line('Owing: ' || payment);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Rental details not found');
  END RETURN_SKI;

  PROCEDURE VIEW_RENTALS(
    cust_id number
) 
AS
  cursor cur is select rental_id, customer_id, rented_ids, rental_start_date, rental_end_date 
  from rentals r where r.customer_id = cust_id;
  BEGIN
    for c in cur
    loop
        dbms_output.put_line('rental id: ' || c.rental_id);
        dbms_output.put_line('customer id: ' || c.customer_id);
        dbms_output.put('list of rentals: ');
        for i in c.rented_ids.first..c.rented_ids.last loop
            dbms_output.put(c.rented_ids(i) || ' ');
        end loop;
        dbms_output.put_line('');
        dbms_output.put_line('start date: ' || c.rental_start_date);
        dbms_output.put_line('end date: ' || c.rental_end_date);
        dbms_output.put_line('');
    end loop;
  END VIEW_RENTALS;

  PROCEDURE SEARCH_SKIS(
    height IN number,
    ski_type IN varchar2,
    sex IN char
) AS
    searched_lenght number;
    result varchar2(256);
  BEGIN
    if ski_type = 'allride' then
        if sex = 'M' then
            searched_lenght := height - 15;
        else
            searched_lenght := height - 20;
        end if;
    elsif ski_type = 'allmountain' then
                if sex = 'M' then
            searched_lenght := height - 10;
        else
            searched_lenght := height - 15;
        end if;
    elsif ski_type = 'race' then
        searched_lenght := height;
    end if;
    
    select eq.show() into result from eq_tab eq where eq.id = (select e.id from eq_tab e where e.get_ski_length() = searched_lenght);
    dbms_output.put_line(result);
    
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Could not find skis');  
  END SEARCH_SKIS;

END CUSTOMER_COMMANDS;
