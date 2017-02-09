CREATE TABLE dragons (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    owner_id INTEGER,

    FOREIGN KEY(owner_id) REFERENCES targaryen(id)
);

CREATE TABLE targaryens (
    id INTEGER PRIMARY KEY,
    fname VARCHAR(255) NOT NULL,
    lname VARCHAR(255) NOT NULL,
    rival_id INTEGER,

    FOREIGN KEY(rival_id) REFERENCES rivals(id)
);

CREATE TABLE rivals (
    id INTEGER PRIMARY KEY,
    house VARCHAR(255) NOT NULL
);

INSERT INTO
    rivals (id, house)
VALUES
    (1, "Stark"), (2, "Baratheon"), (3, "Lannister");

INSERT INTO
    targaryens (id, fname, lname, rival_id)
VALUES
    (1, "Aegon", "Targaryen", 2),
    (2, "Visenya", "Targaryen", 1),
    (3, "Rhaenys", "Targaryen", 3),
    (4, "dragonless", "Human", NULL);

INSERT INTO
    dragons (id, name, owner_id)
VALUES
    (1, "Balerion", 1),
    (2, "Vhagar", 2),
    (3, "Meraxes", 3),
    (4, "Stray Dragon", NULL);
