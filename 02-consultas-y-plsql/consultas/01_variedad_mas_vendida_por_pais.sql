-- Práctica 2 · Consulta 1
-- Para el año 2023: variedad de café más vendida en cada país, con sus compras,
-- unidades, ingresos, media de unidades y número de países que son consumidores
-- potenciales de esa variedad (compran más del 1 % de sus unidades).

with
	pedidos_anonim as (select l.contact, l.orderdate, l.barcode, l.price, l.quantity, o.country_trim
						from
						lines_anonym l
						join
						(select orderdate, contact, TRIM(dliv_country) country_trim from orders_anonym) o
						on (l.orderdate BETWEEN TO_DATE('01/01/23', 'DD/MM/YY') AND TO_DATE('31/12/23', 'DD/MM/YY')
						and
						o.orderdate BETWEEN TO_DATE('01/01/23', 'DD/MM/YY') AND TO_DATE('31/12/23', 'DD/MM/YY')
						and
						l.orderdate = o.orderdate
						and
						l.contact = o.contact)),
	pedidos_cliente as (select username, orderdate, barcode, price, TO_NUMBER(quantity), TRIM(country)
						from
						client_lines where orderdate BETWEEN TO_DATE('01/01/23', 'DD/MM/YY') AND TO_DATE('31/12/23', 'DD/MM/YY')),
	pedidos as (select contact as username, orderdate, barcode, price, quantity, country_trim as country from pedidos_anonim
				union
				select * from pedidos_cliente),
	barcode_varietal as (select barcode, varietal
						from
						(select product, varietal from products) v
						join
						references r
						on (v.product = r.product)),
	pedidos_con_varietal as (select p.barcode, varietal, quantity, country
							from (
								pedidos p
								join
								barcode_varietal bv
								on
								p.barcode = bv.barcode
							)),
	total_ventas_de_varietal as (select varietal, sum(quantity) unidades_varietal_vendidas
								from pedidos_con_varietal
								group by varietal),
	cuenta_varietal as (select varietal, country, count('X') as count_varietal,
								sum(quantity) as suma_cantidad, sum(price) as suma_precio,
								avg(quantity) as media_cantidad
						from
						(pedidos p
						join
						barcode_varietal b
						on p.barcode = b.barcode)
						group by varietal, country
						order by country),
	all_consumides_varietal as (select tvv.varietal, country, suma_cantidad, unidades_varietal_vendidas
										from (
											total_ventas_de_varietal tvv
											join
											cuenta_varietal
											on
											tvv.varietal = cuenta_varietal.varietal
										)),
	consumides_potenciales_varietal as (select varietal, country
										from all_consumides_varietal
										where suma_cantidad > 0.01 * unidades_varietal_vendidas),
	suma_paises_potenciales_x_varietal as (select varietal, count('X') paises_potenciales
											from consumides_potenciales_varietal
											group by varietal),
	pais_varietal as (select country, max(count_varietal) max_count_varietal
						from
						cuenta_varietal
						group by country),
	resumen_pais_varietal as (select varietal, pv.country, max_count_varietal total_compradores, suma_cantidad total_unidades,
							suma_precio ingreso_total, media_cantidad
							from
							pais_varietal pv
							join
							cuenta_varietal cv
							on pv.country = cv.country and pv.max_count_varietal = cv.count_varietal
							order by pv.country)
	select resumen.varietal, country, total_compradores, total_unidades, ingreso_total, media_cantidad, paises_potenciales
	from (
		resumen_pais_varietal resumen
		join
		suma_paises_potenciales_x_varietal potenciales
		on
		resumen.varietal = potenciales.varietal)
		order by varietal;
