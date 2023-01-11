-- Задание 1. Используем JOIN’ы
-- Напишите запросы, которые выводят следующую информацию:
--
-- Название компании заказчика (company_name из табл. customers) и ФИО сотрудника,
-- работающего над заказом этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London,
-- а доставку заказа ведет компания United Package (company_name в табл shippers)
--

SELECT cus.company_name, CONCAT(emp.first_name, ' ', emp.last_name)
FROM orders AS ord
JOIN customers AS cus USING (customer_id)
JOIN employees AS emp USING (employee_id)
JOIN shippers AS sh ON (ord.ship_via = sh.shipper_id)
WHERE cus.city = 'London' AND emp.city = 'London' AND sh.company_name = 'United Package'

-- А так мне более понятно
SELECT customers.company_name, CONCAT(employees.first_name, ' ', employees.last_name)
FROM orders
JOIN customers USING (customer_id)
JOIN employees USING (employee_id)
JOIN shippers  ON (orders.ship_via = shippers.shipper_id)
WHERE customers.city = 'London' AND employees.city = 'London'
    AND shippers.company_name = 'United Package'				--> 5

--
-- Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25
-- и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.
--

SELECT product_name, units_in_stock, suppliers.contact_name, suppliers.phone
FROM products
JOIN suppliers USING (supplier_id)
JOIN categories USING (category_id)
WHERE discontinued <> 0 AND units_in_stock < 25 
    AND categories.category_name IN ('Dairy Products', 'Condiments')
ORDER BY units_in_stock	--> 1

-- Проверяю - убрал категории
SELECT product_name, units_in_stock, suppliers.contact_name, suppliers.phone
FROM products
JOIN suppliers USING (supplier_id)
JOIN categories USING (category_id)
WHERE discontinued <> 0 AND units_in_stock < 25
ORDER BY units_in_stock	 	--> 6


--
-- Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа
--

-- Круг Эйлера LEFT JOIN with NULL

SELECT company_name FROM customers
LEFT JOIN orders USING (customer_id)
WHERE orders.order_id IS NULL

--
-- Задание 2. Работа с подзапросами
-- Напишите запросы, которые выводят следующую информацию:
-- 
-- уникальные названия продуктов, которых заказано ровно `10` единиц
-- (количество заказанных единиц см в колонке `quantity` табл `order_details`)
--

-- Нормально и без подзапроса получается
SELECT DISTINCT product_name
FROM products
JOIN order_details USING (product_id)
WHERE order_details.quantity = 10		--> 60

-- А с подзапросом зато больше выходит
-- Похоже, подзапрос криво воткнул, но куда его ещё воткнуть - так и не придумал
SELECT DISTINCT product_name
FROM products
JOIN order_details USING (product_id)
WHERE EXISTS(SELECT 1 FROM order_details WHERE quantity = 10)	--> 77
