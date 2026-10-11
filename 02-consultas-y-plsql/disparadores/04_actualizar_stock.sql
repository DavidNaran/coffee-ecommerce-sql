-- Práctica 2 · Disparador 4
-- Tras cada compra (de cliente registrado o anónima) descuenta el stock de la referencia
-- y, si queda por debajo del mínimo, crea un borrador de pedido de reposición al proveedor
-- más barato con las unidades necesarias para volver al stock máximo.

CREATE OR REPLACE TRIGGER actualizar_stock
after INSERT on Client_Lines
for each row
DECLARE
    stock_actual NUMBER(5);
    stock_minimo NUMBER(5);
    stock_maximo NUMBER(5);
    coste_minimo NUMBER(10,2);
    proveedor_mejor_oferta CHAR(10);
    cantidad_pedir NUMBER(5);
begin
    select cur_stock, min_stock, max_stock
    into stock_actual, stock_minimo, stock_maximo
    from References R where R.barCode = :new.barCode; /*se guarda el valor del stock actual, el stock minimo y
    el máximo respecto a la referencia que se acaba de realizar el pedido en las variables auxiliares, previamente creadas*/

    select min(cost) into coste_minimo from Supply_Lines where barCode = :new.barCode;

    select taxID into proveedor_mejor_oferta from Supply_Lines where barCode = :new.barCode and cost = coste_minimo;

    cantidad_pedir := stock_maximo-(stock_actual - to_number(:new.quantity));

    /*ahora se actualiza el valor del stock actual, ya que se ha producido ese pedido*/
    update References
    set cur_stock = stock_actual - to_number(:new.quantity) /* se pasa la cantidad a un entero, para poder operar */
    where barCode = :new.barCode;

    /*por último se comprueba si es necesario hacer un pedido a los proveedores, debido a que el stock actual sea menor al stock minimo
    y se rellenará este stock con el valor máximo*/

    if stock_minimo > (stock_actual - to_number(:new.quantity))
    then insert into Replacements values (proveedor_mejor_oferta, :new.barcode, sysdate, 'D', cantidad_pedir, NULL, cantidad_pedir * coste_minimo);
    end if;

end actualizar_stock;
/

CREATE OR REPLACE TRIGGER actualizar_stock_lines_anonym
after INSERT on Lines_Anonym
for each row
DECLARE
    stock_actual NUMBER(5);
    stock_minimo NUMBER(5);
    stock_maximo NUMBER(5);
    coste_minimo NUMBER(10,2);
    proveedor_mejor_oferta CHAR(10);
    cantidad_pedir NUMBER(5);
begin
    select cur_stock, min_stock, max_stock
    into stock_actual, stock_minimo, stock_maximo
    from References R where R.barCode = :new.barCode; /*se guarda el valor del stock actual, el stock minimo y
    el máximo respecto a la referencia que se acaba de realizar el pedido en las variables auxiliares, previamente creadas*/

    select min(cost) into coste_minimo from Supply_Lines where barCode = :new.barCode;

    select taxID into proveedor_mejor_oferta from Supply_Lines where barCode = :new.barCode and cost = coste_minimo;

    cantidad_pedir := stock_maximo-(stock_actual - to_number(:new.quantity));

    /*ahora se actualiza el valor del stock actual, ya que se ha producido ese pedido*/
    update References
    set cur_stock = stock_actual - to_number(:new.quantity) /* se pasa la cantidad a un entero, para poder operar */
    where barCode = :new.barCode;

    /*por último se comprueba si es necesario hacer un pedido a los proveedores, debido a que el stock actual sea menor al stock minimo
    y se rellenará este stock con el valor máximo*/

    if stock_minimo > (stock_actual - to_number(:new.quantity))
    then insert into Replacements values (proveedor_mejor_oferta, :new.barcode, sysdate, 'D', cantidad_pedir, NULL, cantidad_pedir * coste_minimo);
    end if;

end actualizar_stock_lines_anonym;
/
