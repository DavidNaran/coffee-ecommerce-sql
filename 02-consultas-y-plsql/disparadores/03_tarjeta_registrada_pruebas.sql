-- Práctica 2 · Pruebas del disparador 3

INSERT INTO Orders_Anonym (orderdate,contact,contact2,dliv_datetime,name,surn1,surn2,bill_waytype,bill_wayname,bill_gate,bill_block,
                            bill_stairw,bill_floor,bill_door,bill_ZIP,bill_town,bill_country,dliv_waytype,dliv_wayname,dliv_gate,dliv_block,
                            dliv_stairw,dliv_floor,dliv_door,dliv_ZIP,dliv_town,dliv_country)
                             VALUES (
                                TO_DATE('2024-04-07', 'YYYY-MM-DD'),        -- orderdate
                                'example@examp',                      -- contact
                                NULL,                                       -- contact2
                                TO_DATE('2024-04-07 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),  -- dliv_datetime
                                'John',                                     -- name
                                'Doe',                                      -- surn1
                                NULL,                                       -- surn2
                                'Street',                                   -- bill_waytype
                                '123 Example St',                           -- bill_wayname
                                '001',                                      -- bill_gate
                                'A',                                        -- bill_block
                                '2',                                        -- bill_stairw
                                '3rd',                                -- bill_floor
                                'C',                                        -- bill_door
                                '12345',                                    -- bill_ZIP
                                'Anytown',                                  -- bill_town
                                'Any Country',                              -- bill_country
                                'Street',                                   -- dliv_waytype
                                '456 Delivery St',                          -- dliv_wayname
                                '002',                                      -- dliv_gate
                                'B',                                        -- dliv_block
                                '1',                                        -- dliv_stairw
                                'Grou',                            -- dliv_floor
                                'B',                                        -- dliv_door
                                '54321',                                    -- dliv_ZIP
                                'Deliverytown',                             -- dliv_town
                                'Delivery Country'                          -- dliv_country
                            );

INSERT INTO Lines_Anonym (orderdate,contact,dliv_town,dliv_country,barcode,price,quantity,pay_type,pay_datetime,
                            card_comp,card_num,card_holder,card_expir)
                            VALUES (
                                    TO_DATE('2024-04-07', 'YYYY-MM-DD'),        -- orderdate
                                    'example@examp',                      -- contact
                                    'Deliverytown',                             -- dliv_town
                                    'Delivery Country',                         -- dliv_country
                                    'QIQ88969I514506',                          -- barcode
                                    100.00,                                     -- price
                                    2,                                          -- quantity
                                    'credit card',                              -- pay_type
                                    SYSDATE,                                    -- pay_datetime
                                    'Mastercard',                               -- card_comp
                                    1234567890123456,                                -- card_num
                                    'Nombre del titular',                       -- card_holder
                                    TO_DATE('2025-01', 'YYYY-MM')              -- card_expir
                                );

INSERT INTO Client_Cards (cardnum, username, card_comp, card_holder, card_expir)
VALUES (1234567890123456, 'apolo', 'VISA', 'Titular Tarjeta', TO_DATE('01/25', 'MM/YY'));
