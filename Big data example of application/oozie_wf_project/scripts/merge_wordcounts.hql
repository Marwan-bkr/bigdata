WITH latest_history AS (
    SELECT * FROM (
        SELECT 
            word, 
            both_count, 
            ai_count, 
            human_count,
            ROW_NUMBER() OVER(PARTITION BY word ORDER BY `date` DESC) as rn
        FROM spring_gr01.login_ai_human_wordcount
    ) t WHERE rn = 1
),
stream_stats AS (
    SELECT
        LOWER(word) AS word,
        COUNT(*) AS both_count,
        SUM(CASE WHEN generated = 1.0 THEN 1 ELSE 0 END) AS ai_count,
        SUM(CASE WHEN generated = 0.0 THEN 1 ELSE 0 END) AS human_count
    FROM spring_gr01.login_AI_Human_stream_ext
    LATERAL VIEW EXPLODE(SPLIT(text, ' ')) t AS word
    WHERE word != ''
    GROUP BY LOWER(word)
),
merged_new_row AS (
    SELECT 
        COALESCE(h.word, s.word) AS word,
        (COALESCE(h.both_count, 0) + COALESCE(s.both_count, 0)) AS both_count,
        (COALESCE(h.ai_count, 0) + COALESCE(s.ai_count, 0)) AS ai_count,
        (COALESCE(h.human_count, 0) + COALESCE(s.human_count, 0)) AS human_count
    FROM latest_history h
    FULL OUTER JOIN stream_stats s ON h.word = s.word
)
-- Step 4: The INSERT statement must go HERE
INSERT INTO TABLE spring_gr01.login_ai_human_wordcount
SELECT 
    word,
    both_count,
    ai_count,
    human_count,
    (both_count / SUM(both_count) OVER()) * 100 AS percentageofboth,
    (ai_count / SUM(ai_count) OVER()) * 100 AS percentageofai,
    (human_count / SUM(human_count) OVER()) * 100 AS percentageofhuman,
    CURRENT_DATE() AS `date`
FROM merged_new_row;
