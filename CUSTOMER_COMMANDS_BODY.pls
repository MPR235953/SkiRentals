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
     if ski_id is not null then
         select rent into is_rented from eq_tab where id=ski_id;
         if is_rented = 'Y' then
            RAISE rented_exception;
        end if;
     end if;
     if boots_id is not null then
         select rent into is_rented from eq_tab where id=boots_id;
         if is_rented = 'Y' then
            RAISE rented_exception;
         end if;
     end if;
     if helmet_id is not null then
         select rent into is_rented from eq_tab where id=helmet_id;
         if is_rented = 'Y' then
            RAISE rented_exception;
         end if;
     end if;
     
     
     if ski_id is not null then
        update eq_tab set rent='Y' where id=ski_id;
     end if;
     if boots_id is not null then
        update eq_tab set rent='Y' where id=boots_id;
     end if;
     if helmet_id is not null then
        update eq_tab set rent='Y' where id=helmet_id;
     end if;

     insert into rentals values(seq_rentals.nextval, customer_id, rented_id_type(ski_id, boots_id, helmet_id), rental_start_date, rental_end_date, null);
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
        if rented(i) is not null then
            update eq_tab set rent='N' where id=rented(i);
            select price into single_price from eq_tab where eq_tab.id=rented(i);
            payment := payment + single_price;
        end if;
    end loop;

    --update rentals set rental_end_date=return_date where rentals.rental_id=rent_id;
    delete from rentals where rentals.rental_id=rent_id;
    dbms_output.put_line('Owing: ' || payment);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Rental details not found');
  END RETURN_SKI;



  PROCEDURE VIEW_RENTALS(
    search_customer_id number
) 
AS
    rent_id number;
    cust_id number;
    rent_ids rented_id_type;
    s_date date;
    e_date date;
    cur cur_type;
  BEGIN
    open cur for select rental_id, customer_id, rented_ids, rental_start_date, rental_end_date from rentals;
        loop
            fetch cur into rent_id, cust_id, rent_ids, s_date, e_date;
            exit when cur%notfound;
            if cust_id = search_customer_id then
                dbms_output.put_line('rental id: ' || rent_id);
                dbms_output.put_line('customer id: ' || cust_id);
                dbms_output.put('list of rentals: ');
                for i in rent_ids.first..rent_ids.last loop
                    dbms_output.put(rent_ids(i) || ' ');
                end loop;
                dbms_output.put_line('');
                dbms_output.put_line('start date: ' || s_date);
                dbms_output.put_line('end date: ' || e_date);
                dbms_output.put_line('');
            end if;
        end loop;
    close cur;
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
