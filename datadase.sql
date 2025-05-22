CREATE TABLE systems (
  system_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  location VARCHAR(255),
  installation_date DATE,
  application_type ENUM('home', 'commercial'),
  description TEXT
);

CREATE TABLE components (
  component_id INT AUTO_INCREMENT PRIMARY KEY,
  system_id INT,
  type ENUM('panel', 'inverter', 'battery', 'charge_controller', 'combiner_box'),
  manufacturer VARCHAR(100),
  model VARCHAR(100),
  serial_number VARCHAR(100),
  install_date DATE,
  FOREIGN KEY (system_id) REFERENCES systems(system_id)
);
CREATE TABLE sensor_readings (
  reading_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  component_id INT,
  timestamp DATETIME,
  voltage DECIMAL(10,2),
  current DECIMAL(10,2),
  power DECIMAL(10,2),
  battery_level DECIMAL(5,2),
  FOREIGN KEY (component_id) REFERENCES components(component_id)
);

CREATE TABLE alerts (
  alert_id INT AUTO_INCREMENT PRIMARY KEY,
  system_id INT,
  component_id INT,
  alert_type VARCHAR(100),
  message TEXT,
  timestamp DATETIME,
  resolved BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (system_id) REFERENCES systems(system_id),
  FOREIGN KEY (component_id) REFERENCES components(component_id)
);

CREATE TABLE energy_logs (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  system_id INT,
  log_date DATE,
  energy_generated_kwh DECIMAL(10,2),
  energy_consumed_kwh DECIMAL(10,2),
  FOREIGN KEY (system_id) REFERENCES systems(system_id)
);
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('admin', 'installer', 'technician', 'end_user') NOT NULL,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  phone_number VARCHAR(20),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_settings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  setting_name VARCHAR(100) NOT NULL,
  setting_value VARCHAR(255),
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY unique_user_setting (user_id, setting_name),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);


INSERT INTO systems (name, location, installation_date, application_type, description)
VALUES
  ('Nairobi Home Solar', 'Nairobi, Kenya', '2024-03-15', 'home', '5kW rooftop system for residential use'),
  ('Mombasa Commercial Plant', 'Mombasa, Kenya', '2023-11-05', 'commercial', '50kW solar array for commercial facility');

INSERT INTO components (system_id, type, manufacturer, model, serial_number, install_date)
VALUES
  (1, 'panel', 'SunPower', 'SPX-300', 'SPX300-NA-001', '2024-03-15'),
  (1, 'inverter', 'Huawei', 'SUN2000-5KTL', 'HW-INVT-001', '2024-03-15'),
  (1, 'battery', 'Tesla', 'Powerwall 2', 'TESLA-BAT-001', '2024-03-16'),
  (2, 'panel', 'LG', 'LG400N2T-A5', 'LG400-MB-001', '2023-11-05'),
  (2, 'inverter', 'SMA', 'Sunny Tripower 50', 'SMA-INVT-002', '2023-11-06');

INSERT INTO sensor_readings (component_id, timestamp, voltage, current, power, battery_level)
VALUES
  (1, '2025-05-21 08:00:00', 380.5, 13.2, 5026.6, NULL),
  (2, '2025-05-21 08:00:00', 400.0, 12.5, 5000.0, NULL),
  (3, '2025-05-21 08:00:00', NULL, NULL, NULL, 85.0),
  (4, '2025-05-21 08:00:00', 370.0, 135.0, 49950.0, NULL),
  (5, '2025-05-21 08:00:00', 400.0, 125.0, 50000.0, NULL);

INSERT INTO alerts (system_id, component_id, alert_type, message, timestamp, resolved)
VALUES
  (1, 3, 'Battery Low', 'Battery level dropped below 20%', '2025-05-20 18:45:00', FALSE),
  (2, 5, 'Inverter Fault', 'Inverter reported over-temperature warning', '2025-05-19 14:30:00', TRUE);

INSERT INTO energy_logs (system_id, log_date, energy_generated_kwh, energy_consumed_kwh)
VALUES
  (1, '2025-05-20', 28.5, 24.0),
  (2, '2025-05-20', 220.0, 180.0);

INSERT INTO users (
  username,
  email,
  password_hash,
  role,
  first_name,
  last_name,
  phone_number,
  is_active,
  created_at
) VALUES
  (
    'admin_user',
    'admin@gmail.com',
    '$2y$10$E9N1b1zQwK1/8eFZ1u5e1u5e1u5e1u5e1u5e1u5e1u5e1u5e1u5e', -- bcrypt hash of 'AdminPass123!'
    'admin',
    'Alice',
    'Admin',
    '+254700000001',
    TRUE,
    NOW()
  ),
  (
    'installer_john',
    'john.installer@gmail.com',
    '$2y$10$F3N2b2zQwK2/9fGZ2v6f2v6f2v6f2v6f2v6f2v6f2v6f2v6f2v6f', -- bcrypt hash of 'InstallerPass456!'
    'installer',
    'John',
    'Installer',
    '+254700000002',
    TRUE,
    NOW()
  ),
  (
    'tech_jane',
    'jane.tech@gmail.com',
    '$2y$10$G4O3c3zRwL3/0gHZ3w7g3w7g3w7g3w7g3w7g3w7g3w7g3w7g3w7g', -- bcrypt hash of 'TechPass789!'
    'technician',
    'Jane',
    'Technician',
    '+254700000003',
    TRUE,
    NOW()
  ),
  (
    'business_owner_bob',
    'bob.business@gmail.com',
    '$2y$10$H5P4d4zSwM4/1hIZ4x8h4x8h4x8h4x8h4x8h4x8h4x8h4x8h4x8h', -- bcrypt hash of 'BusinessPass321!'
    'end_user',
    'Bob',
    'BusinessOwner',
    '+254700000004',
    TRUE,
    NOW()
  ),
  (
    'homeowner_susan',
    'susan.home@gmail.com',
    '$2y$10$I6Q5e5zTxN5/2iJZ5y9i5y9i5y9i5y9i5y9i5y9i5y9i5y9i5y9i', -- bcrypt hash of 'HomePass654!'
    'end_user',
    'Susan',
    'Homeowner',
    '+254700000005',
    TRUE,
    NOW()
  );

INSERT INTO user_settings (user_id, setting_name, setting_value)
VALUES
  (1, 'theme', 'dark'),
  (1, 'notifications_enabled', 'true');

INSERT INTO user_settings (user_id, setting_name, setting_value)
VALUES
  (2, 'theme', 'light'),
  (2, 'notifications_enabled', 'false');

INSERT INTO user_settings (user_id, setting_name, setting_value)
VALUES
  (3, 'theme', 'dark'),
  (3, 'notifications_enabled', 'true');

INSERT INTO user_settings (user_id, setting_name, setting_value)
VALUES
  (4, 'theme', 'light'),
  (4, 'notifications_enabled', 'true');

INSERT INTO user_settings (user_id, setting_name, setting_value)
VALUES
  (5, 'theme', 'dark'),
  (5, 'notifications_enabled', 'false');

SELECT setting_value
FROM user_settings
WHERE user_id = 1 AND setting_name = 'theme';

INSERT INTO user_settings (user_id, setting_name, setting_value)
VALUES (1, 'theme', 'light')
ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value);
