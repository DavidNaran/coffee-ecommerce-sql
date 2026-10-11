-- Práctica 2 · Paquete caffeine
-- set_replacement_orders: confirma los borradores de pedidos de reposición.
-- informe_proveedor(cif): pedidos del último año, plazo medio de entrega y, por cada
-- referencia, coste actual, mínimo y máximo y su diferencia con la media y con la mejor oferta.

CREATE OR REPLACE PACKAGE caffeine as
    PROCEDURE set_replacement_orders;
    PROCEDURE informe_proveedor(cif CHAR);
END caffeine;
/

CREATE OR REPLACE PACKAGE BODY caffeine as
    PROCEDURE set_replacement_orders IS
    BEGIN
        UPDATE Replacements
        SET status = 'P'
        WHERE
        status = 'D';
        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND then dbms_output.put_line('No hay datos.');
        when others then dbms_output.put_line('Se ha producido otro error.');
    END set_replacement_orders;
    PROCEDURE informe_proveedor(cif CHAR) IS
        inicio_last_year DATE;
        num_pedidos NUMBER;
        promedio_tiempo NUMBER;
        segunda_mejor_oferta NUMBER;
        coste_diferencia_promedio NUMBER;
        coste_diferencia_mejor NUMBER;
    BEGIN
        --se calcula la fecha a partir de la cual, las fechas mayores las vamos a considerar del último año.
        select sysdate - 365 INTO inicio_last_year from dual;
        --se cuenta el número de pedidos que estan confirmados(P) y completados (F) en ese último año, para el proveedor que se especifica.
        select count(*) into num_pedidos from Replacements WHERE ((status = 'P' or status = 'F') and orderdate >= inicio_last_year and cif = taxID);
        --se hace el promedio de los tiempos de entrega para las ofertas confirmadas.
        select round(avg(deldate-orderdate),2) into promedio_tiempo from Replacements where status = 'P' and orderdate >= inicio_last_year and cif = taxID and deldate is not null and deldate >= orderdate;
        --mostramos por pantalla los datos del
        dbms_output.put_line('Proveedor:'||cif||
        ', Numero de pedidos totales:'||num_pedidos||
        ', Promedio de dias para la entrega:'||promedio_tiempo);

        dbms_output.put_line('---------------------------------------------------------------------------------------');

        --cursor implícito
        for referencia in (select distinct datos_ofertas_proveedor.barCode ref, coste_actual_proveedor, min_cost_proveedor, max_cost, promedio, mejor_oferta
                            from
                                (select R.barCode, cost coste_actual_proveedor, round(min(payment/units), 2) min_cost_proveedor, round(max(payment/units), 2) max_cost
                                    from
                                    Supply_Lines S JOIN Replacements R
                                    ON (S.barCode = R.barCode and S.taxID = R.taxID)
                                    where orderdate >= inicio_last_year and cif = R.taxID
                                    group by R.barCode, cost) datos_ofertas_proveedor
                                JOIN (select S.barCode, round(avg(payment/units), 2) promedio, round(min(payment/units),2) mejor_oferta
                                        from Supply_Lines S
                                        join Replacements R on S.barCode = R.barCode
                                        group by S.barCode, cost) todas_ofertas
                                On datos_ofertas_proveedor.barCode = todas_ofertas.barCode)
        LOOP
            coste_diferencia_promedio := (referencia.coste_actual_proveedor - referencia.promedio);

            select min(payment/units) into segunda_mejor_oferta
                from Supply_Lines S JOIN Replacements R ON S.barCode = R.barCode AND S.taxID = R.taxID
                where cif != S.taxID and referencia.ref = R.barCode
                group by S.barCode;

            if referencia.min_cost_proveedor = referencia.mejor_oferta
                    then coste_diferencia_mejor := (referencia.coste_actual_proveedor - segunda_mejor_oferta);
            else
                coste_diferencia_mejor := (referencia.coste_actual_proveedor - referencia.mejor_oferta);
            end if;

            dbms_output.put_line('BarCode:'||Trim(referencia.ref)||', Coste Actual: '||Trim(referencia.coste_actual_proveedor)||
            ', Coste minimo: '||Trim(referencia.min_cost_proveedor)||
            ', Coste maximo: '||Trim(referencia.max_cost)||
            ', Diferencia entre coste actual y el promedio de ofertas: '||Trim(coste_diferencia_promedio)||
            ', Diferencia entre coste actual y la mejor oferta: '||Trim(coste_diferencia_mejor));

        end loop;
            dbms_output.put_line('---------------------------------------------------------------------------------------');

    EXCEPTION
        WHEN NO_DATA_FOUND then dbms_output.put_line('No hay datos.');
        when others then dbms_output.put_line('Se ha producido otro error.');
    END informe_proveedor;
END caffeine;
/
