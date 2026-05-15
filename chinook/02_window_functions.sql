-- =============================================
-- SQL Drills · Chinook Database · Window Functions
-- Martin James Ng'ang'a · github.com/M20Jay
-- =============================================

SELECT invoice_id,
       customer_id,
       total,
       ROW_NUMBER() OVER (ORDER BY total DESC) AS overall_rank
FROM invoice;

-- =============================================
-- Exercise 10: ROW_NUMBER Rank Per Group
-- Rank albums by track count within each artist
-- Tables: album, track
-- =============================================
WITH albums_ranked AS (
    SELECT
        a.artist_id,
        a.album_id,
        a.title,
        COUNT(t.track_id) AS num_tracks
    FROM album a
    JOIN track t ON a.album_id = t.album_id
    GROUP BY a.artist_id, a.album_id, a.title
)
SELECT
    artist_id,
    album_id,
    title,
    num_tracks,
    ROW_NUMBER() OVER (
        PARTITION BY artist_id
        ORDER BY num_tracks DESC
    ) AS album_rank
FROM albums_ranked
ORDER BY artist_id, album_rank;