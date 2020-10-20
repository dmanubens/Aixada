/*
 * IVA
 */
DELIMITER $$
DROP FUNCTION IF EXISTS `get_date_for_shop`$$
CREATE FUNCTION `get_date_for_shop` (`the_cart_id` INT) RETURNS DATE READS SQL DATA
BEGIN
DECLARE the_date date;
select date_for_shop into the_date
  from 
	aixada_cart c
  where
	c.id = the_cart_id;
    
return the_date;
END$$

DROP FUNCTION IF EXISTS `get_uf_name`$$
CREATE FUNCTION `get_uf_name` (`the_cart_id` INT) RETURNS VARCHAR(100) CHARSET utf8 READS SQL DATA
BEGIN
DECLARE the_name varchar(100);
select aixada_uf.name into the_name
  from 
	aixada_cart inner join aixada_uf
  where
    aixada_cart.uf_id = aixada_uf.id 
  and 
	aixada_cart.id = the_cart_id;
    
return the_name;
END$$

DROP FUNCTION IF EXISTS `get_uf_nif`$$
CREATE FUNCTION `get_uf_nif` (`the_cart_id` INT) RETURNS VARCHAR(100) CHARSET utf8 READS SQL DATA
BEGIN
DECLARE the_nif varchar(100);
select aixada_member.nif into the_nif
  from 
	aixada_cart inner join aixada_member
  where
    aixada_cart.uf_id = aixada_member.uf_id 
  and 
	aixada_cart.id = the_cart_id
  limit 1;
    
return the_nif;
END$$

DROP FUNCTION IF EXISTS `get_provider_name`$$
CREATE FUNCTION `get_provider_name` (`the_provider_id` INT) RETURNS VARCHAR(100) CHARSET utf8 READS SQL DATA
BEGIN
DECLARE the_name varchar(100);
select aixada_provider.name into the_name
  from 
	aixada_provider
  where
    aixada_provider.id = the_provider_id;
    
return the_name;
END$$

DROP FUNCTION IF EXISTS `get_provider_nif`$$
CREATE FUNCTION `get_provider_nif` (`the_provider_id` INT) RETURNS VARCHAR(100) CHARSET utf8 READS SQL DATA
BEGIN
DECLARE the_nif varchar(100);
select aixada_provider.nif into the_nif
  from 
	aixada_provider
  where
    aixada_provider.id = the_provider_id;
    
return the_nif;
END$$



DROP FUNCTION IF EXISTS `get_purchase_base`$$
CREATE FUNCTION `get_purchase_base` (`the_cart_id` INT, `the_iva` INT) RETURNS FLOAT(10,2) READS SQL DATA
BEGIN
DECLARE base_x decimal(10,2);
select 
	sum( CAST( si.quantity / (1 + si.iva_percent / 100) * si.unit_price_stamp as decimal(10,2)) ) into base_x
  from 
	aixada_shop_item si
  where
	si.cart_id = the_cart_id and si.iva_percent = the_iva;
    
return base_x;
END$$

DROP FUNCTION IF EXISTS `get_purchase_iva`$$
CREATE FUNCTION `get_purchase_iva` (`the_cart_id` INT, `the_iva` INT) RETURNS FLOAT(10,2) READS SQL DATA
BEGIN
DECLARE iva_x decimal(10,2);
select 
	sum( CAST( si.quantity / (1 + si.iva_percent / 100) * si.unit_price_stamp * si.iva_percent / 100 as decimal(10,2)) ) into iva_x
  from 
	aixada_shop_item si
  where
	si.cart_id = the_cart_id and si.iva_percent = the_iva;
    
return iva_x;
END$$

DROP FUNCTION IF EXISTS `get_purchase_total`$$
CREATE FUNCTION `get_purchase_total` (`the_cart_id` INT) RETURNS FLOAT(10,2) READS SQL DATA
begin
  declare total_price decimal(10,2);
  
  select 
	sum( CAST(si.quantity * si.unit_price_stamp as decimal(10,2)) ) into total_price
  from 
	aixada_shop_item si
  where
	si.cart_id = the_cart_id;
      
  return total_price;
