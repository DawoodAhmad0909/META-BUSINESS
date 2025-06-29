CREATE DATABASE META_BUS_db;
USE META_BUS_db;

CREATE TABLE users(
    user_id          VARCHAR(25) PRIMARY KEY,
    username         TEXT NOT NULL,
    full_name        VARCHAR(50) NOT NULL,
    signup_date      DATE NOT NULL,
    account_type     VARCHAR(50),
    followers_count  INT,
    following_count  INT,
    is_verified      BOOLEAN
);

SELECT * FROM users;

INSERT INTO users VALUES
('U1001', '@tech_guru', 'Aarav Sharma', '2023-01-15', 'Creator', 12500, 350, TRUE),
('U1002', '@foodie_delhi', 'Priya Patel', '2022-11-20', 'Personal', 4200, 890, FALSE),
('U1003', '@fitness_coach', 'Rohan Malhotra', '2023-03-10', 'Business', 8700, 120, TRUE),
('U1004', '@travel_with_me', 'Ananya Reddy', '2022-05-05', 'Creator', 21500, 540, FALSE),
('U1005', '@fashion_designs', 'Neha Kapoor', '2023-02-28', 'Business', 15300, 210, TRUE);

CREATE TABLE posts(
    post_id      VARCHAR(25) PRIMARY KEY,
    user_id      VARCHAR(25),
    post_time    DATETIME,
    content_type VARCHAR(25),
    caption      TEXT,
    location     TEXT,
    is_sponsored BOOLEAN,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

SELECT * FROM posts;

INSERT INTO posts VALUES
('P2023060101', 'U1001', '2023-06-01 09:15:30', 'Video', 'New smartphone review!', 'Mumbai', FALSE),
('P2023060201', 'U1002', '2023-06-02 12:30:45', 'Image', 'Best street food in Delhi', 'Delhi', TRUE),
('P2023060501', 'U1003', '2023-06-05 07:45:15', 'Text', '5 morning habits for weight loss', NULL, FALSE),
('P2023060801', 'U1004', '2023-06-08 18:22:10', 'Reel', 'Sunset in Goa beaches', 'Goa', FALSE),
('P2023061201', 'U1005', '2023-06-12 14:05:33', 'Image', 'New summer collection preview', 'Bangalore', TRUE),
('P2023061501', 'U1001', '2023-06-15 11:30:00', 'Video', 'Laptop unboxing', 'Mumbai', FALSE),
('P2023061801', 'U1003', '2023-06-18 08:15:22', 'Reel', '30-second workout challenge', NULL, FALSE),
('P2023062201', 'U1004', '2023-06-22 16:45:10', 'Image', 'Mountain trekking adventure', 'Himachal', FALSE),
('P2023062501', 'U1002', '2023-06-25 13:20:45', 'Video', 'Kitchen hacks compilation', 'Delhi', TRUE),
('P2023062801', 'U1005', '2023-06-28 10:10:33', 'Reel', 'Behind-the-scenes at fashion show', 'Bangalore', TRUE);

CREATE TABLE engagements(
    engagement_id   VARCHAR(25) PRIMARY KEY,
    post_id         VARCHAR(25),
    user_id         VARCHAR(25),
    engagement_type VARCHAR(25),
    engagement_time DATETIME,
    comment_text    TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
	FOREIGN KEY (post_id) REFERENCES posts(post_id)
);

SELECT * FROM engagements;

INSERT INTO engagements VALUES
-- Post 1 (Video)
('E20230601001', 'P2023060101', 'U1002', 'Like', '2023-06-01 09:20:15', NULL),
('E20230601002', 'P2023060101', 'U1003', 'Comment', '2023-06-01 09:25:30', 'Great review!'),
('E20230601003', 'P2023060101', 'U1004', 'Share', '2023-06-01 10:15:22', NULL),

-- Post 2 (Image)
('E20230602001', 'P2023060201', 'U1001', 'Like', '2023-06-02 12:35:45', NULL),
('E20230602002', 'P2023060201', 'U1005', 'Comment', '2023-06-02 13:10:20', 'Where exactly is this?'),
('E20230602003', 'P2023060201', 'U1003', 'Like', '2023-06-02 14:22:10', NULL),

-- Post 3 (Text)
('E20230605001', 'P2023060501', 'U1002', 'Save', '2023-06-05 08:00:15', NULL),
('E20230605002', 'P2023060501', 'U1004', 'Comment', '2023-06-05 08:30:45', 'Trying these tomorrow!'),

-- Post 4 (Reel)
('E20230608001', 'P2023060801', 'U1001', 'Like', '2023-06-08 18:25:10', NULL),
('E20230608002', 'P2023060801', 'U1003', 'Share', '2023-06-08 19:15:33', NULL),
('E20230608003', 'P2023060801', 'U1005', 'Like', '2023-06-08 20:05:22', NULL),

-- Post 5 (Image)
('E20230612001', 'P2023061201', 'U1002', 'Comment', '2023-06-12 14:15:45', 'Love the color palette!'),
('E20230612002', 'P2023061201', 'U1004', 'Save', '2023-06-12 15:30:10', NULL),

-- Post 6 (Video)
('E20230615001', 'P2023061501', 'U1003', 'Like', '2023-06-15 11:35:00', NULL),
('E20230615002', 'P2023061501', 'U1005', 'Share', '2023-06-15 12:40:15', NULL),

-- Post 7 (Reel)
('E20230618001', 'P2023061801', 'U1001', 'Comment', '2023-06-18 08:20:22', 'Challenge accepted!'),
('E20230618002', 'P2023061801', 'U1002', 'Like', '2023-06-18 09:15:33', NULL),

-- Post 8 (Image)
('E20230622001', 'P2023062201', 'U1003', 'Save', '2023-06-22 16:50:10', NULL),
('E20230622002', 'P2023062201', 'U1005', 'Comment', '2023-06-22 17:30:45', 'Which trail is this?'),

-- Post 9 (Video)
('E20230625001', 'P2023062501', 'U1001', 'Like', '2023-06-25 13:25:45', NULL),
('E20230625002', 'P2023062501', 'U1004', 'Share', '2023-06-25 14:15:22', NULL),

-- Post 10 (Reel)
('E20230628001', 'P2023062801', 'U1002', 'Comment', '2023-06-28 10:15:33', 'Backstage looks amazing!'),
('E20230628002', 'P2023062801', 'U1003', 'Like', '2023-06-28 11:05:10', NULL),
('E20230628003', 'P2023062801', 'U1004', 'Save', '2023-06-28 12:30:45', NULL);

CREATE TABLE hashtags(
    post_id VARCHAR(25),
    hashtag TEXT,
    FOREIGN KEY (post_id) REFERENCES posts(post_id)
);

SELECT * FROM hashtags;

INSERT INTO hashtags VALUES
('P2023060101', '#TechReview'),
('P2023060101', '#Smartphone'),
('P2023060201', '#DelhiFood'),
('P2023060201', '#StreetFood'),
('P2023060501', '#FitnessTips'),
('P2023060801', '#GoaVibes'),
('P2023060801', '#TravelIndia'),
('P2023061201', '#FashionPreview'),
('P2023061501', '#Unboxing'),
('P2023061801', '#WorkoutChallenge'),
('P2023062201', '#Himalayas'),
('P2023062501', '#KitchenHacks'),
('P2023062801', '#FashionShow');

-- Here are the queries:

-- 1. List verified users with over 10,000 followers, sorted by follower count (high to low).
SELECT * FROM users 
WHERE 
	followers_count>10000 
    AND is_verified=TRUE
ORDER BY followers_count DESC;

-- 2. Find users who signed up in 2023 but have fewer than 500 followers.
SELECT * FROM users 
WHERE 
	followers_count<500
    AND YEAR(signup_date)=2023;
    
-- 3. Calculate the average follower count by account type (Personal/Creator/Business).
SELECT account_type,ROUND(AVG(followers_count),2) AS Average_followers FROM users
GROUP BY account_type;

-- 4. Show posts with more than 3 engagement actions (likes, comments, shares combined).
SELECT p.* , COUNT(e.engagement_id) AS Total_engagements
FROM posts p 
JOIN engagements e 
ON e.post_id=p.post_id
GROUP BY p.post_id
HAVING Total_engagements>3;

-- 5. Identify the most used content type (Image/Video/Text/Reel) among top 10% most-engaged posts.
WITH posts_stats AS (
	SELECT p.post_id,p.content_type,COUNT(e.engagement_id) AS Total_engagements
    FROM posts p
    LEFT JOIN engagements e 	
    ON e.post_id=p.post_id
    GROUP BY p.post_id,p.content_type
    ),
Rank_posts AS (
	SELECT *, PERCENT_RANK() OVER ( ORDER BY Total_engagements DESC ) AS percentile 
    FROM posts_stats
    )
SELECT content_type,COUNT(*) AS Top_content_type_count,ROUND(AVG(Total_engagements),2) AS Average_engagements
FROM Rank_posts
WHERE percentile<0.1
GROUP BY content_type
ORDER BY Top_content_type_count DESC
LIMIT 1;

-- 6. Find sponsored posts with below-average engagement rates.
WITH post_engagements AS (
	SELECT p.post_id,p.is_sponsored,COUNT(e.engagement_id) AS engagement_rate
	FROM posts p 
	JOIN engagements e 
	ON p.post_id=e.post_id
	GROUP BY p.post_id,p.is_sponsored
    ),
Average_engagements AS (
	SELECT ROUND(AVG(engagement_rate),2) AS Average_engagement_rate
    FROM post_engagements
    )
SELECT pe.*,ae.*
FROM post_engagements pe 
JOIN Average_engagements ae
WHERE 
	pe.is_sponsored=TRUE 
	AND engagement_rate<Average_engagement_rate;
    
-- 7. List posts that received both comments and shares within the first hour of posting. 
 SELECT p.*,COUNT(DISTINCT e.engagement_type) AS Total_engagement_types
 FROM posts p
 JOIN engagements e 
 ON p.post_id=e.post_id
 WHERE 
	LOWER(e.engagement_type) IN ('comment','share')
    AND e.engagement_time<=DATE_ADD(p.post_time, INTERVAL 1 HOUR)
 GROUP BY p.post_id
 HAVING Total_engagement_types=2;
 
-- 8. Calculate the average time between a post's creation and its first engagement.
WITH post_stats AS (
	SELECT p.post_id,p.post_time,MIN(e.engagement_time) AS First_engagement_time
	FROM posts p 
	JOIN engagements e 
	ON p.post_id=e.post_id
	GROUP BY p.post_id
    ),
engagement_time AS ( 
	SELECT TIMESTAMPDIFF(MINUTE,post_time,First_engagement_time) AS time_difference
	FROM post_stats
    )
SELECT ROUND(AVG(time_difference),2) AS Average_time 
FROM engagement_time;

-- 9. Find users who consistently engage (like/comment) with the same creator's content.
WITH valid_engagements AS (
	SELECT 
		e.engagement_id,
        e.user_id AS Engager,
        p.user_id AS Creator,
        e.engagement_type,
        p.post_id
	FROM posts p 
    JOIN engagements e 
    ON p.post_id=e.post_id
    WHERE 
		LOWER (e.engagement_type) IN ('like','comment')
		AND e.user_id!=p.user_id
	)
SELECT Engager,Creator,COUNT(DISTINCT post_id) AS engaged_posts
FROM valid_engagements
GROUP BY Engager,Creator
HAVING engaged_posts >=2
ORDER BY engaged_posts DESC ;

-- 10. Show the 5 most frequently used hashtags and their average engagement rates.
SELECT h.hashtag, COUNT(DISTINCT h.post_id) AS post_count,ROUND(COUNT(e.engagement_id)/COUNT(DISTINCT h.post_id),2) AS Average_engagement_rate
FROM hashtags h 
JOIN engagements e 
ON h.post_id=e.post_id
GROUP BY h.hashtag
ORDER BY post_count DESC,Average_engagement_rate DESC 
LIMIT 5;

-- 11. Find hashtags that appear in both sponsored and organic posts.
WITH hashtag_stats AS (
	SELECT h.hashtag,p.is_sponsored
    FROM hashtags h 
    JOIN posts p 
    ON p.post_id=h.post_id
    ),
Hashtag_category AS (
	SELECT 
		hashtag,
        SUM(CASE WHEN is_sponsored=TRUE THEN 1 ELSE 0 END ) AS Sponsored_post_count,
		SUM(CASE WHEN is_sponsored=FALSE THEN 1 ELSE 0 END ) AS Organic_post_count
	FROM hashtag_stats
    GROUP BY hashtag
    )
SELECT hashtag
FROM Hashtag_category
WHERE Sponsored_post_count>0 AND Organic_post_count>0;
    
-- 12. Identify trending hashtags (those used in 3+ posts with engagement growth >50% week-over-week).
WITH weekly_hashtag_engagement AS (
    SELECT 
        h.hashtag,
        YEARWEEK(p.post_time) AS week,
        COUNT(DISTINCT h.post_id) AS post_count,
        COUNT(e.engagement_id) AS engagement_count,
        LAG(COUNT(e.engagement_id), 1) OVER (PARTITION BY h.hashtag ORDER BY YEARWEEK(p.post_time)) AS prev_week_engagement
    FROM 
        hashtags h
    JOIN 
        posts p ON h.post_id = p.post_id
    LEFT JOIN 
        engagements e ON h.post_id = e.post_id
    GROUP BY 
        h.hashtag, YEARWEEK(p.post_time)
),
hashtag_growth AS (
    SELECT 
        hashtag,
        week,
        post_count,
        engagement_count,
        prev_week_engagement,
        CASE 
            WHEN prev_week_engagement IS NULL OR prev_week_engagement = 0 THEN NULL
            ELSE ROUND((engagement_count - prev_week_engagement) / prev_week_engagement * 100, 1)
        END AS growth_percentage
    FROM 
        weekly_hashtag_engagement
)
SELECT 
    hashtag,
    MAX(post_count) AS total_posts,
    MAX(engagement_count) AS current_week_engagements,
    MAX(prev_week_engagement) AS previous_week_engagements,
    MAX(growth_percentage) AS growth_percentage
FROM 
    hashtag_growth
WHERE 
    post_count >= 3
    AND growth_percentage > 50
GROUP BY 
    hashtag
ORDER BY 
    growth_percentage DESC;