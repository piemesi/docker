CREATE DATABASE IF NOT EXISTS Processing;
CREATE DATABASE IF NOT EXISTS Billing;
CREATE DATABASE IF NOT EXISTS System;
CREATE DATABASE IF NOT EXISTS ChangeLog;
CREATE DATABASE IF NOT EXISTS Shard;
CREATE DATABASE IF NOT EXISTS Shard00;
CREATE DATABASE IF NOT EXISTS Shard01;
CREATE DATABASE IF NOT EXISTS Shard02;
CREATE DATABASE IF NOT EXISTS Shard03;
CREATE DATABASE IF NOT EXISTS PsResponse;
; 
USE Billing; 
DROP TABLE IF EXISTS account CASCADE;
DROP TABLE IF EXISTS operation CASCADE;

CREATE TABLE account (
  id bigint unsigned not null auto_increment,
  legal_entity_id bigint unsigned not null default '0',
  balance bigint not null default '0',
  amount_in bigint unsigned not null default '0',
  amount_out bigint unsigned not null default '0',
  currency varchar(3) not null default '',
  title varchar(255) not null default '',
  global_account_id bigint unsigned not null default '0',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (id),
  UNIQUE KEY le_currency (legal_entity_id, currency, global_account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE operation (
  id integer unsigned not null auto_increment,
  source_account_id bigint unsigned not null default '0',
  dest_account_id bigint unsigned not null default '0',
  amount_from bigint unsigned not null default '0',
  currency_from varchar(3) not null default '',
  amount_to bigint unsigned not null default '0',
  currency_to varchar(3) not null default '',
  business_transaction_id bigint unsigned not null default '0',
  business_operation_id bigint unsigned not null default '0',
  tariff_id bigint unsigned not null default '0',
  reason varchar(255) not null default '',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
; 
insert into account (title, legal_entity_id, balance, amount_in, amount_out, currency, global_account_id)
values
    ('default client account', 0, 0, 0, 0, 'USD', 0),
    ('default client account', 0, 0, 0, 0, 'EUR', 0),
    ('default client account', 0, 0, 0, 0, 'RUB', 0),
    ('default client account', 0, 0, 0, 0, 'GBP', 0),
    ('default client account', 0, 0, 0, 0, 'JPY', 0),
    ('default client account', 0, 0, 0, 0, 'CHF', 0),

    ('OUR COMMISSION', 7, 0, 0, 0, 'EUR', 0),
    ('OUR COMMISSION', 7, 0, 0, 0, 'USD', 0),
    ('OUR COMMISSION', 7, 0, 0, 0, 'GBP', 0),
    ('OUR COMMISSION', 7, 0, 0, 0, 'CHF', 0),
    ('OUR COMMISSION', 7, 0, 0, 0, 'JPY', 0),

    ('MOOGLE 1', 1, 0, 0, 0, 'EUR', 0),
    ('MOOGLE 2', 1, 0, 0, 0, 'USD', 0),
    ('ACME 100x500', 2, 0, 0, 0, 'EUR', 0),
    ('ACME american', 2, 0, 0, 0, 'USD', 0),
    ('zm eur', 3, 0, 0, 0, 'EUR', 0),
    ('zm usd', 3, 0, 0, 0, 'USD', 0),
    ('quark soft 1', 4, 0, 0, 0, 'EUR', 0),
    ('quark soft 2', 4, 0, 0, 0, 'USD', 0),
    ('lav', 5, 0, 0, 0, 'EUR', 0),
    ('lav', 5, 0, 0, 0, 'USD', 0),
    ('CR', 6, 0, 0, 0, 'EUR', 0),
    ('CR', 6, 0, 0, 0, 'USD', 0),

    ('Global acc for sixth site', 0, 50000, 50000, 0, 'EUR', 9)
;
; 
USE Processing; DROP TABLE IF EXISTS card_keys CASCADE;
DROP TABLE IF EXISTS card CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS merchant_account_allowed_currencies CASCADE;
DROP TABLE IF EXISTS payment_system_allowed_currencies CASCADE;
DROP TABLE IF EXISTS site_allowed_currencies CASCADE;
DROP TABLE IF EXISTS site CASCADE;
DROP TABLE IF EXISTS mpi CASCADE;
DROP TABLE IF EXISTS route CASCADE;
DROP TABLE IF EXISTS merchant_account CASCADE;
DROP TABLE IF EXISTS tariff CASCADE;
DROP TABLE IF EXISTS legal_entity CASCADE;
DROP TABLE IF EXISTS merchant CASCADE;
DROP TABLE IF EXISTS company CASCADE;
DROP TABLE IF EXISTS payment_system CASCADE;
DROP TABLE IF EXISTS currency_rate CASCADE;
DROP TABLE IF EXISTS currency CASCADE;
DROP TABLE IF EXISTS iin CASCADE;
DROP TABLE IF EXISTS job CASCADE;
DROP TABLE IF EXISTS failed_task CASCADE;
DROP TABLE IF EXISTS reconciliation_history CASCADE;
DROP TABLE IF EXISTS recurring_registrations CASCADE;
DROP TABLE IF EXISTS fraudstop CASCADE;
DROP TABLE IF EXISTS used_route_stat CASCADE;
DROP TABLE IF EXISTS worker_offset CASCADE;
DROP TABLE IF EXISTS merchant_account_cascade CASCADE;
DROP TABLE IF EXISTS callback_settings CASCADE;
DROP TABLE IF EXISTS general_data CASCADE;

CREATE TABLE worker_offset (
  topic varchar(80) not null default '',
  partition_id int(11) not null default '-1001',
  offset bigint unsigned not null default '0',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (topic,partition_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE failed_task (
  id integer unsigned not null auto_increment,
  site_id integer unsigned not null default '0',
  order_id varchar(255) not null default '',
  request_id varchar(255) not null default '',
  transaction_id bigint unsigned not null default '0',
  worker varchar(255) not null default '',
  errors text,
  message text,
  error_type varchar(100) not null default '',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE job (
  id integer unsigned not null auto_increment,
  scheduled_time timestamp not null default '0000-00-00 00:00:00',
  status enum('created','processing','done') not null default 'created',
  queue_name varchar(255) not null default '',
  message text,
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE currency_rate (
  id integer unsigned not null auto_increment,
  currency_from varchar(3) not null default '',
  currency_to varchar(3) not null default '',
  rate bigint unsigned not null default '0',
  exponent integer unsigned not null default '0',
  source_id bigint unsigned not null default '0',
  status enum('active','deleted') not null default 'active',
  created_at timestamp not null default '0000-00-00 00:00:00',
  created_by varchar(255) not null default '',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  updated_by varchar(255) not null default '',
  PRIMARY KEY (id),
  KEY currency_created (currency_from, currency_to, created_at),
  UNIQUE KEY source_currency_created (source_id, currency_from, currency_to, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE iin (
  bin integer unsigned not null default '0',
  card_type enum('unknown','visa','mastercard') not null default 'unknown',
  issuer_id bigint unsigned not null default '0',
  product_id bigint unsigned not null default '0',
  country varchar(2) not null default '',
  status enum('active','deleted') not null default 'active',
  created_at timestamp not null default '0000-00-00 00:00:00',
  created_by varchar(255) not null default '',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  updated_by varchar(255) not null default '',
  PRIMARY KEY (bin)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE company (
  id integer unsigned not null auto_increment,
  title varchar(255) not null default '',
  domain varchar(255) not null default '',
  status enum('active','deleted') not null default 'active',
  created_at timestamp not null default '0000-00-00 00:00:00',
  created_by varchar(255) not null default '',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  updated_by varchar(255) not null default '',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE currency (
  id integer unsigned not null auto_increment,
  alpha_3_4217 varchar(3) not null default '',
  number_3_4217 varchar(3) not null default '',
  exponent integer unsigned not null default '0',
  status enum('active','deleted') not null default 'active',
  created_at timestamp not null default '0000-00-00 00:00:00',
  created_by varchar(255) not null default '',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  updated_by varchar(255) not null default '',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE legal_entity (
  id integer unsigned not null auto_increment,
  merchant_id integer unsigned not null default '0',
  title varchar(255) not null default '',
  status enum('active','deleted') not null default 'active',
  created_at timestamp not null default '0000-00-00 00:00:00',
  created_by varchar(255) not null default '',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  updated_by varchar(255) not null default '',
  PRIMARY KEY (id),
  KEY merchant_id (merchant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE merchant (
  id integer unsigned not null auto_increment,
  company_id integer unsigned not null default '0',
  title varchar(255) not null default '',
  status enum('active','deleted') not null default 'active',
  created_at timestamp not null default '0000-00-00 00:00:00',
  created_by varchar(255) not null default '',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  updated_by varchar(255) not null default '',
  PRIMARY KEY (id),
  KEY company_id (company_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE merchant_account (
  id integer unsigned not null auto_increment,
  payment_system_id integer unsigned not null default '0',
  legal_entity_id integer unsigned not null default '0',
  tariff_id integer unsigned not null default '0',
  title varchar(255) not null default '',
  mid varchar(255) not null default '',
  currency_default_id integer unsigned not null default '0',
  is_global TINYINT(1) not null default '0',
  has_cascade TINYINT(1) not null default '0',
  cascade_filter_type enum('processor_result','processor_code', '') not null default '',
  cascade_filter_value varchar(255) not null default '',
  params text,
  status enum('active','deleted') not null default 'active',
  secure_3ds varchar(255) not null default '',
  pid varchar(255) not null default '',
  created_at timestamp not null default '0000-00-00 00:00:00',
  created_by varchar(255) not null default '',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  updated_by varchar(255) not null default '',
  PRIMARY KEY (id),
  KEY payment_system_id (payment_system_id),
  KEY legal_entity_id (legal_entity_id),
  KEY tariff_id (tariff_id),
  KEY currency_default_id (currency_default_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE merchant_account_cascade (
  id integer unsigned not null auto_increment,
  parent_merchant_account_id integer unsigned not null default '0',
  merchant_account_id integer unsigned not null default '0',
  priority  integer unsigned not null default '1',
  filter_type enum('processor_result','processor_code') not null default 'processor_result',
  filter_value varchar(255) not null default '',
  created_at timestamp not null default '0000-00-00 00:00:00',
  created_by varchar(255) not null default '',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  updated_by varchar(255) not null default '',
  PRIMARY KEY (id),
  KEY parent_merchant_account_id (parent_merchant_account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE payment_system (
  id integer unsigned not null auto_increment,
  title varchar(255) not null default '',
  class varchar(255) not null default '',
  url varchar(255) not null default '',
  required_ma_fields varchar(255) not null default '',
  params text,
  status enum('active','deleted') not null default 'active',
  created_at timestamp not null default '0000-00-00 00:00:00',
  created_by varchar(255) not null default '',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  updated_by varchar(255) not null default '',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE payment_system_allowed_currencies (
  payment_system_id integer unsigned not null default '0',
  currency_id integer unsigned not null default '0',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (payment_system_id, currency_id),
  KEY payment_system_id (payment_system_id),
  KEY currency_id (currency_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE route (
  id integer unsigned not null auto_increment,
  site_id integer unsigned not null default '0',
  filter_type enum('default','contains','amount_less','amount_greater','percent') not null default 'default',
  field enum('none','transaction_type','currency','card_type','country_by_ip','country_by_bin') not null default 'none',
  filter text,
  link_true_type enum('node','ma','error') not null default 'error',
  link_true_id bigint unsigned not null default '0',
  link_false_type enum('node','ma','error') not null default 'error',
  link_false_id bigint unsigned not null default '0',
  is_first tinyint unsigned not null default '0',
  status enum('active','deleted') not null default 'active',
  created_at timestamp not null default '0000-00-00 00:00:00',
  created_by varchar(255) not null default '',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  updated_by varchar(255) not null default '',
  PRIMARY KEY (id),
  KEY link_true_id (link_true_id),
  KEY link_false_id (link_false_id),
  KEY site_id (site_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE mpi (
  id bigint unsigned not null auto_increment,
  title varchar(255) not null default '',
  class varchar(255) not null default '',
  url varchar(255) not null default '',
  params text,
  status enum('active','deleted') not null default 'active',
  created_at timestamp not null default '0000-00-00 00:00:00',
  created_by varchar(255) not null default '',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  updated_by varchar(255) not null default '',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE site (
  id integer unsigned not null auto_increment,
  title varchar(255) not null default '',
  merchant_id integer unsigned not null default '0',
  mpi_id bigint unsigned not null default '0',
  fraudstop_id bigint unsigned not null default '0',
  country varchar(255) not null default '',
  secret_key varchar(255) not null default '',
  url varchar(255) not null default '',
  status enum('active','deleted') not null default 'active',
  created_at timestamp not null default '0000-00-00 00:00:00',
  created_by varchar(255) not null default '',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  updated_by varchar(255) not null default '',
  PRIMARY KEY (id),
  KEY merchant_id (merchant_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE site_allowed_currencies (
  site_id integer unsigned not null default '0',
  currency_id integer unsigned not null default '0',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (site_id, currency_id),
  KEY site_id (site_id),
  KEY currency_id (currency_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE merchant_account_allowed_currencies (
  ma_id integer unsigned not null default '0',
  currency_id integer unsigned not null default '0',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (ma_id, currency_id),
  KEY ma_id (ma_id),
  KEY currency_id (currency_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE tariff (
  id integer unsigned not null auto_increment,
  title varchar(255) not null default '',
  date_begin timestamp not null default '0000-00-00 00:00:00',
  date_end timestamp not null default '0000-00-00 00:00:00',
  status enum('active','deleted') not null default 'active',
  created_at timestamp not null default '0000-00-00 00:00:00',
  created_by varchar(255) not null default '',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  updated_by varchar(255) not null default '',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE reconciliation_history (
  id integer unsigned not null auto_increment,
  merchant_account_id integer unsigned not null default '0',
  payment_system_id integer unsigned not null default '0',
  ps_mid varchar(255) not null default '',
  result varchar(255) not null default '',
  response text,
  created_at timestamp not null default '0000-00-00 00:00:00',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE users (
  id bigint unsigned not null auto_increment,
  site_id bigint unsigned not null default '0',
  name varchar(190) not null default '',
  created_at timestamp not null default '0000-00-00 00:00:00',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  PRIMARY KEY (id),
  KEY site_id (site_id),
  UNIQUE KEY name_by_site (site_id, name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE card (
  id bigint unsigned not null auto_increment,
  user_id bigint unsigned not null default '0',
  bin varchar(6) not null default '',
  tail varchar(4) not null default '',
  exp_year integer unsigned not null default '0',
  exp_month integer unsigned not null default '0',
  holder varchar(255) not null default '',
  user_country varchar(2) not null default '',
  user_phone varchar(255) not null default '',
  user_email varchar(255) not null default '',
  status enum('active','deleted','invisible') not null default 'active',
  created_at timestamp not null default '0000-00-00 00:00:00',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  PRIMARY KEY (id),
  KEY user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE card_keys (
  id bigint unsigned not null auto_increment,
  token varchar(255) not null default '',
  key_id bigint not null default '0',
  status enum('active','deleted') not null default 'active',
  created_at timestamp not null default '0000-00-00 00:00:00',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE fraudstop (
  id bigint unsigned not null auto_increment,
  title varchar(255) not null default '',
  class varchar(255) not null default '',
  url varchar(255) not null default '',
  params text,
  status enum('active','deleted') not null default 'active',
  created_at timestamp not null default '0000-00-00 00:00:00',
  created_by varchar(255) not null default '',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  updated_by varchar(255) not null default '',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE recurring_registrations (
  id bigint unsigned not null auto_increment,
  register_transaction_id bigint unsigned not null default '0',
  card_id bigint unsigned not null default '0',
  ma_id integer unsigned not null default '0',
  recurring_acquirer_id varchar(255) not null default '',
  ps_client_id varchar(255) not null default '',
  valid_thru timestamp not null default '0000-00-00 00:00:00',
  status enum('initiated','active','deleted') not null default 'initiated',
  created_at timestamp not null default current_timestamp,
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  PRIMARY KEY (id),
  KEY register_operation_id (register_transaction_id),
  KEY ma_id (ma_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE callback_settings (
  id bigint unsigned not null auto_increment,
  site_id bigint unsigned not null default '0',
  body_format enum('basic','old') not null default 'basic',
  url varchar(255) not null default '',
  destination enum('terminal', 'merchant') not null default 'terminal',
  result_type enum('all','success','decline') not null default 'all',
  status enum('active','disabled','deleted') not null default 'active',
  created_at timestamp not null default '0000-00-00 00:00:00',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_by varchar(255) not null default '',
  updated_by varchar(255) not null default '',
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE general_data (
  id bigint unsigned not null auto_increment,
  transaction_id bigint unsigned not null default '0',
  ps_system_name varchar(255) not null default '',
  operation_id bigint unsigned not null default '0',
  gen_ma3DSecure varchar(255) not null default '',
  gen_pid varchar(255) not null default '',
  gen_email varchar(255) not null default '',
  gen_processor_name varchar(255) not null default '',
  gen_group_name varchar(255) not null default '',
  gen_acquirer_name varchar(255) not null default '',
  gen_source_type varchar(255) not null default '',
  gen_auth_code varchar(255) not null default '',
  gen_eci varchar(255) not null default '',
  gen_merchant_account_name varchar(255) not null default '',
  gen_merchant_account_id varchar(255) not null default '',
  gen_merchant_id  varchar(255) not null default '',
  gen_merchant_name varchar(255) not null default '',
  gen_site_id varchar(255) not null default '',
  gen_site_url varchar(255) not null default '',
  gen_user_login varchar(255) not null default '',
  gen_card_holder varchar(255) not null default '',
  gen_mid varchar(255) not null default '',
  gen_payment_instrument_id varchar(50) not null default '',
  gen_channel_currency varchar(3) not null default '',
  gen_channel_amount varchar(255) not null default '',
  gen_currency varchar(3) not null default '',
  gen_amount varchar(255) not null default '',
  gen_processor_date varchar(255) not null default '',
  gen_transaction_completion_date_and_time varchar(30) not null default '',
  gen_transaction_date_and_time varchar(30) not null default '',
  gen_transaction_ip varchar(255) not null default '',
  gen_transaction_status varchar(100) not null default '',
  gen_transaction_type  varchar(32) not null default '',
  gen_order varchar(150) not null default '',
  gen_processor_code_description varchar(255) not null default '',
  gen_processor_code varchar(10) not null default '',
  gen_acquirer_id varchar(255) not null default '',
  gen_country varchar(255) not null default '',
  gen_region varchar(255) not null default '',
  gen_city varchar(255) not null default '',
  gen_shipment_date_rev varchar(255) not null default '',
  gen_shipment_date varchar(255) not null default '',
  gen_arn varchar(255) not null default '',
  gen_reconciliation_date varchar(255) not null default '',
  gen_reconciliation_status varchar(255) not null default '',
  gen_msc_amount varchar(255) not null default '',
  gen_msc_currency varchar(255) not null default '',
  gen_fee_amount varchar(255) not null default '',
  gen_fee_currency varchar(255) not null default '',
  gen_bin_region varchar(255) not null default '',
  gen_bin_country varchar(255) not null default '',
  gen_bank_name varchar(255) not null default '',
  gen_account_funding_source varchar(255) not null default '',
  gen_payment_instrument_description varchar(255) not null default '',
  gen_payment_instrument_type varchar(255) not null default '',
  gen_mcc varchar(255) not null default '',
  gen_mcc_business_type varchar(255) not null default '',
  rest_params text,
  created_at timestamp not null default current_timestamp on update current_timestamp,
  PRIMARY KEY (id),
  KEY ps_payment_id (gen_acquirer_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
; 
insert into currency (id, alpha_3_4217, number_3_4217, exponent, status, created_by)
values
    (643, 'RUB', 643, 2, 'active', 'system'),
    (978, 'EUR', 978, 2, 'active', 'system'),
    (840, 'USD', 840, 2, 'active', 'system'),
    (826, 'GBP', 826, 2, 'active', 'system'),
    (392, 'JPY', 392, 0, 'active', 'system'),
    (756, 'CHF', 756, 2, 'active', 'system')
;

insert into payment_system (id, title, class, url, required_ma_fields, params, status, created_at, created_by)
values(
    1,
    'Decta',
    'Decta',
    'http://front01.dev.ams:8088/mockPaymentServerBinding',
    '[]',
    '{"wsdl":"rietumu.wsdl","cancel_period_hours":"24","refund_reverse_period_hours":"24"}',
    'active',
    NOW(),
    'system'
);

insert into company (id, title, domain, status, created_at, created_by)
values
    (1, 'ECP', 'www.ecommpay.com', 'active', NOW(), 'system'),
    (2, 'ACP', 'www.accent-pay.ru', 'active', NOW(), 'system'),
    (3, '1gp', '1gp.ru', 'active', NOW(), 'system')
;

insert into merchant (id, company_id, title, status, created_at, created_by)
values
    (4, 1, 'Кварк-Софт', 'active', NOW(), 'system'),
    (5, 2, 'Moogle', 'active', NOW(), 'system'),
    (6, 3, 'ACME', 'active', NOW(), 'system'),
    (7, 1, 'EcommPay_MerchantGlobal', 'active', NOW(), 'system')
;

insert into mpi (title, class, url, params, status, created_at, created_by)
values
    ('Modirum MPI @ dev.ams', 'Modirum', 'http://front01.dev.ams:8080/mdpaympi/MerchantServer', '{"mpi_secret":"123sff"}', 'active', NOW(), 'system')
;

insert into site (id, title, merchant_id, mpi_id, fraudstop_id, country, secret_key, status, created_at, created_by)
values
    (1, 'first born unicorn',   4, 1, 0, 'US', 'dfsdf1', 'active', NOW(), 'system'),
    (2, 'super binary options', 4, 1, 1, 'RU', 'dfsdf2', 'active', NOW(), 'system'),
    (3, 'payed search',         5, 1, 0, 'UK', 'dfsdf3', 'active', NOW(), 'system'),
    (4, 'lets-booze-tips.com',  4, 1, 0, 'IR', 'dfsdf4', 'active', NOW(), 'system'),
    (5, 'Rhino',                6, 1, 0, 'US', 'dfsdf5', 'active', NOW(), 'system'),
    (6, 'site with global merchant_account id', 7, 1, 0, 'RU', 'dfsdf6', 'active', NOW(), 'system'),
    (7, 'Купи-Валенок-су',      6, 1, 0, 'RU', '=xxx12', 'active', NOW(), 'system')
;

insert into legal_entity (id, title, merchant_id, status, created_at, created_by)
values
    (1, 'ООО Мугл-Россия', 5, 'active', NOW(), 'system'),
    (2, 'Acme Limited Gmbh.', 6, 'active', NOW(), 'system'),
    (3, 'ЗАО МУГЛ', 5, 'active', NOW(), 'system'),
    (4, 'ООО Кварк-Софт', 4, 'active', NOW(), 'system'),
    (5, 'ИП Лямкин А.В.', 4, 'active', NOW(), 'system'),
    (6, 'ООО Компьютерные решения', 4, 'active', NOW(), 'system'),
    (8, 'ООО Global Merchant Account', 7, 'active', NOW(), 'system')
;

insert into tariff (id, date_begin, status, created_at, created_by)
values
    (1, '2016-09-01 00:00', 'active', NOW(), 'system'),
    (2, '2016-09-25 12:00', 'active', NOW(), 'system'),
    (3, '2016-10-19 17:00', 'active', NOW(), 'system')
;

insert into merchant_account (id, title, payment_system_id, legal_entity_id, tariff_id, mid, currency_default_id, is_global, params, status, created_at, created_by)
values
    (1, 'zzz1', 1, 6, 1, '3940459', 840, 0,  '{}', 'active', NOW(), 'system'),
    (2, 'zzz2', 1, 1, 2, '77285', 643, 0, '{}', 'active', NOW(), 'system'),
    (3, 'zzz3', 1, 2, 1, '25', 826, 0, '{}', 'active', NOW(), 'system'),
    (4, 'zzz4', 1, 5, 2, '87', 978, 0, '{}', 'active', NOW(), 'system'),
    (5, 'zzz5', 1, 4, 1, '425', 643, 0, '{}', 'active', NOW(), 'system'),
    (6, 'zzz6', 1, 2, 2, '8294', 978, 0, '{}', 'active', NOW(), 'system'),
    (7, 'zzz7', 1, 2, 3, '25', 826, 0, '{}', 'active', NOW(), 'system'),
    (8, 'zzz8', 1, 4, 1, '2954', 840, 0, '{}', 'active', NOW(), 'system'),
    (9, 'gma9', 1, 0, 1, '777', 978, 1, '{}', 'active', NOW(), 'system'),
    (10, 'gma10', 1, 8, 2, '777', 978, 0, '{}', 'active', NOW(), 'system')
;

insert into route (id, site_id, filter_type, filter, field, status, created_at, created_by,    link_true_type, link_true_id, link_false_type, link_false_id, is_first)
values
    (2, 1, 'contains', '["visa"]', 'card_type', 'active', NOW(), 'system',              'ma', 4, 'ma', 1, 1),

    (12, 2, 'contains', '["payout"]', 'transaction_type', 'active', NOW(), 'system',    'ma', 1, 'ma', 4, 1),

    (5, 3, 'amount_less', '{"RUB":10000}', 'none', 'active', NOW(), 'system',           'ma', 5, 'node', 6, 1),
    (6, 3, 'amount_greater', '{"RUB":20000}', 'none', 'active', NOW(), 'system',        'ma', 8, 'ma', 2, 0),

    (11, 4, 'contains', '["RU"]', 'country_by_bin', 'active', NOW(), 'system',          'ma', 4, 'ma', 1, 1),

    (8, 5, 'contains', '["JPY"]', 'currency', 'active', NOW(), 'system',                'ma', 3, 'node', 9, 1),
    (9, 5, 'contains', '["GBP","EUR","CHF"]', 'currency', 'active', NOW(), 'system',    'ma', 7, 'ma', 6, 0),

    (13, 6, 'contains', '["EUR"]', 'currency', 'active', NOW(), 'system',               'ma', 9, 'node', 14, 1),
    (14, 6, 'percent', '0.3', 'none', 'active', NOW(), 'system',                        'ma', 10, 'ma', 6, 0),

    (15, 7, 'contains', '["RUB"]', 'currency', 'active', NOW(), 'system',               'ma', 3, 'error', 0, 1)
;

insert into callback_settings (site_id, body_format, url, destination, result_type, created_at, created_by)
values
    (1, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=site', 'merchant', 'success', NOW(), 'system'),
    (1, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=site', 'merchant', 'decline', NOW(), 'system'),
    (1, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=terminal', 'terminal', 'all', NOW(), 'system'),
    (2, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=site', 'merchant', 'success', NOW(), 'system'),
    (2, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=site', 'merchant', 'decline', NOW(), 'system'),
    (2, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=terminal', 'terminal', 'all', NOW(), 'system'),
    (3, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=site', 'merchant', 'success', NOW(), 'system'),
    (3, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=site', 'merchant', 'decline', NOW(), 'system'),
    (3, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=terminal', 'terminal', 'all', NOW(), 'system'),
    (4, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=site', 'merchant', 'success', NOW(), 'system'),
    (4, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=site', 'merchant', 'decline', NOW(), 'system'),
    (4, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=terminal', 'terminal', 'all', NOW(), 'system'),
    (5, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=site', 'merchant', 'success', NOW(), 'system'),
    (5, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=site', 'merchant', 'decline', NOW(), 'system'),
    (5, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=terminal', 'terminal', 'all', NOW(), 'system'),
    (6, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=site', 'merchant', 'success', NOW(), 'system'),
    (6, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=site', 'merchant', 'decline', NOW(), 'system'),
    (6, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=terminal', 'terminal', 'all', NOW(), 'system'),
    (7, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=site', 'merchant', 'success', NOW(), 'system'),
    (7, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=site', 'merchant', 'decline', NOW(), 'system'),
    (7, 'basic', 'http://front01.dev.ams/tools/callback.php?mode=terminal', 'terminal', 'all', NOW(), 'system')
;

insert into iin (bin, card_type, country)
values
    (400000, 'visa', 'US'),
    (411111, 'visa', 'US'),
    (555555, 'mastercard', 'RU'),
    (424242, 'visa', 'TR'),
    (401288, 'visa', 'JP'),
    (490000, 'visa', 'NO'),
    (431422, 'visa', 'RU'),
    (453912, 'visa', 'RU'),
    (471648, 'visa', 'RU'),
    (471682, 'visa', 'RU'),
    (557507, 'mastercard', 'RU'),
    (526189, 'mastercard', 'RU'),
    (557747, 'mastercard', 'RU'),
    (541333, 'mastercard', 'RU')
;

insert into site_allowed_currencies (site_id, currency_id)
values
    (1, 978),
    (1, 840),
    (1, 826),
    (2, 840),
    (2, 978),
    (2, 643),
    (2, 826),
    (3, 643),
    (3, 840),
    (4, 643),
    (4, 826),
    (4, 978),
    (4, 756),
    (5, 826),
    (5, 392),
    (5, 643),
    (5, 756),
    (5, 978),
    (6, 978),
    (6, 643),
    (6, 826),
    (7, 643),
    (7, 840)
;

insert into payment_system_allowed_currencies (payment_system_id, currency_id)
values
    (1, 978),
    (1, 840),
    (1, 643),
    (1, 826)
;

insert into merchant_account_allowed_currencies (ma_id, currency_id)
values
    (1, 840),
    (1, 643),
    (2, 643),
    (3, 978),
    (3, 643),
    (3, 826),
    (4, 978),
    (5, 643),
    (5, 840),
    (6, 643),
    (6, 826),
    (6, 978),
    (7, 826),
    (8, 643),
    (8, 840),
    (9, 978)
;

insert into currency_rate (currency_from, currency_to, rate, exponent, source_id, created_at)
values
    ('USD', 'RUB', 609084, 4, 1, '2016-12-27 10:00'), -- cbr
    ('EUR', 'RUB', 637285, 4, 1, '2016-12-27 10:00'), -- cbr
    ('USD', 'RUB', 638642, 4, 1, '2016-09-24 00:00'), -- cbr
    ('EUR', 'RUB', 715854, 4, 1, '2016-09-24 00:00'), -- cbr
    ('USD', 'RUB', 641506, 4, 1, '2016-09-26 14:32'), -- cbr
    ('EUR', 'RUB', 720604, 4, 1, '2016-09-26 14:32'), -- cbr
    ('USD', 'RUB', 61069, 3, 1, '2016-12-15 15:00'), -- cbr
    ('EUR', 'RUB', 649774, 4, 1, '2016-12-15 15:00'), -- cbr
    ('EUR', 'USD', 112512, 5, 2, '2016-09-26 14:32'), -- fxc
    ('GBP', 'USD', 129511, 5, 2, '2016-09-26 14:32'), -- fxc
    ('USD', 'JPY', 100372, 3, 2, '2016-09-26 14:32'), -- fxc
    ('USD', 'CHF', 96841, 5, 2, '2016-09-26 14:32'),  -- fxc
    ('EUR', 'GBP', 86431, 5, 2, '2016-09-27 13:46'),  -- fxc cross
    ('EUR', 'CHF', 108860, 5, 2, '2016-09-27 13:50'), -- fxc cross
    ('EUR', 'JPY', 112631, 3, 2, '2016-09-27 13:50'),  -- fxc cross
    ('GBP', 'JPY', 141571, 3, 2, '2017-01-09 12:50')
;

insert into fraudstop (title, class, url, params, status, created_at, created_by)
values
    ('Ecommpay Fraudstop server', 'Ecommpay', 'http://localhost:8089/', '{"app":"1","setup":"1","secret_key":"sdfsdfs"}', 'active', NOW(), 'system')
;
; 
USE System; DROP TABLE IF EXISTS Platform CASCADE;
DROP TABLE IF EXISTS Server CASCADE;
DROP TABLE IF EXISTS Shard CASCADE;
DROP TABLE IF EXISTS ShardServer CASCADE;
DROP TABLE IF EXISTS IDGeneration CASCADE;
DROP TABLE IF EXISTS ShardMap CASCADE;
DROP TABLE IF EXISTS ShardRequest CASCADE;


CREATE TABLE Platform (
  platform_id integer unsigned not null auto_increment,
  name varchar(255) not null default '',
  status enum('Active','Stopped') not null default 'Active',
  updated timestamp not null default current_timestamp on update current_timestamp,
  created timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (platform_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Server (
  server_id integer unsigned NOT NULL AUTO_INCREMENT,
  platform_id integer unsigned NOT NULL DEFAULT '0',
  name varchar(255) NOT NULL DEFAULT '',
  host varchar(255) NOT NULL DEFAULT '',
  login varchar(255) NOT NULL DEFAULT '',
  passwd varchar(255) NOT NULL DEFAULT '',
  status enum('Active','Stopped') NOT NULL DEFAULT 'Active',
  mode enum('ReadOnly','ReadWrite') NOT NULL DEFAULT 'ReadWrite',
  updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (server_id),
  KEY platform_id (platform_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE Shard (
  shard_id integer unsigned NOT NULL AUTO_INCREMENT,
  db_index integer unsigned NOT NULL DEFAULT '0',
  table_index integer unsigned NOT NULL DEFAULT '0',
  record_count integer unsigned NOT NULL DEFAULT '0',
  status enum('Active','Stopped') NOT NULL DEFAULT 'Active',
  mode enum('ReadOnly','ReadWrite') NOT NULL DEFAULT 'ReadWrite',
  updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (shard_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ShardServer (
  server_id integer unsigned NOT NULL DEFAULT '0',
  shard_id integer unsigned NOT NULL DEFAULT '0',
  status enum('Active','Stopped') NOT NULL DEFAULT 'Active',
  updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  created timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (server_id, shard_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IDGeneration (
  shard_id integer unsigned not null default '0',
  class integer unsigned not null default '0',
  id bigint(20) unsigned not null auto_increment,
  ts timestamp not null default current_timestamp on update current_timestamp,
  PRIMARY KEY (shard_id,class,id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ShardMap (
  site_id integer unsigned not null default '0',
  order_id varchar(180) NOT NULL DEFAULT '',
  shard_id integer unsigned NOT NULL DEFAULT '0',
  updated timestamp not null default current_timestamp on update current_timestamp,
  created timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (site_id, order_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ShardRequest (
  shard_id integer unsigned not null default '0',
  request_uid varchar(100) not null default '',
  ts timestamp not null default current_timestamp on update current_timestamp,
  PRIMARY KEY (shard_id,request_uid),
  UNIQUE KEY request_uid (request_uid)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
; 
# Platform
INSERT INTO `Platform` VALUES (255,'test ','Active','2016-12-01 19:28:23','0000-00-00 00:00:00');

# Server
INSERT INTO `Server` VALUES (1,255,'dev','localhost','writer','123456','Active','ReadWrite','2016-11-25 15:31:44','0000-00-00 00:00:00');

# Shard
INSERT INTO `Shard` VALUES (1,0,0,0,'Active','ReadWrite','2016-11-25 15:37:48','2016-11-25 15:37:48');
INSERT INTO `Shard` VALUES (2,1,0,0,'Active','ReadWrite','2016-11-25 15:37:48','2016-11-25 15:37:49');
INSERT INTO `Shard` VALUES (3,2,0,0,'Active','ReadWrite','2016-11-25 15:37:48','2016-11-25 15:37:50');

# ShardServer
INSERT INTO `ShardServer` VALUES (1,1,'Active','2016-12-02 16:42:31','2016-11-25 15:38:43');
INSERT INTO `ShardServer` VALUES (1,2,'Active','2016-12-02 16:42:31','2016-11-25 15:38:43');
INSERT INTO `ShardServer` VALUES (1,3,'Active','2016-12-02 16:42:31','2016-11-25 15:38:43');
; 
USE Shard00; DROP TABLE IF EXISTS request00 CASCADE;
DROP TABLE IF EXISTS operations00 CASCADE;
DROP TABLE IF EXISTS transactions00 CASCADE;
DROP TABLE IF EXISTS events00 CASCADE;
DROP TABLE IF EXISTS response00 CASCADE;

CREATE TABLE transactions00 (
  id bigint unsigned not null,
  company_id integer unsigned not null default '0',
  site_id integer unsigned not null default '0',
  order_id varchar(150) not null default '',
  type varchar(32) not null default '',
  status varchar(100) not null default '',
  amount bigint unsigned not null default '0',
  currency varchar(3) not null default '',
  processing_time VARCHAR(255) NOT NULL DEFAULT '',
  description VARCHAR(255) NOT NULL DEFAULT '',
  user_id bigint unsigned not null default '0',
  recurring_registration tinyint(1) not null default '0',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  parent_id bigint unsigned not null default '0',
  PRIMARY KEY (id),
  KEY site_order_type (site_id, order_id, type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE operations00 (
  id bigint unsigned not null,
  transaction_id bigint unsigned not null default '0',
  status varchar(255) not null default '',
  type varchar(255) not null default '',
  amount_incoming bigint unsigned not null default '0',
  currency_incoming varchar(3) not null default '',
  amount_converted bigint unsigned not null default '0',
  currency_converted varchar(3) not null default '',
  group_base varchar(255) not null default '',
  step integer unsigned not null default '0',
  parent_group_id integer unsigned not null default '0',
  merchant_account_id integer unsigned not null default '0',
  ps_transaction_id varchar(255) not null default '',
  card_id integer unsigned not null default '0',
  last_processor_message varchar(255) not null default '',
  last_processor_code varchar(10) not null default '',
  details text,
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (id),
  KEY transaction_id (transaction_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE events00 (
  id bigint unsigned not null,
  operation_id bigint unsigned not null default '0',
  type varchar(255) not null default '',
  status varchar(255) not null default '',
  new_op_status varchar(255) not null default '',
  new_tr_status varchar(255) not null default '',
  amount bigint unsigned not null default '0',
  currency varchar(3) not null default '',
  processor_message varchar(255) not null default '',
  processor_code varchar(10) not null default '',
  details text,
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (id),
  KEY operation_id (operation_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE request00 (
  id bigint unsigned not null,
  uid varchar(100) not null default '',
  content text,
  action text,
  status varchar(255) not null default '',
  errors text,
  company_id integer unsigned not null default '0',
  site_id integer unsigned not null default '0',
  order_id varchar(255) not null default '',
  user_id varchar(255) not null default '',
  transaction_id bigint unsigned not null default '0',
  ip bigint unsigned not null default '0',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (id),
  UNIQUE KEY uid (uid),
  KEY transaction_id (transaction_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE response00 (
  id bigint unsigned not null auto_increment,
  transaction_id bigint unsigned not null default '0',
  operation_id bigint unsigned not null default '0',
  step tinyint(1) not null default '0',
  ps_system_name varchar(255) not null default '',
  user_id bigint unsigned not null default '0',
  params text,
  created_at timestamp not null default current_timestamp on update current_timestamp,
  PRIMARY KEY (id),
  UNIQUE KEY transaction_operation_step (transaction_id, operation_id, step)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

; 
USE Shard01; DROP TABLE IF EXISTS request00 CASCADE;
DROP TABLE IF EXISTS operations00 CASCADE;
DROP TABLE IF EXISTS transactions00 CASCADE;
DROP TABLE IF EXISTS events00 CASCADE;
DROP TABLE IF EXISTS response00 CASCADE;

CREATE TABLE transactions00 (
  id bigint unsigned not null,
  company_id integer unsigned not null default '0',
  site_id integer unsigned not null default '0',
  order_id varchar(150) not null default '',
  type varchar(32) not null default '',
  status varchar(100) not null default '',
  amount bigint unsigned not null default '0',
  currency varchar(3) not null default '',
  processing_time VARCHAR(255) NOT NULL DEFAULT '',
  description VARCHAR(255) NOT NULL DEFAULT '',
  user_id bigint unsigned not null default '0',
  recurring_registration tinyint(1) not null default '0',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  parent_id bigint unsigned not null default '0',
  PRIMARY KEY (id),
  KEY site_order_type (site_id, order_id, type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE operations00 (
  id bigint unsigned not null,
  transaction_id bigint unsigned not null default '0',
  status varchar(255) not null default '',
  type varchar(255) not null default '',
  amount_incoming bigint unsigned not null default '0',
  currency_incoming varchar(3) not null default '',
  amount_converted bigint unsigned not null default '0',
  currency_converted varchar(3) not null default '',
  group_base varchar(255) not null default '',
  step integer unsigned not null default '0',
  parent_group_id integer unsigned not null default '0',
  merchant_account_id integer unsigned not null default '0',
  ps_transaction_id varchar(255) not null default '',
  card_id integer unsigned not null default '0',
  last_processor_message varchar(255) not null default '',
  last_processor_code varchar(10) not null default '',
  details text,
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (id),
  KEY transaction_id (transaction_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE events00 (
  id bigint unsigned not null,
  operation_id bigint unsigned not null default '0',
  type varchar(255) not null default '',
  status varchar(255) not null default '',
  new_op_status varchar(255) not null default '',
  new_tr_status varchar(255) not null default '',
  amount bigint unsigned not null default '0',
  currency varchar(3) not null default '',
  processor_message varchar(255) not null default '',
  processor_code varchar(10) not null default '',
  details text,
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (id),
  KEY operation_id (operation_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE request00 (
  id bigint unsigned not null,
  uid varchar(100) not null default '',
  content text,
  action text,
  status varchar(255) not null default '',
  errors text,
  company_id integer unsigned not null default '0',
  site_id integer unsigned not null default '0',
  order_id varchar(255) not null default '',
  user_id varchar(255) not null default '',
  transaction_id bigint unsigned not null default '0',
  ip bigint unsigned not null default '0',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (id),
  UNIQUE KEY uid (uid),
  KEY transaction_id (transaction_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE response00 (
  id bigint unsigned not null auto_increment,
  transaction_id bigint unsigned not null default '0',
  operation_id bigint unsigned not null default '0',
  step tinyint(1) not null default '0',
  ps_system_name varchar(255) not null default '',
  user_id bigint unsigned not null default '0',
  params text,
  created_at timestamp not null default current_timestamp on update current_timestamp,
  PRIMARY KEY (id),
  UNIQUE KEY transaction_operation_step (transaction_id, operation_id, step)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

; 
USE Shard02; DROP TABLE IF EXISTS request00 CASCADE;
DROP TABLE IF EXISTS operations00 CASCADE;
DROP TABLE IF EXISTS transactions00 CASCADE;
DROP TABLE IF EXISTS events00 CASCADE;
DROP TABLE IF EXISTS response00 CASCADE;

CREATE TABLE transactions00 (
  id bigint unsigned not null,
  company_id integer unsigned not null default '0',
  site_id integer unsigned not null default '0',
  order_id varchar(150) not null default '',
  type varchar(32) not null default '',
  status varchar(100) not null default '',
  amount bigint unsigned not null default '0',
  currency varchar(3) not null default '',
  processing_time VARCHAR(255) NOT NULL DEFAULT '',
  description VARCHAR(255) NOT NULL DEFAULT '',
  user_id bigint unsigned not null default '0',
  recurring_registration tinyint(1) not null default '0',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  parent_id bigint unsigned not null default '0',
  PRIMARY KEY (id),
  KEY site_order_type (site_id, order_id, type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE operations00 (
  id bigint unsigned not null,
  transaction_id bigint unsigned not null default '0',
  status varchar(255) not null default '',
  type varchar(255) not null default '',
  amount_incoming bigint unsigned not null default '0',
  currency_incoming varchar(3) not null default '',
  amount_converted bigint unsigned not null default '0',
  currency_converted varchar(3) not null default '',
  group_base varchar(255) not null default '',
  step integer unsigned not null default '0',
  parent_group_id integer unsigned not null default '0',
  merchant_account_id integer unsigned not null default '0',
  ps_transaction_id varchar(255) not null default '',
  card_id integer unsigned not null default '0',
  last_processor_message varchar(255) not null default '',
  last_processor_code varchar(10) not null default '',
  details text,
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (id),
  KEY transaction_id (transaction_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE events00 (
  id bigint unsigned not null,
  operation_id bigint unsigned not null default '0',
  type varchar(255) not null default '',
  status varchar(255) not null default '',
  new_op_status varchar(255) not null default '',
  new_tr_status varchar(255) not null default '',
  amount bigint unsigned not null default '0',
  currency varchar(3) not null default '',
  processor_message varchar(255) not null default '',
  processor_code varchar(10) not null default '',
  details text,
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (id),
  KEY operation_id (operation_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE request00 (
  id bigint unsigned not null,
  uid varchar(100) not null default '',
  content text,
  action text,
  status varchar(255) not null default '',
  errors text,
  company_id integer unsigned not null default '0',
  site_id integer unsigned not null default '0',
  order_id varchar(255) not null default '',
  user_id varchar(255) not null default '',
  transaction_id bigint unsigned not null default '0',
  ip bigint unsigned not null default '0',
  updated_at timestamp not null default current_timestamp on update current_timestamp,
  created_at timestamp not null default '0000-00-00 00:00:00',
  PRIMARY KEY (id),
  UNIQUE KEY uid (uid),
  KEY transaction_id (transaction_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE response00 (
  id bigint unsigned not null auto_increment,
  transaction_id bigint unsigned not null default '0',
  operation_id bigint unsigned not null default '0',
  step tinyint(1) not null default '0',
  ps_system_name varchar(255) not null default '',
  user_id bigint unsigned not null default '0',
  params text,
  created_at timestamp not null default current_timestamp on update current_timestamp,
  PRIMARY KEY (id),
  UNIQUE KEY transaction_operation_step (transaction_id, operation_id, step)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

