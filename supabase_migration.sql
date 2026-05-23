-- =========================================================================
-- MIGRACIÓN PARA SUPABASE
-- =========================================================================

-- 1. Agregar columnas de potenciadores a la tabla 'perfiles'
ALTER TABLE perfiles 
ADD COLUMN IF NOT EXISTS boosters_30s INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS boosters_1m INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS boosters_2m INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS max_unlocked_level INTEGER DEFAULT 1;

-- 2. Crear tabla de niveles
CREATE TABLE IF NOT EXISTS niveles (
    id INT PRIMARY KEY,
    level_name TEXT NOT NULL,
    time_limit DOUBLE PRECISION NOT NULL,
    is_hard BOOLEAN DEFAULT FALSE,
    items_to_collect INT NOT NULL,
    coins_reward INT NOT NULL,
    unlocks_story BOOLEAN DEFAULT FALSE,
    camera_notice TEXT DEFAULT '',
    targets JSONB NOT NULL
);

-- Habilitar lectura pública (opcional, dependiendo de tus políticas de seguridad/RLS)
ALTER TABLE niveles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Permitir lectura pública de niveles" ON niveles FOR SELECT USING (true);

-- 3. Crear tabla de capítulos/historias
CREATE TABLE IF NOT EXISTS capitulos (
    id INT PRIMARY KEY,
    title_key TEXT NOT NULL,
    background_image TEXT NOT NULL,
    level_id INT NOT NULL,
    messages JSONB NOT NULL
);

ALTER TABLE capitulos ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Permitir lectura pública de capítulos" ON capitulos FOR SELECT USING (true);

-- 4. Sembrar (Seed) Niveles
INSERT INTO niveles (id, level_name, time_limit, is_hard, items_to_collect, coins_reward, unlocks_story, camera_notice, targets)
VALUES 
(0, 'molly_tutorial', 120.0, false, 4, 50, true, '', '[{"targetObject": "dog", "displayName": "molly_tutorial"}]'),
(1, 'game_ball', 60.0, false, 5, 60, false, '', '[{"targetObject": "sports ball", "displayName": "game_ball"}, {"targetObject": "bottle", "displayName": "water_bottle"}, {"targetObject": "cup", "displayName": "coffee_cup"}]'),
(2, 'food_bowl', 75.0, false, 6, 70, false, '', '[{"targetObject": "bowl", "displayName": "food_bowl"}, {"targetObject": "book", "displayName": "book"}, {"targetObject": "keyboard", "displayName": "keyboard"}]'),
(3, 'water_bottle', 50.0, false, 4, 80, true, '', '[{"targetObject": "bottle", "displayName": "water_bottle"}, {"targetObject": "cell phone", "displayName": "cell_phone"}, {"targetObject": "mouse", "displayName": "mouse"}]'),
(4, 'coffee_cup', 45.0, false, 5, 90, false, '', '[{"targetObject": "cup", "displayName": "coffee_cup"}, {"targetObject": "laptop", "displayName": "laptop"}, {"targetObject": "chair", "displayName": "chair"}]')
ON CONFLICT (id) DO UPDATE 
SET level_name = EXCLUDED.level_name,
    time_limit = EXCLUDED.time_limit,
    is_hard = EXCLUDED.is_hard,
    items_to_collect = EXCLUDED.items_to_collect,
    coins_reward = EXCLUDED.coins_reward,
    unlocks_story = EXCLUDED.unlocks_story,
    targets = EXCLUDED.targets;

-- Sembrar niveles restantes hasta el 20 como fallbacks
DO $$
BEGIN
    FOR i IN 5..20 LOOP
        INSERT INTO niveles (id, level_name, time_limit, is_hard, items_to_collect, coins_reward, unlocks_story, camera_notice, targets)
        VALUES (
            i, 
            'Nivel ' || i, 
            GREATEST(20.0, 60.0 - i), 
            (i % 5 = 0), 
            4 + (i % 3), 
            50 + (i * 10), 
            (i IN (10, 17, 20)), 
            '', 
            '[{"targetObject": "person", "displayName": "human"}, {"targetObject": "tv", "displayName": "tv"}, {"targetObject": "backpack", "displayName": "backpack"}]'
        )
        ON CONFLICT (id) DO NOTHING;
    END LOOP;
