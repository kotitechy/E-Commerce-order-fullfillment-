create database orders_db;
use orders_db;


CREATE TABLE orders (
order_id VARCHAR(24) PRIMARY KEY,
customer_id VARCHAR(20) NOT NULL,
customer_email VARCHAR(150) NOT NULL,
currency CHAR(3) NOT NULL,
order_total DECIMAL(12,2) NOT NULL,
payment_method VARCHAR(30),
payment_ref VARCHAR(60),
status VARCHAR(24) NOT NULL,
invoice_number VARCHAR(24),
request_id VARCHAR(64) NOT NULL,
correlation_id VARCHAR(64) NOT NULL,
accepted_at TIMESTAMP NOT NULL,
fulfilled_at TIMESTAMP,
notified_at TIMESTAMP,
CONSTRAINT uq_orders_request UNIQUE (request_id),
CONSTRAINT ck_orders_status CHECK (status IN
('ACCEPTED','RESERVED','FULFILLED','BACKORDERED',
'FULFILLED_NOT_NOTIFIED','FAILED'))
);

CREATE TABLE order_items (
order_item_id BIGINT PRIMARY KEY AUTO_INCREMENT,
order_id VARCHAR(24) NOT NULL,
sku VARCHAR(30) NOT NULL,
product_name VARCHAR(150) NOT NULL,
quantity INT NOT NULL,
unit_price DECIMAL(12,2) NOT NULL,
tax_rate_percent DECIMAL(5,2) NOT NULL,
line_total DECIMAL(12,2) NOT NULL,
reserved_qty INT NOT NULL DEFAULT 0,line_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
CONSTRAINT fk_items_order FOREIGN KEY (order_id)
REFERENCES orders(order_id),
CONSTRAINT ck_items_qty CHECK (quantity > 0)
);

CREATE TABLE inventory_stock (
sku VARCHAR(30) PRIMARY KEY,
available_qty INT NOT NULL,
reserved_qty INT NOT NULL DEFAULT 0,
reorder_point INT NOT NULL DEFAULT 0,
updated_at TIMESTAMP NOT NULL,
CONSTRAINT ck_stock_nonneg CHECK (available_qty >= 0)
);

CREATE TABLE invoices (
invoice_number VARCHAR(24) PRIMARY KEY,
order_id VARCHAR(24) NOT NULL,
invoice_date DATE NOT NULL,
taxable_amount DECIMAL(12,2) NOT NULL,
tax_amount DECIMAL(12,2) NOT NULL,
payable_total DECIMAL(12,2) NOT NULL,
file_path VARCHAR(300) NOT NULL,
archive_path VARCHAR(300) NOT NULL,
generated_at TIMESTAMP NOT NULL,
CONSTRAINT uq_invoice_order UNIQUE (order_id),
CONSTRAINT fk_invoice_order FOREIGN KEY (order_id)
REFERENCES orders(order_id)
);

CREATE TABLE processed_messages (
jms_message_id VARCHAR(120) PRIMARY KEY,
consumer_name VARCHAR(60) NOT NULL,
order_id VARCHAR(24),
processed_at TIMESTAMP NOT NULL
);

-- Conditional reservation: affected row count is the authority
UPDATE inventory_stock 
SET available_qty = available_qty - 5, 
    reserved_qty = reserved_qty + 5, 
    updated_at = CURRENT_TIMESTAMP 
WHERE sku = 'SKU-1001' 
  AND available_qty >= 5;
