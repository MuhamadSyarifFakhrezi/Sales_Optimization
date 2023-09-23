use project;
show tables;

set sql_safe_updates = 0;

UPDATE sell_1
SET Date = REPLACE(Date, '.', '-'),
	pce_zn = REPLACE(pce_zn, ',', '.'),
	pwa_zn = REPLACE(pwa_zn, ',', '.'),
	pce_sn = REPLACE(pce_sn, ',', '.'),
    pwa_sn = REPLACE(pwa_sn, ',', '.'),
    pce_sb = REPLACE(pce_sb, ',', '.'),
    pwa_sb = REPLACE(pwa_sb, ',', '.'),
    pudzsb = REPLACE(pudzsb, ',', '.'),
    pmarza = REPLACE(pmarza, ',', '.'),
    pmarzajedn = REPLACE(pmarzajedn, ',', '.'),
    pkwmarza = REPLACE(pkwmarza, ',', '.'),
    pudzmarza = REPLACE(pudzmarza, ',', '.');
    
ALTER TABLE sell_1
	ADD COLUMN month DATE FIRST;

UPDATE sell_1
	SET month = STR_TO_DATE(Date, '%d-%m-%Y');

ALTER TABLE sell_1
	DROP COLUMN Date;

ALTER TABLE sell_1
	MODIFY PKod VARCHAR (100),
    MODIFY Pname VARCHAR(250),
	MODIFY pwa_zn FLOAT,
    MODIFY pce_sn FLOAT,
    MODIFY pwa_sn FLOAT,
    MODIFY pce_sb FLOAT,
    MODIFY pwa_sb FLOAT,
    MODIFY pudzsb FLOAT,
    MODIFY pmarza FLOAT,
    MODIFY pmarzajedn FLOAT,
    MODIFY pkwmarza FLOAT,
    MODIFY pudzmarza FLOAT;
    
ALTER TABLE sell_1
	CHANGE PKod Pcode VARCHAR(100),
    CHANGE Pgroup category VARCHAR(100),
	CHANGE pce_zn net_price_of_purchase FLOAT,
	CHANGE pwa_zn net_value_of_purchase FLOAT,
    CHANGE pce_sn net_price_of_sale FLOAT,
    CHANGE pwa_sn net_value_of_sale FLOAT,
    CHANGE pce_sb gross_price_of_sale FLOAT,
    CHANGE pwa_sb gross_valueof_sale FLOAT,
    CHANGE pudzsb P_share_in_sales FLOAT,
    CHANGE pmarza P_of_margin FLOAT,
    CHANGE pmarzajedn unit_product_margin FLOAT,
    CHANGE pkwmarza sell_margin FLOAT,
    CHANGE pudzmarza P_share_in_margin FLOAT;
        #P_.... = Percent(%)

select * from sell_1;

# find the outlier
SELECT month, Pname, category, sell_margin, net_value_of_purchase, net_price_of_purchase, Pquantity, net_price_of_sale
FROM sell_1
WHERE sell_margin >= (SELECT AVG(sell_margin) FROM sell_1)
AND net_value_of_purchase <= (SELECT AVG(net_value_of_purchase) FROM sell_1)
AND (net_value_of_purchase < 0.3 AND category NOT IN ('SWEETS'));

# delete outlier
DELETE FROM sell_1
WHERE sell_margin >= (SELECT avg_sell_margin FROM (SELECT AVG(sell_margin) AS avg_sell_margin FROM sell_1) AS subquery)
AND net_value_of_purchase <= (SELECT avg_net_value_of_purchase FROM (SELECT AVG(net_value_of_purchase) AS avg_net_value_of_purchase FROM sell_1) AS subquery)
AND (net_value_of_purchase < 0.3 AND category NOT IN ('SWEETS'));

# data cleaned
select * from sell_1;

###########################################################
/*
The main problems faced by the owners are:
    • Overhaul of the owners - the store employs 4 employees, but the owners' great involvement in the current operation of the store means that 
	  they are unable to assess the situation and take actions to adapt the business profile to market changes
    • Strong exposure of current assets in relation to profits, necessary improvement of cash flow - the store brings lower and lower profits, 
      there are problems with the availability of funds for current operations
    • There is a significant amount of poorly rotating goods in the assortment of the store; there is also a group of goods generating significant 
	  losses. Shall the owners change the profil of shop or limit some of the products groups?
    • The problem becomes goods with a short shelf life, which too often have to be overestimated due to the end of the shelf-life date
*/
###########################################################

