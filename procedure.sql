# Procedure responsible to scan all table to change
# the determined column based in the another column
# from the same row.

DELIMITER $$
DROP PROCEDURE IF EXISTS changeUsersOFF$$
CREATE PROCEDURE changeUsersOFF()
BEGIN
    declare email varchar(256);
    declare name varchar(256);
    declare domain varchar(256);
    DECLARE n INT DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    SELECT COUNT(*) FROM tab_person_off INTO n;
    SET i=0;
    WHILE i<n DO
        set name = (select customer_name from tab_person_off where customer_id = i);
        set email = (select customer_email from tab_person_off where customer_id = i);
        if not email = '' || email = null then
            set domain=REGEXP_SUBSTR(email, '@(.*)');
            update tab_person_off
                 set
                     domain = domain,
                     name_encrypt = AES_ENCRYPT(name, @encryption_key),
                     email_encrypt = AES_ENCRYPT(email, @encryption_key)
            where customer_id = i;
        end if;
        set i = i + 1;

    END WHILE;
END$$
DELIMITER ;

CALL changeUsersOFF();