end$$


DROP FUNCTION IF EXISTS `get_account_quantity`$$
CREATE FUNCTION `get_account_quantity` (`the_payment_ref` VARCHAR(100)) RETURNS FLOAT(10,2) READS SQL DATA
BEGIN
DECLARE the_qty decimal(10,2);
SELECT quantity into the_qty
from aixada_account
where description = the_payment_ref 
and payment_method_id = 8
order by id desc
limit 1;
return the_qty;
END$$

DROP FUNCTION IF EXISTS `get_order_base`$$
CREATE FUNCTION `get_order_base` (`the_order_id` INT, `the_iva` INT) RETURNS FLOAT(10,2) READS SQL DATA
BEGIN
DECLARE base_x decimal(10,2);
select 
	cast(
        sum( 
            ots.unit_price_stamp * ots.quantity / (1 + ots.rev_tax_percent / 100) / (1 + ots.iva_percent / 100)
           )
        as decimal(10,2)
        ) into base_x
  from 
	aixada_order_to_shop ots
  where
	ots.order_id = the_order_id and ots.iva_percent = the_iva and ots.arrived = 1;
    
return base_x;
END$$

DROP FUNCTION IF EXISTS `get_order_iva`$$
CREATE FUNCTION `get_order_iva` (`the_order_id` INT, `the_iva` INT) RETURNS FLOAT(10,2) READS SQL DATA
BEGIN
DECLARE iva_x decimal(10,2);
select 
	cast(
        sum(
            ots.unit_price_stamp * ots.quantity / (1 + ots.rev_tax_percent / 100) / (1 + ots.iva_percent / 100) * ots.iva_percent / 100 
            )
         as decimal(10,2)
         ) into iva_x
  from 
	aixada_order_to_shop ots
  where
	ots.order_id = the_order_id and ots.iva_percent = the_iva and ots.arrived = 1;
    
return iva_x;
END$$

DROP FUNCTION IF EXISTS `get_order_total`$$
CREATE FUNCTION `get_order_total` (`the_order_id` INT) RETURNS FLOAT(10,2) READS SQL DATA
begin
  declare total_price decimal(10,2);
  
  select 
	cast( 
        sum(
            ots.unit_price_stamp * ots.quantity / (1 + ots.rev_tax_percent / 100) 
           ) 
        as decimal(10,2) 
        ) into total_price
  from 
	aixada_order_to_shop ots
  where
	ots.order_id = the_order_id and ots.arrived = 1;
      
  return total_price;
end$$

-- --------------------------------------------------------