# group by category
# total profit, total quantity, total revenue, persentase of margin
SELECT category, ROUND(SUM(net_value_of_purchase), 2) total_cost, ROUND(SUM(sell_margin), 2) total_profit, SUM(Pquantity) total_quantity, ROUND(SUM(net_value_of_sale), 2) total_revenue, 
	ROUND(SUM(sell_margin)/SUM(net_value_of_sale) *100, 2) AS 'margin(%)'
FROM sell_1
GROUP BY category
ORDER BY SUM(sell_margin) DESC;

# profitable products
# goods with a sell_margin that is greater than the average sell_margin, and the net_value_of_purchase is smaller than the average
SELECT month, Pname, category, sell_margin, net_value_of_purchase, net_price_of_purchase, Pquantity, net_price_of_sale
FROM sell_1
WHERE  sell_margin >= (SELECT AVG(sell_margin) FROM sell_1)
AND net_value_of_purchase <= (SELECT AVG(net_value_of_purchase) FROM sell_1)
ORDER BY net_value_of_purchase, sell_margin DESC;

# loss products
WITH t AS
(SELECT Pname, category, ROUND(SUM(sell_margin), 2) total_profit, SUM(Pquantity) total_quantity, ROUND(SUM(net_value_of_sale), 2) total_revenue,
	ROUND(SUM(sell_margin)/SUM(net_value_of_sale) *100, 2) AS perc_of_total_profit
FROM sell_1
GROUP BY  Pname, category
ORDER BY SUM(sell_margin)
)
SELECT * FROM t
WHERE total_profit LIKE '-%';

###########################################################
# check insight
# categories of goods with the largest profits (3 largest) per month
WITH t AS (
SELECT month(month) month, category, ROUND(SUM(sell_margin), 2) total_profit, SUM(Pquantity) total_quantity, ROUND(SUM(net_value_of_sale), 2) total_revenue, 
	ROUND(SUM(sell_margin)/SUM(net_value_of_sale) *100, 2) AS perc_of_total_profit,
    RANK() OVER(PARTITION BY month(month) ORDER BY month(month), SUM(sell_margin) DESC) RANKED
FROM sell_1
GROUP BY month(month), category
ORDER BY month(month), SUM(sell_margin) DESC
)
SELECT month, category, total_profit, total_quantity, total_revenue, perc_of_total_profit
FROM t
WHERE RANKED <= 3;

# category of goods with the largest profits for 1 year (2018)
SELECT category, ROUND(SUM(sell_margin), 2) total_profit, SUM(Pquantity) total_quantity, ROUND(SUM(net_value_of_sale), 2) total_revenue,
	ROUND(SUM(sell_margin)/SUM(net_value_of_sale) *100, 2) AS perc_of_total_profit
FROM sell_1
GROUP BY category
ORDER BY SUM(sell_margin) DESC;

# category of goods with the smallest profit (3rd smallest) per month
WITH t AS (
SELECT month(month) month, category, ROUND(SUM(sell_margin), 2) total_profit, SUM(Pquantity) total_quantity, ROUND(SUM(net_value_of_sale), 2) total_revenue, 
	ROUND(SUM(sell_margin)/SUM(net_value_of_sale) *100, 2) AS perc_of_total_profit,
    RANK() OVER(PARTITION BY month(month) ORDER BY month(month), SUM(sell_margin)) RANKED
FROM sell_1
GROUP BY month(month), category
ORDER BY month(month) ASC, SUM(sell_margin)
)
SELECT month, category, total_profit, total_quantity, total_revenue, perc_of_total_profit
FROM t
WHERE RANKED <= 3;

# category of goods with the smallest profit for 1 year (2018)
SELECT category, ROUND(SUM(sell_margin), 2) total_profit, SUM(Pquantity) total_quantity, ROUND(SUM(net_value_of_sale), 2) total_revenue,
	ROUND(SUM(sell_margin)/SUM(net_value_of_sale) *100, 2) AS perc_of_total_profit
FROM sell_1
GROUP BY category
ORDER BY SUM(sell_margin);