END $$;

-- 5. Sembrar (Seed) Capítulos de Historia
INSERT INTO capitulos (id, title_key, background_image, level_id, messages)
VALUES 
(1, 'chapter_1', 'assets/images/fondomolly.png', 1, '[
    {"type": "narrative", "text_key": "cap1_narrative_1"},
    {"type": "dialogue", "text_key": "cap1_iker_1", "avatar_path": "assets/images/iker.jpeg", "is_left": true},
    {"type": "dialogue", "text_key": "cap1_molly_1", "avatar_path": "assets/images/perroblanco.png", "is_left": false},
    {"type": "narrative", "text_key": "cap1_narrative_2"},
    {"type": "dialogue", "text_key": "cap1_iker_2", "avatar_path": "assets/images/iker.jpeg", "is_left": true},
    {"type": "dialogue", "text_key": "cap1_molly_2", "avatar_path": "assets/images/perroblanco.png", "is_left": false},
    {"type": "dialogue", "text_key": "cap1_iker_3", "avatar_path": "assets/images/perroblanco.png", "is_left": false},
    {"type": "narrative", "text_key": "cap1_narrative_3"},
    {"type": "dialogue", "text_key": "cap1_iker_4", "avatar_path": "assets/images/iker.jpeg", "is_left": true},
    {"type": "dialogue", "text_key": "cap1_molly_3", "avatar_path": "assets/images/perroblanco.png", "is_left": false},
    {"type": "narrative", "text_key": "cap1_narrative_4"},
    {"type": "dialogue", "text_key": "cap1_iker_5", "avatar_path": "assets/images/iker.jpeg", "is_left": true},
    {"type": "dialogue", "text_key": "cap1_molly_4", "avatar_path": "assets/images/perroblanco.png", "is_left": false},
    {"type": "narrative", "text_key": "cap1_narrative_5"}
]'),
(2, 'chapter_2', 'assets/images/fondomolly.png', 2, '[
    {"type": "narrative", "text_key": "cap2_narrative_1"},
    {"type": "dialogue", "text_key": "cap2_molly_1", "avatar_path": "assets/images/perroblanco.png", "is_left": true},
    {"type": "dialogue", "text_key": "cap2_iker_1", "avatar_path": "assets/images/iker.jpeg", "is_left": false},
    {"type": "narrative", "text_key": "cap2_narrative_2"},
    {"type": "dialogue", "text_key": "cap2_molly_2", "avatar_path": "assets/images/perroblanco.png", "is_left": true},
    {"type": "dialogue", "text_key": "cap2_iker_2", "avatar_path": "assets/images/iker.jpeg", "is_left": false},
    {"type": "narrative", "text_key": "cap2_narrative_3"}
]'),
(3, 'chapter_3', 'assets/images/fondokovu.png', 3, '[
    {"type": "narrative", "text_key": "cap3_narrative_1"},
    {"type": "dialogue", "text_key": "cap3_kovu_1", "avatar_path": "assets/images/kovu.jpeg", "is_left": true},
    {"type": "dialogue", "text_key": "cap3_iker_1", "avatar_path": "assets/images/iker.jpeg", "is_left": false},
    {"type": "narrative", "text_key": "cap3_narrative_2"},
    {"type": "dialogue", "text_key": "cap3_molly_1", "avatar_path": "assets/images/perroblanco.png", "is_left": true},
    {"type": "dialogue", "text_key": "cap3_kovu_2", "avatar_path": "assets/images/kovu.jpeg", "is_left": false},
    {"type": "narrative", "text_key": "cap3_narrative_3"},
    {"type": "dialogue", "text_key": "cap3_iker_2", "avatar_path": "assets/images/iker.jpeg", "is_left": true}
]'),
(4, 'chapter_4', 'assets/images/fondokovu.png', 4, '[
    {"type": "narrative", "text_key": "cap4_narrative_1"},
    {"type": "dialogue", "text_key": "cap4_iker_1", "avatar_path": "assets/images/iker.jpeg", "is_left": true},
    {"type": "dialogue", "text_key": "cap4_molly_1", "avatar_path": "assets/images/perroblanco.png", "is_left": false},
    {"type": "narrative", "text_key": "cap4_narrative_2"},
    {"type": "dialogue", "text_key": "cap4_molly_2", "avatar_path": "assets/images/perroblanco.png", "is_left": true},
    {"type": "dialogue", "text_key": "cap4_iker_2", "avatar_path": "assets/images/iker.jpeg", "is_left": false},
    {"type": "narrative", "text_key": "cap4_narrative_3"},
    {"type": "dialogue", "text_key": "cap4_molly_3", "avatar_path": "assets/images/perroblanco.png", "is_left": true}
]'),
(5, 'chapter_5', 'assets/images/fondohorus.jpg', 5, '[
    {"type": "narrative", "text_key": "cap5_narrative_1"},
    {"type": "dialogue", "text_key": "cap5_horus_1", "avatar_path": "assets/images/horus.jpeg", "is_left": true},
    {"type": "dialogue", "text_key": "cap5_iker_1", "avatar_path": "assets/images/iker.jpeg", "is_left": false},
    {"type": "narrative", "text_key": "cap5_narrative_2"},
    {"type": "dialogue", "text_key": "cap5_horus_2", "avatar_path": "assets/images/horus.jpeg", "is_left": true},
    {"type": "dialogue", "text_key": "cap5_molly_1", "avatar_path": "assets/images/perroblanco.png", "is_left": false},
    {"type": "narrative", "text_key": "cap5_narrative_3"}
]'),
(6, 'chapter_6', 'assets/images/fondohorus.jpg', 6, '[
    {"type": "narrative", "text_key": "cap6_narrative_1"},
    {"type": "dialogue", "text_key": "cap6_iker_1", "avatar_path": "assets/images/iker.jpeg", "is_left": true},
    {"type": "dialogue", "text_key": "cap6_horus_1", "avatar_path": "assets/images/horus.jpeg", "is_left": false},
    {"type": "narrative", "text_key": "cap6_narrative_2"},
    {"type": "dialogue", "text_key": "cap6_molly_1", "avatar_path": "assets/images/perroblanco.png", "is_left": true},
    {"type": "dialogue", "text_key": "cap6_horus_2", "avatar_path": "assets/images/horus.jpeg", "is_left": false},
    {"type": "narrative", "text_key": "cap6_narrative_3"}
]'),
(7, 'chapter_7', 'assets/images/fondo_resultados.png', 7, '[
    {"type": "narrative", "text_key": "cap7_narrative_1"},
    {"type": "dialogue", "text_key": "cap7_iker_1", "avatar_path": "assets/images/iker.jpeg", "is_left": true},
    {"type": "dialogue", "text_key": "cap7_molly_1", "avatar_path": "assets/images/perroblanco.png", "is_left": false},
    {"type": "narrative", "text_key": "cap7_narrative_2"},
    {"type": "dialogue", "text_key": "cap7_kovu_1", "avatar_path": "assets/images/kovu.jpeg", "is_left": true},
    {"type": "dialogue", "text_key": "cap7_horus_1", "avatar_path": "assets/images/horus.jpeg", "is_left": false},
    {"type": "narrative", "text_key": "cap7_narrative_3"}
]')
ON CONFLICT (id) DO UPDATE 
SET title_key = EXCLUDED.title_key,
    background_image = EXCLUDED.background_image,
    level_id = EXCLUDED.level_id,
    messages = EXCLUDED.messages;
