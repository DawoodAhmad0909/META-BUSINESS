# META Platform Suite
## Overview 
The META_BUS_db is a well-structured relational database designed to analyze user behavior, content performance, and engagement trends on a social media platform. It consists of four interconnected tables: users, posts, engagements, and hashtags. These tables capture core entities such as verified users, types of content (videos, reels, images), engagement actions (likes, comments, shares, saves), and hashtag usage.

## Objectives 
To analyze user engagement patterns, optimize content strategy, and maximize audience reach through data-driven social media performance metrics.
## Database Creation
``` sql
CREATE DATABASE META_BUS_db;
USE META_BUS_db;
```
## Table Creation
### Table:users
``` sql
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
```
### Table:posts
``` sql
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
```
### Table:engagements
``` sql
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
```
### Table:hashtags
``` sql
CREATE TABLE hashtags(
    post_id VARCHAR(25),
    hashtag TEXT,
    FOREIGN KEY (post_id) REFERENCES posts(post_id)
);

SELECT * FROM hashtags;
```
## Here are the queries:

#### 1. List verified users with over 10,000 followers, sorted by follower count (high to low).
``` sql
SELECT * FROM users 
WHERE 
        followers_count>10000 
    AND is_verified=TRUE
ORDER BY followers_count DESC;
```
#### 2. Find users who signed up in 2023 but have fewer than 500 followers.
``` sql
SELECT * FROM users 
WHERE 
        followers_count<500
    AND YEAR(signup_date)=2023;
```
#### 3. Calculate the average follower count by account type (Personal/Creator/Business).
``` sql
SELECT account_type,ROUND(AVG(followers_count),2) AS Average_followers FROM users
GROUP BY account_type;
```
#### 4. Show posts with more than 3 engagement actions (likes, comments, shares combined).
``` sql
SELECT p.* , COUNT(e.engagement_id) AS Total_engagements
FROM posts p 
JOIN engagements e 
ON e.post_id=p.post_id
GROUP BY p.post_id
HAVING Total_engagements>3;
```
#### 5. Identify the most used content type (Image/Video/Text/Reel) among top 10% most-engaged posts.
``` sql
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
```
#### 6. Find sponsored posts with below-average engagement rates.
``` sql
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
```
#### 7. List posts that received both comments and shares within the first hour of posting. 
``` sql
 SELECT p.*,COUNT(DISTINCT e.engagement_type) AS Total_engagement_types
 FROM posts p
 JOIN engagements e 
 ON p.post_id=e.post_id
 WHERE 
        LOWER(e.engagement_type) IN ('comment','share')
    AND e.engagement_time<=DATE_ADD(p.post_time, INTERVAL 1 HOUR)
 GROUP BY p.post_id
 HAVING Total_engagement_types=2;
```
#### 8. Calculate the average time between a post's creation and its first engagement.
``` sql
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
```
#### 9. Find users who consistently engage (like/comment) with the same creator's content.
``` sql
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
```
#### 10. Show the 5 most frequently used hashtags and their average engagement rates.
``` sql
SELECT h.hashtag, COUNT(DISTINCT h.post_id) AS post_count,ROUND(COUNT(e.engagement_id)/COUNT(DISTINCT h.post_id),2) AS Average_engagement_rate
FROM hashtags h 
JOIN engagements e 
ON h.post_id=e.post_id
GROUP BY h.hashtag
ORDER BY post_count DESC,Average_engagement_rate DESC 
LIMIT 5;
```
#### 11. Find hashtags that appear in both sponsored and organic posts.
``` sql
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
```
#### 12. Identify trending hashtags (those used in 3+ posts with engagement growth >50% week-over-week).
``` sql
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
```

## Conclusion
The analysis demonstrates the power of SQL in transforming raw social media data into valuable business intelligence. The queries accurately highlight top influencers, underperforming sponsored posts, timely user engagement, and the emergence of trending hashtags. This approach not only supports content strategy optimization but also assists in targeting and marketing decisions. The META_BUS_db structure and logic can serve as a strong foundation for more complex social media analytics, machine learning integrations, or real-time dashboards in the future.