--
-- Stand-in structure for view `emeses`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `emeses`;
DROP TABLE IF EXISTS `emeses`;
CREATE TABLE `emeses` (
`cart_id` int(11)
,`data_c` date
,`client_n` varchar(100)
,`nif` varchar(100)
,`base_4` float(10,2)
,`base_10` float(10,2)
,`base_21` float(10,2)
,`base_0` float(10,2)
,`iva_4` float(10,2)
,`iva_10` float(10,2)
,`iva_21` float(10,2)
,`total_factura` float(10,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `rebudes`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `rebudes`;
DROP TABLE IF EXISTS `rebudes`;
CREATE TABLE `rebudes` (
`payment_ref` varchar(255)
,`count(payment_ref)` bigint(21)
,`date_for_order` date
,`provider_id` int(11)
,`sum(base_4)` double(19,2)
,`sum(base_10)` double(19,2)
,`sum(base_21)` double(19,2)
,`sum(base_0)` double(19,2)
,`sum(iva_4)` double(19,2)
,`sum(iva_10)` double(19,2)
,`sum(iva_21)` double(19,2)
,`sum(total_factura)` double(19,2)
,`get_account_quantity(payment_ref)` float(10,2)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `rebudes_item`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `rebudes_item`;
DROP TABLE IF EXISTS `rebudes_item`;
CREATE TABLE `rebudes_item` (
`id` int(11)
,`payment_ref` varchar(255)
,`date_for_order` date
,`provider_id` int(11)
,`base_4` float(10,2)
,`base_10` float(10,2)
,`base_21` float(10,2)
,`base_0` float(10,2)
,`iva_4` float(10,2)
,`iva_10` float(10,2)
,`iva_21` float(10,2)
,`total_factura` float(10,2)
);

-- --------------------------------------------------------

--
-- Structure for view `emeses`
--
DROP TABLE IF EXISTS `emeses`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `emeses`  AS  select `si`.`cart_id` AS `cart_id`,`get_date_for_shop`(`si`.`cart_id`) AS `data_c`,`get_uf_name`(`si`.`cart_id`) AS `client_n`,`get_uf_nif`(`si`.`cart_id`) AS `nif`,`get_purchase_base`(`si`.`cart_id`,4) AS `base_4`,`get_purchase_base`(`si`.`cart_id`,10) AS `base_10`,`get_purchase_base`(`si`.`cart_id`,21) AS `base_21`,`get_purchase_base`(`si`.`cart_id`,0) AS `base_0`,`get_purchase_iva`(`si`.`cart_id`,4) AS `iva_4`,`get_purchase_iva`(`si`.`cart_id`,10) AS `iva_10`,`get_purchase_iva`(`si`.`cart_id`,21) AS `iva_21`,`get_purchase_total`(`si`.`cart_id`) AS `total_factura` from `aixada_shop_item` `si` group by `si`.`cart_id` ;

-- --------------------------------------------------------

--
-- Structure for view `rebudes`
--
DROP TABLE IF EXISTS `rebudes`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `rebudes`  AS  select `rebudes_item`.`payment_ref` AS `payment_ref`,count(`rebudes_item`.`payment_ref`) AS `count(payment_ref)`,`rebudes_item`.`date_for_order` AS `data_f`,`get_provider_name`(`rebudes_item`.`provider_id`) AS `provider_n`,`get_provider_nif`(`rebudes_item`.`provider_id`) AS `nif`,sum(`rebudes_item`.`base_4`) AS `base_4`,sum(`rebudes_item`.`base_10`) AS `base_10`,sum(`rebudes_item`.`base_21`) AS `base_21`,sum(`rebudes_item`.`base_0`) AS `base_0`,sum(`rebudes_item`.`iva_4`) AS `iva_4`,sum(`rebudes_item`.`iva_10`) AS `iva_10`,sum(`rebudes_item`.`iva_21`) AS `iva_21`,sum(`rebudes_item`.`total_factura`) AS `total_factura`,`get_account_quantity`(`rebudes_item`.`payment_ref`) AS `total_factura_imprev` from `rebudes_item` group by `rebudes_item`.`payment_ref`,`rebudes_item`.`provider_id` order by `rebudes_item`.`payment_ref` ;

-- --------------------------------------------------------

--
-- Structure for view `rebudes_item`
--
DROP TABLE IF EXISTS `rebudes_item`;

CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `rebudes_item`  AS  select `aixada_order`.`id` AS `id`,`aixada_order`.`payment_ref` AS `payment_ref`,`aixada_order`.`date_for_order` AS `date_for_order`,`aixada_order`.`provider_id` AS `provider_id`,`get_order_base`(`aixada_order`.`id`,4) AS `base_4`,`get_order_base`(`aixada_order`.`id`,10) AS `base_10`,`get_order_base`(`aixada_order`.`id`,21) AS `base_21`,`get_order_base`(`aixada_order`.`id`,0) AS `base_0`,`get_order_iva`(`aixada_order`.`id`,4) AS `iva_4`,`get_order_iva`(`aixada_order`.`id`,10) AS `iva_10`,`get_order_iva`(`aixada_order`.`id`,21) AS `iva_21`,`get_order_total`(`aixada_order`.`id`) AS `total_factura` from `aixada_order` order by `aixada_order`.`provider_id` ;
COMMIT;
