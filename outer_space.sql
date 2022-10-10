-- from the terminal run:
-- psql < outer_space.sql

DROP DATABASE IF EXISTS outer_space;

CREATE DATABASE outer_space;

\c outer_space

CREATE TABLE galaxies
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL  
);

CREATE TABLE suns
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  galaxy INT REFERENCES galaxies ON DELETE CASCADE
);

CREATE TABLE planets
(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  orbital_period_in_years FLOAT NOT NULL,
  orbits_around INT REFERENCES suns ON DELETE CASCADE,
  moons TEXT[]
);

INSERT INTO galaxies
  (name)
VALUES
  ('Milky Way');

INSERT INTO suns
  (name, galaxy)
VALUES
  ('The Sun', 1),
  ('Proxima Centauri', 1),
  ('Gliese 876', 1);

INSERT INTO planets
  (name, orbital_period_in_years, orbits_around, moons)
VALUES
  ('Earth', 1.00, 1, '{"The Moon"}'),
  ('Mars', 1.88, 1, '{"Phobos", "Deimos"}'),
  ('Venus', 0.62, 1, '{}'),
  ('Neptune', 164.8, 1, '{"Naiad", "Thalassa", "Despina", "Galatea", "Larissa", "S/2004 N 1", "Proteus", "Triton", "Nereid", "Halimede", "Sao", "Laomedeia", "Psamathe", "Neso"}'),
  ('Proxima Centauri b', 0.03, 2, '{}'),
  ('Gliese 876 b', 0.23, 3, '{}');