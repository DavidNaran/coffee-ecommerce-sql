-- Práctica 2 · Consulta 2
-- Informe mensual de abril de 2023 a marzo de 2024: referencia más vendida de cada mes,
-- con su número de pedidos, unidades vendidas, ingresos y beneficio (ingresos menos coste).

with
	pedidos_anonim as (select l.contact, l.orderdate, l.barcode, l.price, l.quantity, o.country_trim
						from
						lines_anonym l
						join
						(select orderdate, contact, TRIM(dliv_country) country_trim from orders_anonym) o
						on (l.orderdate BETWEEN TO_DATE('01/04/23', 'DD/MM/YY') AND TO_DATE('31/03/24', 'DD/MM/YY')
						and
						o.orderdate BETWEEN TO_DATE('01/04/23', 'DD/MM/YY') AND TO_DATE('31/03/24', 'DD/MM/YY')
						and
						l.orderdate = o.orderdate
						and
						l.contact = o.contact)),
	pedidos_cliente as (select username, orderdate, barcode, price, TO_NUMBER(quantity), TRIM(country)
						from
						client_lines where orderdate BETWEEN TO_DATE('01/04/23', 'DD/MM/YY') AND TO_DATE('31/03/24', 'DD/MM/YY')),
	pedidos as (select contact as username, orderdate, barcode, price, quantity, country_trim as country from pedidos_anonim
				union
				select * from pedidos_cliente),
    ref_x_mes as (select to_char(orderdate, 'YY/MM') as mes, barcode, sum(quantity) as sum_quantity,
				 count('X') numero_pedidos, sum(price * quantity) ingresos_totales
					from pedidos
					group by to_char(orderdate, 'YY/MM'), barcode),
	max_x_mes as (select mes, max(sum_quantity) unidades_vendidas
					   from ref_x_mes
					   group by mes),
	max_ref_x_mes as (select a.mes, barcode, numero_pedidos, unidades_vendidas, ingresos_totales
						from (
							ref_x_mes a
							join
							max_x_mes b
							on
							a.mes = b.mes and a.sum_quantity = b.unidades_vendidas
						)
						order by mes),
	max_ref_x_mes_price_benefict as (select mes, a.barcode, numero_pedidos, unidades_vendidas, ingresos_totales, max(ingresos_totales-(cost * unidades_vendidas)) beneficio
										from(
											max_ref_x_mes a
											join
											supply_lines b
											on
											a.barcode = b.barcode
										)
										group by mes, a.barcode, numero_pedidos, unidades_vendidas, ingresos_totales
										order by mes)
select * from max_ref_x_mes_price_benefict;
