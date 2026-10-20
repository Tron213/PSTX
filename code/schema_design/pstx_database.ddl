CREATE SCHEMA IF NOT EXISTS pstx;


CREATE TABLE IF NOT EXISTS pstx.places  (
    id UUID PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS pstx.rfids  (
    id UUID PRIMARY KEY,
    tag_epc TEXT NOT NULL UNIQUE
);



CREATE TABLE IF NOT EXISTS pstx.cow_card   (
    id UUID PRIMARY KEY,
    name TEXT NOT NULL,
    place_id UUID NOT NULL REFERENCES pstx.places(id),
    rfid_id UUID NOT NULL REFERENCES pstx.rfids(id),
    sex VARCHAR(6) NOT NULL
        CHECK (sex IN ('male', 'female')),
    born_day DATE NOT NULL,
    mother UUID REFERENCES pstx.cow_card(id),
    father UUID REFERENCES pstx.cow_card(id)

);


CREATE TABLE IF NOT EXISTS pstx.weight_logs  (
    id UUID PRIMARY KEY,
    cow_id UUID NOT NULL REFERENCES pstx.cow_card(id),
    weight NUMERIC(15,2) NOT NULL,
    measured_at timestamp with time zone DEFAULT NOW()
);


CREATE TABLE IF NOT EXISTS pstx.ai_helps  (
    id UUID PRIMARY KEY,
    cow_id UUID NOT NULL REFERENCES pstx.cow_card(id),
    message TEXT NOT NULL,
    help_at timestamp with time zone DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS cow_weight_idx
ON pstx.weight_logs (cow_id, measured_at DESC);

CREATE INDEX IF NOT EXISTS ai_helping_idx
ON pstx.ai_helps (cow_id, help_at DESC);