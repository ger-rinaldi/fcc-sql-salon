CREATE TABLE customers(
  customer_id SERIAL NOT NULL PRIMARY KEY,
  name VARCHAR(60),
  phone VARCHAR(60) UNIQUE);

CREATE TABLE services(
  service_id SERIAL NOT NULL PRIMARY KEY,
  name VARCHAR(60));

CREATE TABLE appointments(
  appointment_id SERIAL NOT NULL PRIMARY KEY,
  time VARCHAR(5),
  customer_id INT NOT NULL REFERENCES customers(customer_id),
  service_id INT NOT NULL REFERENCES services(service_id));

INSERT INTO services(name) VALUES ('haircut'), ('hairwash'), ('nailclipping');
