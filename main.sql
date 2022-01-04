CREATE TABLE agent(
    first_name        VARCHAR2(10) NOT NULL,
    middle_name        VARCHAR2(10) NOT NULL,
    last_name        VARCHAR2(10) NOT NULL,
    age        NUMBER(3) NOT NULL,
    passport_num    VARCHAR2(9) UNIQUE NOT NULL
                CHECK(passport_num LIKE 'A________'),
    agent_ID      NUMBER(5) PRIMARY KEY
);

CREATE TABLE agent_phone_num(
    agent_id  NUMBER(5)
        REFERENCES agent (agent_id),
    phone_num  VARCHAR2(11)
        CHECK(phone_num LIKE '01_________'),
    PRIMARY KEY (agent_id, phone_num) 
);

CREATE TABLE agent_email(
    agent_id  NUMBER(5)
        REFERENCES agent (agent_id),
    agent_email  VARCHAR2(30)
        CHECK(agent_email LIKE '%@%.__%'),
    PRIMARY KEY (agent_id, agent_email) 
);

CREATE TABLE payment(
    payment_date      DATE NOT NULL,
    payment_amount        NUMBER(6) NOT NULL,
    payment_method    VARCHAR2(10) NOT NULL,
    payment_code      NUMBER(5) PRIMARY KEY
);

CREATE TABLE airline(
    airline_Name  VARCHAR2(30) UNIQUE NOT NULL,
    airline_location VARCHAR2(30) NOT NULL,
    airline_id  NUMBER(4) PRIMARY KEY
);

CREATE TABLE aircraft(
    aircraft_capacity  NUMBER(3) NOT NULL,
    aircraft_model VARCHAR2(10) NOT NULL,
    aircraft_id NUMBER(4) PRIMARY KEY,
    airline_id NUMBER(4) NOT NULL
        REFERENCES airline (airline_id)
);

CREATE TABLE airport(
    airport_name  VARCHAR2(30) UNIQUE NOT NULL, 
    airport_location  VARCHAR2(30) NOT NULL,
    airport_code  VARCHAR2(10) PRIMARY KEY
);

CREATE TABLE flight(
    flight_destination  VARCHAR2(50) NOT NULL,
    arrival_time  VARCHAR2(20) NOT NULL, --11:00pm
    aircraft_id  NUMBER(4) NOT NULL
        REFERENCES aircraft (aircraft_id),
    available_seats NUMBER(3) NOT NULL,
    flight_date  DATE  NOT NULL,
    departure_time  VARCHAR2(20)  NOT NULL,
    flight_source  VARCHAR2(50)  NOT NULL,
    airport_code VARCHAR2(10) NOT NULL
        REFERENCES airport (airport_code),
    flight_num  NUMBER(4) PRIMARY KEY
);

CREATE TABLE flight_transit(
    transit_time  VARCHAR2(20) NOT NULL, 
    transit_location  VARCHAR2(50) NOT NULL,
    flight_num  NUMBER(4) NOT NULL
        REFERENCES flight (flight_num),
    PRIMARY KEY (transit_time, transit_location, flight_num)
);

CREATE TABLE ticket(
    ticket_id      NUMBER(10) PRIMARY KEY,
    class_type        VARCHAR2(12) NOT NULL,
    seat_num    NUMBER(3) NOT NULL,
    flight_num  NUMBER(4) NOT NULL
        REFERENCES flight (flight_num),
    payment_code  NUMBER(5) UNIQUE NOT NULL
        REFERENCES payment (payment_code),
    airline_id  NUMBER(4) NOT NULL
        REFERENCES airline (airline_id),
    agent_id  NUMBER(5) NOT NULL
        REFERENCES agent (agent_id) 
);

CREATE SEQUENCE agent_sequence;
CREATE SEQUENCE payment_sequence;
CREATE SEQUENCE airline_sequence;
CREATE SEQUENCE aircraft_sequence;
CREATE SEQUENCE flight_sequence;
CREATE SEQUENCE ticket_sequence;

CREATE OR REPLACE TRIGGER agent_on_insert
  BEFORE INSERT ON agent
  FOR EACH ROW
BEGIN
  SELECT agent_sequence.nextval
  INTO :new.agent_ID
  FROM dual;
END;

CREATE OR REPLACE TRIGGER payment_on_insert
  BEFORE INSERT ON payment
  FOR EACH ROW
BEGIN
  SELECT payment_sequence.nextval
  INTO :new.payment_code
  FROM dual;
END;

CREATE OR REPLACE TRIGGER airline_on_insert
  BEFORE INSERT ON airline
  FOR EACH ROW
BEGIN
  SELECT airline_sequence.nextval
  INTO :new.airline_id
  FROM dual;
END;

CREATE OR REPLACE TRIGGER aircraft_on_insert
  BEFORE INSERT ON aircraft
  FOR EACH ROW
BEGIN
  SELECT aircraft_sequence.nextval
  INTO :new.aircraft_id
  FROM dual;
END;

CREATE OR REPLACE TRIGGER flight_on_insert
  BEFORE INSERT ON flight
  FOR EACH ROW
BEGIN
  SELECT flight_sequence.nextval
  INTO :new.flight_num
  FROM dual;
END;

CREATE OR REPLACE TRIGGER ticket_on_insert
  BEFORE INSERT ON ticket
  FOR EACH ROW
BEGIN
  SELECT ticket_sequence.nextval
  INTO :new.ticket_id
  FROM dual;
END;