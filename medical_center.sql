DROP DATABASE IF EXISTS medical_center;

CREATE DATABASE medical_center;

\c medical_center

CREATE TABLE medical_center
(
  id SERIAL PRIMARY KEY,
  center_name TEXT NOT NULL,
  city TEXT NOT NULL
);

CREATE TABLE doctors
(
  id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  title TEXT NOT NULL,
  sex TEXT NOT NULL,
  doctor_type TEXT NOT NULL,
  med_center_id INTEGER REFERENCES medical_center ON DELETE SET NULL
);

CREATE TABLE patients
(
  id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  sex TEXT NOT NULL,
  age INTEGER NOT NULL
);

CREATE TABLE diseases
(
  id SERIAL PRIMARY KEY,
  disease TEXT NOT NULL
);

CREATE TABLE doctor_patient
(
  id SERIAL PRIMARY KEY,
  doctor_id INTEGER REFERENCES doctors ON DELETE CASCADE,
  patient_id INTEGER REFERENCES patients ON DELETE CASCADE,
  treating INTEGER REFERENCES diseases ON DELETE SET NULL
);

CREATE TABLE disease_patient
(
  id SERIAL PRIMARY KEY,
  disease_id INTEGER REFERENCES diseases ON DELETE CASCADE,
  patient_id INTEGER REFERENCES patients ON DELETE CASCADE
);

INSERT INTO medical_center
  (center_name, city)
VALUES
  ('Ingham County Medical Center', 'Lansing'),
  ('Sparrow Hospital', 'Lansing'),
  ('McLaren Medical Center', 'East Lansing'),
  ('Urgent Care of Lansing', 'DeWitt');

INSERT INTO patients
  (first_name, last_name, sex, age)
VALUES
  ('John', 'Williams', 'M', 85),
  ('Kathleen', 'Johnson', 'F', 54),
  ('Daniel', 'Tressel', 'M', 40),
  ('Cynthia', 'Rodriguez', 'F', 32),
  ('Johnny', 'Monsoon', 'M', 17),
  ('Abigail', 'Lee', 'F', 15),
  ('Martha', 'Stewart', 'F', 78),
  ('Holly', 'Silverstein', 'F', 33);

INSERT INTO doctors
  (first_name, last_name, title, sex, doctor_type, med_center_id)
VALUES
  ('Mary', 'Chao', 'DO', 'F', 'Family Doctor', 3),
  ('John', 'Phillip', 'DO', 'M', 'Allergist', 4),
  ('Susan', 'Summers', 'MD', 'F', 'Cardiologist', 2),
  ('Jenny', 'Baek', 'MD', 'F', 'Oncologist', 1),
  ('Steven', 'Johnson', 'MD', 'M', 'Endocrinologist', 1),
  ('Daniel', 'Goodwin', 'MD', 'M', 'Urologist', 2);

INSERT INTO diseases
  (disease)
VALUES
  ('Flu'),
  ('Cold'),
  ('Heart Disease'),
  ('Urinary Tract Infection'),
  ('Skin Cancer'),
  ('Severe Food Allergies'),
  ('Periodic Paralysis');

INSERT INTO doctor_patient
  (doctor_id, patient_id, treating)
VALUES
  (1, 3, 1),
  (6, 8, 7),
  (1, 2, 1),
  (2, 3, 6),
  (3, 4, 5),
  (4, 5, 4),
  (5, 6, 3),
  (1, 7, 2),
  (1, 5, 1),
  (2, 7, 3);

INSERT INTO disease_patient
  (disease_id, patient_id)
VALUES
  (1, 3),
  (7, 8),
  (1, 2),
  (6, 3),
  (5, 4),
  (4, 5),
  (3, 6),
  (2, 7),
  (1, 5),
  (3, 7),
  (6, 2),
  (5, 3),
  (4, 4),
  (3, 5),
  (2, 1),
  (1, 4),
  (3, 2);

-- Show table of patients, listed diseases, and the doctors treating those patients for their diseases
SELECT patients.first_name, patients.last_name, disease, doctors.last_name AS doctor
FROM patients
JOIN disease_patient ON patient_id = patients.id
JOIN diseases ON diseases.id = disease_id
JOIN doctor_patient ON treating = diseases.id
JOIN doctors ON doctors.id = doctor_patient.doctor_id
ORDER BY patients.last_name;