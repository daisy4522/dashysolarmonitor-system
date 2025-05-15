CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'user') NOT NULL DEFAULT 'user',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE solar_systems (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    location VARCHAR(255) NOT NULL,
    system_size_kw FLOAT NOT NULL,
    inverter_model VARCHAR(255) NOT NULL,
    battery_capacity_kwh FLOAT,
    installation_date DATE NOT NULL,
    timezone VARCHAR(100) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
);

CREATE TABLE sensor_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    system_id INT NOT NULL,
    timestamp DATETIME NOT NULL,
    solar_generation_kw FLOAT NOT NULL,
    home_consumption_kw FLOAT NOT NULL,
    battery_charge_kw FLOAT NOT NULL,
    battery_discharge_kw FLOAT NOT NULL,
    grid_export_kw FLOAT NOT NULL,
    grid_import_kw FLOAT NOT NULL,
    INDEX idx_timestamp (timestamp),
    FOREIGN KEY (system_id) REFERENCES solar_systems(id)
        ON DELETE CASCADE
);

CREATE TABLE alerts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    system_id INT NOT NULL,
    alert_type VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (system_id) REFERENCES solar_systems(id)
        ON DELETE CASCADE
);

CREATE TABLE settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    notify_email BOOLEAN NOT NULL DEFAULT TRUE,
    notify_sms BOOLEAN NOT NULL DEFAULT FALSE,
    daily_report_time TIME NOT NULL,
    preferred_units ENUM('kW', 'Watts') NOT NULL DEFAULT 'kW',
    FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE
);

INSERT INTO users (username, email, password_hash, role)
VALUES 
('admin_user', 'admin@gmail.com', 'hashedpassword123', 'admin'),
('johndoe', 'john@gmail.com', 'hashedpassword456', 'user'),
('janedoe', 'jane@gmail.com', 'hashedpassword789', 'user');


INSERT INTO solar_systems (user_id, location, system_size_kw, inverter_model, battery_capacity_kwh, installation_date, timezone)
VALUES 
(2, '123 Solar St, California, USA', 5.5, 'InverterX1000', 10.0, '2023-04-15', 'America/Los_Angeles'),
(3, '456 Eco Ave, Texas, USA', 7.0, 'PowerMax2000', 15.0, '2023-05-10', 'America/Chicago');


INSERT INTO sensor_data (system_id, timestamp, solar_generation_kw, home_consumption_kw, battery_charge_kw, battery_discharge_kw, grid_export_kw, grid_import_kw)
VALUES 
(1, '2025-05-05 10:00:00', 3.2, 2.8, 0.5, 0.0, 0.4, 0.1),
(1, '2025-05-05 11:00:00', 4.0, 3.0, 0.7, 0.0, 1.0, 0.0),
(2, '2025-05-05 10:00:00', 5.5, 4.5, 1.0, 0.0, 0.8, 0.2),
(2, '2025-05-05 11:00:00', 6.2, 4.8, 1.2, 0.0, 1.0, 0.1);


INSERT INTO alerts (system_id, alert_type, message)
VALUES 
(1, 'Low Battery', 'Battery charge dropped below 20%'),
(2, 'Grid Outage', 'Grid power lost at 10:00 AM on May 5, 2025');


INSERT INTO settings (user_id, notify_email, notify_sms, daily_report_time, preferred_units)
VALUES 
(2, TRUE, FALSE, '08:00:00', 'kW'),
(3, TRUE, TRUE, '07:30:00', 'Watts');
