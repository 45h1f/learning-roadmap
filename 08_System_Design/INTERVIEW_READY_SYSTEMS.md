# 🎯 System Design Interview - Ready-to-Use Designs

## 📋 Overview

This guide provides **complete, interview-ready system designs** for the most commonly asked questions. Each design includes:
- ✅ Requirements (functional & non-functional)
- ✅ Capacity estimation
- ✅ High-level architecture
- ✅ Database schema
- ✅ API design
- ✅ Scalability considerations
- ✅ Trade-offs and bottlenecks

---

## 🎯 How to Use This in Interviews

### **The Framework (Use Every Time):**

1. **Clarify Requirements (5 mins)**
   - Ask about scale (DAU, requests/sec)
   - Functional requirements
   - Non-functional requirements (latency, availability)

2. **Back-of-the-Envelope Estimation (5 mins)**
   - Storage calculations
   - Bandwidth requirements
   - Memory for cache

3. **High-Level Design (10 mins)**
   - Draw main components
   - Show data flow
   - Identify bottlenecks

4. **Deep Dive (15 mins)**
   - Database schema
   - API design
   - Scalability solutions
   - Trade-offs

5. **Bottlenecks & Improvements (5 mins)**
   - Identify single points of failure
   - Discuss monitoring
   - Future optimizations

---

## 1️⃣ Design URL Shortener (TinyURL)

### **Requirements Clarification**

**Functional:**
- Create short URL from long URL
- Redirect short URL to original
- Custom aliases (optional)
- Expiration (optional)
- Analytics (clicks, locations)

**Non-Functional:**
- Low latency (<100ms)
- High availability (99.9%)
- Scale: 100M URLs created/month
- Read-heavy (100:1 read/write ratio)

### **Capacity Estimation**

```
Write (URL Creation):
- 100M new URLs/month = ~40 writes/sec
- Peak: 400 writes/sec

Read (Redirects):
- 100:1 ratio = 10B redirects/month
- Average: 4000 reads/sec
- Peak: 40,000 reads/sec

Storage:
- 100M URLs/month × 12 months × 5 years = 6B URLs
- Each URL: 500 bytes (URL + metadata)
- Total: 6B × 500 bytes = 3TB

Bandwidth:
- Write: 40 req/s × 500 bytes = 20 KB/s
- Read: 4000 req/s × 500 bytes = 2 MB/s

Cache (80/20 rule):
- 20% of URLs = 80% of traffic
- Cache size: 10B × 500 bytes × 0.2 = 1TB/day
- Realistic cache: 100GB (most recent/popular)
```

### **High-Level Architecture**

```
┌─────────┐
│ Client  │
└────┬────┘
     │
     ▼
┌─────────────────┐
│  Load Balancer  │
└────┬────────────┘
     │
     ▼
┌──────────────────────┐
│   API Servers        │
│   (Stateless)        │
└────┬─────────────────┘
     │
     ├─────────┬──────────┬─────────┐
     ▼         ▼          ▼         ▼
┌─────────┐ ┌──────┐ ┌─────────┐ ┌──────────┐
│ Redis   │ │ DB   │ │ ID Gen  │ │ Analytics│
│ Cache   │ │(Prim)│ │ Service │ │   DB     │
└─────────┘ └──┬───┘ └─────────┘ └──────────┘
               │
               ▼
          ┌────────┐
          │   DB   │
          │(Replica)│
          └────────┘
```

### **API Design**

```typescript
// Create Short URL
POST /api/v1/urls
Request:
{
  "long_url": "https://example.com/very/long/url",
  "custom_alias": "mylink", // optional
  "expire_at": "2025-12-31T23:59:59Z" // optional
}

Response:
{
  "short_url": "https://tiny.url/abc123",
  "long_url": "https://example.com/very/long/url",
  "created_at": "2025-01-15T10:30:00Z",
  "expire_at": "2025-12-31T23:59:59Z"
}

// Redirect
GET /{short_code}
Response: 302 Redirect to long_url

// Analytics
GET /api/v1/urls/{short_code}/stats
Response:
{
  "short_code": "abc123",
  "clicks": 12543,
  "countries": {"US": 5000, "UK": 3000},
  "referrers": {"facebook.com": 6000, "twitter.com": 4000}
}
```

### **Database Schema**

```sql
-- PostgreSQL Schema
CREATE TABLE urls (
    id BIGSERIAL PRIMARY KEY,
    short_code VARCHAR(10) UNIQUE NOT NULL,
    long_url TEXT NOT NULL,
    user_id BIGINT,
    created_at TIMESTAMP DEFAULT NOW(),
    expire_at TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

CREATE INDEX idx_short_code ON urls(short_code);
CREATE INDEX idx_user_id ON urls(user_id);
CREATE INDEX idx_created_at ON urls(created_at);

-- Analytics (separate DB or time-series DB)
CREATE TABLE url_clicks (
    id BIGSERIAL PRIMARY KEY,
    short_code VARCHAR(10) NOT NULL,
    clicked_at TIMESTAMP DEFAULT NOW(),
    ip_address INET,
    country VARCHAR(2),
    referrer TEXT,
    user_agent TEXT
);

CREATE INDEX idx_short_code_time ON url_clicks(short_code, clicked_at);
```

### **Short Code Generation Strategies**

**Option 1: Base62 Encoding**
```python
def encode_base62(num):
    chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    base = len(chars)
    encoded = ""
    while num > 0:
        encoded = chars[num % base] + encoded
        num = num // base
    return encoded.zfill(7)  # 7 chars = 62^7 = 3.5 trillion URLs
```

**Option 2: Random String + Check**
```python
import random
import string

def generate_short_code():
    chars = string.ascii_letters + string.digits
    return ''.join(random.choices(chars, k=7))
```

**Option 3: Distributed ID Generator (Snowflake)**
- 64-bit IDs
- Time-based
- Machine ID
- Sequence number

### **Scalability Solutions**

1. **Cache Layer (Redis)**
   ```
   Key: short_code
   Value: long_url
   TTL: 24 hours (LRU eviction)
   ```

2. **Database Sharding**
   - Shard key: hash(short_code)
   - 10 shards = 300M URLs per shard

3. **Analytics Optimization**
   - Write to message queue (Kafka)
   - Batch insert every 5 seconds
   - Use time-series DB (InfluxDB, TimescaleDB)

4. **Rate Limiting**
   - Per IP: 100 requests/minute
   - Per user: 1000 requests/hour

### **Trade-offs**

| Aspect | Option 1 | Option 2 |
|--------|----------|----------|
| ID Generation | Auto-increment (simple) | Distributed (complex but scalable) |
| Storage | SQL (ACID) | NoSQL (faster but eventual consistency) |
| Analytics | Real-time (expensive) | Batch (delayed but cheaper) |

---

## 2️⃣ Design Instagram / Image Sharing Platform

### **Requirements**

**Functional:**
- Upload photos/videos
- Follow users
- Feed (timeline)
- Like, comment
- Search users

**Non-Functional:**
- 500M DAU
- 100M photos/day
- Low latency feed (<200ms)
- High availability (99.99%)

### **Capacity Estimation**

```
Storage:
- 100M photos/day
- Average photo: 2MB
- Daily: 100M × 2MB = 200TB/day
- 5 years: 200TB × 365 × 5 = 365PB

Bandwidth:
- Upload: 100M photos/day = 1157 photos/sec
- Upload BW: 1157 × 2MB = 2.3 GB/s
- Read:Write ratio = 10:1
- Download BW: 23 GB/s

Database:
- 500M users
- Each user: 1KB metadata = 500GB
- Photos metadata: 100M/day × 365 × 5 × 1KB = 180GB
```

### **High-Level Architecture**

```
┌──────────┐
│  Client  │
└─────┬────┘
      │
      ▼
┌────────────────┐
│   CDN (Images) │
└────────────────┘
      │
      ▼
┌──────────────────┐
│  Load Balancer   │
└─────┬────────────┘
      │
      ├────────────┬────────────┬──────────┐
      ▼            ▼            ▼          ▼
┌──────────┐ ┌──────────┐ ┌─────────┐ ┌────────┐
│  API     │ │  Upload  │ │  Feed   │ │ Search │
│ Servers  │ │ Service  │ │ Service │ │ Service│
└────┬─────┘ └────┬─────┘ └────┬────┘ └───┬────┘
     │            │            │           │
     ▼            ▼            ▼           ▼
┌─────────────────────────────────────────────┐
│              Cache Layer (Redis)            │
└──────────────────┬──────────────────────────┘
                   │
     ┌─────────────┼─────────────┬────────────┐
     ▼             ▼             ▼            ▼
┌─────────┐  ┌──────────┐  ┌─────────┐  ┌─────────┐
│  User   │  │  Photo   │  │  Graph  │  │ Object  │
│   DB    │  │ Metadata │  │   DB    │  │ Storage │
│ (Shard) │  │   (Shard)│  │(Follower)│ │  (S3)   │
└─────────┘  └──────────┘  └─────────┘  └─────────┘
                                              │
                                              ▼
                                        ┌──────────┐
                                        │   CDN    │
                                        └──────────┘
```

### **Database Schema**

```sql
-- Users
CREATE TABLE users (
    user_id BIGINT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    profile_pic_url TEXT,
    bio TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Photos
CREATE TABLE photos (
    photo_id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    image_url TEXT NOT NULL,
    caption TEXT,
    location VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_user_photos ON photos(user_id, created_at DESC);

-- Follows (Graph DB or SQL)
CREATE TABLE follows (
    follower_id BIGINT NOT NULL,
    followee_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (follower_id, followee_id)
);

CREATE INDEX idx_follower ON follows(follower_id);
CREATE INDEX idx_followee ON follows(followee_id);

-- Likes
CREATE TABLE likes (
    photo_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (photo_id, user_id)
);

CREATE INDEX idx_photo_likes ON likes(photo_id);

-- Comments
CREATE TABLE comments (
    comment_id BIGINT PRIMARY KEY,
    photo_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_photo_comments ON comments(photo_id, created_at DESC);
```

### **Feed Generation**

**Option 1: Pull Model (On-demand)**
```
1. User opens app
2. Fetch list of followees
3. Fetch recent photos from each followee
4. Merge and sort by timestamp
5. Return top 100

Pros: No pre-computation, less storage
Cons: Slow for users following many people
```

**Option 2: Push Model (Fanout)**
```
1. User posts photo
2. Find all followers
3. Push photo_id to each follower's feed cache
4. User opens app → read from pre-computed feed

Pros: Fast feed generation
Cons: Expensive for users with millions of followers
```

**Option 3: Hybrid (Best)**
```
1. Regular users (<1M followers): Push model
2. Celebrities (>1M followers): Pull model
3. Cache aggressively
```

### **API Design**

```typescript
// Upload Photo
POST /api/v1/photos
Content-Type: multipart/form-data
Request: { image: File, caption: string, location: string }
Response: { photo_id: string, url: string }

// Get Feed
GET /api/v1/feed?cursor={timestamp}&limit=20
Response: {
  photos: [
    {
      photo_id: string,
      user: { user_id, username, profile_pic },
      image_url: string,
      caption: string,
      likes_count: number,
      comments_count: number,
      created_at: timestamp
    }
  ],
  next_cursor: timestamp
}

// Like Photo
POST /api/v1/photos/{photo_id}/like

// Follow User
POST /api/v1/users/{user_id}/follow
```

### **Scalability Solutions**

1. **Image Storage**
   - Store in S3 / Google Cloud Storage
   - Generate multiple sizes (thumbnail, medium, full)
   - Serve via CDN (CloudFront)

2. **Database Sharding**
   - User data: Shard by user_id
   - Photo data: Shard by photo_id
   - Graph data: Use graph DB (Neo4j) or cache in Redis

3. **Caching Strategy**
   ```
   Feed Cache: Redis (per user)
   Key: feed:{user_id}
   Value: List of photo_ids
   TTL: 1 hour

   Photo Metadata: Redis
   Key: photo:{photo_id}
   Value: JSON of photo data
   TTL: 24 hours
   ```

4. **Async Processing**
   - Image upload → queue (Kafka)
   - Generate thumbnails (background workers)
   - Update feed (fanout service)

---

## 3️⃣ Design Twitter / Social Media Feed

### **Requirements**

**Functional:**
- Post tweets (280 chars)
- Follow users
- Timeline (feed)
- Like, retweet, reply
- Trending topics

**Non-Functional:**
- 300M DAU
- 500M tweets/day
- Timeline <200ms
- High availability

### **Capacity Estimation**

```
Traffic:
- 500M tweets/day = 5787 tweets/sec
- Peak: 20,000 tweets/sec
- Read:Write = 100:1
- Timeline requests: 578,700 reads/sec

Storage:
- Tweet: 280 chars + metadata = 1KB
- 500M/day × 365 × 5 years = 912B tweets
- Storage: 912B × 1KB ≈ 1PB

Cache:
- Hot tweets (last 24 hours): 500M × 1KB = 500GB
- User timelines: 300M users × 100 tweets × 1KB = 30TB
- Realistic: 100GB cache (most active users)
```

### **High-Level Architecture**

```
┌─────────┐
│  Client │
└────┬────┘
     │
     ▼
┌──────────────┐
│   Load       │
│   Balancer   │
└──────┬───────┘
       │
       ├────────────────┬────────────────┐
       ▼                ▼                ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│  API Servers │ │Tweet Ingestion│ │ Timeline     │
│  (Stateless) │ │   Service     │ │   Service    │
└──────┬───────┘ └───────┬───────┘ └──────┬───────┘
       │                 │                 │
       ▼                 ▼                 ▼
┌───────────────────────────────────────────────┐
│           Message Queue (Kafka)               │
└───────────────────┬───────────────────────────┘
                    │
       ┌────────────┼────────────┬────────────┐
       ▼            ▼            ▼            ▼
┌──────────┐  ┌──────────┐ ┌─────────┐ ┌──────────┐
│  Tweet   │  │Timeline  │ │  Graph  │ │  Search  │
│   DB     │  │  Cache   │ │   DB    │ │(Elastic) │
│ (Shard)  │  │ (Redis)  │ │(Follower)│ └──────────┘
└──────────┘  └──────────┘ └─────────┘
```

### **Database Schema**

```sql
-- Tweets
CREATE TABLE tweets (
    tweet_id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    likes_count INT DEFAULT 0,
    retweets_count INT DEFAULT 0,
    replies_count INT DEFAULT 0
);

CREATE INDEX idx_user_tweets ON tweets(user_id, created_at DESC);
CREATE INDEX idx_created_at ON tweets(created_at DESC);

-- User Timeline (Pre-computed)
CREATE TABLE user_timeline (
    user_id BIGINT NOT NULL,
    tweet_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    PRIMARY KEY (user_id, created_at, tweet_id)
);

-- Follows
CREATE TABLE follows (
    follower_id BIGINT NOT NULL,
    followee_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (follower_id, followee_id)
);
```

### **Timeline Generation (Fanout Service)**

**Fanout on Write (Push):**
```
1. User posts tweet
2. Write to tweets table
3. Fanout service triggered
4. Get all followers (from graph DB/cache)
5. For each follower:
   - Write tweet_id to their timeline cache (Redis)
   - Keep last 1000 tweets per user
6. Return success to user
```

**Redis Timeline Structure:**
```redis
Key: timeline:{user_id}
Type: Sorted Set (ZSET)
Score: timestamp
Value: tweet_id

ZADD timeline:12345 1705329600 987654321
ZRANGE timeline:12345 0 99 WITHSCORES
```

**Handling Celebrities:**
```
If user has >1M followers:
- Don't fanout on write
- Use pull model (fetch on-demand)
- Cache heavily
```

### **API Design**

```typescript
// Post Tweet
POST /api/v1/tweets
Request: { content: string, media_ids?: string[] }
Response: { tweet_id: string, created_at: timestamp }

// Get Timeline
GET /api/v1/timeline?cursor={tweet_id}&limit=20
Response: {
  tweets: [
    {
      tweet_id: string,
      user: { user_id, username, profile_pic },
      content: string,
      likes_count: number,
      retweets_count: number,
      created_at: timestamp
    }
  ],
  next_cursor: string
}

// Like Tweet
POST /api/v1/tweets/{tweet_id}/like

// Retweet
POST /api/v1/tweets/{tweet_id}/retweet
```

### **Trending Topics**

```
Approach:
1. Extract hashtags from tweets (regex)
2. Use stream processing (Kafka Streams / Spark Streaming)
3. Count hashtag frequency in sliding window (1 hour)
4. Store in Redis Sorted Set
5. Query top 10 every 5 minutes

Redis Structure:
ZINCRBY trending:global 1 "#AI"
ZREVRANGE trending:global 0 9 WITHSCORES
```

---

## 4️⃣ Design YouTube / Video Streaming Platform

### **Requirements**

**Functional:**
- Upload videos
- Stream videos
- Search videos
- Comments, likes
- Recommendations

**Non-Functional:**
- 2B DAU
- 500 hours of video uploaded/minute
- Low latency streaming (<100ms startup)
- Global availability

### **Capacity Estimation**

```
Upload:
- 500 hours/min = 30,000 hours/hour = 720,000 hours/day
- Average video: 50MB/min
- Daily upload: 720,000 × 50MB = 36 PB/day

Storage:
- 1 year: 36PB × 365 = 13 EB
- Multiple formats: 13EB × 5 = 65 EB

Bandwidth:
- 2B DAU, 30 min watch time/user
- Total watch time: 2B × 30min = 1B hours/day
- Bandwidth: 1B × 50MB = 50 PB/day
- Per second: 50PB / 86400 = 578 TB/s
```

### **High-Level Architecture**

```
┌──────────┐
│  Client  │
└────┬─────┘
     │
     ▼
┌─────────────────┐
│  CDN (Videos)   │ (Cloudflare, Akamai)
└────┬────────────┘
     │
     ▼
┌──────────────────┐
│  Load Balancer   │
└────┬─────────────┘
     │
     ├──────────┬───────────┬────────────┐
     ▼          ▼           ▼            ▼
┌─────────┐ ┌────────┐ ┌─────────┐ ┌──────────┐
│   API   │ │ Upload │ │ Stream  │ │  Search  │
│ Service │ │Service │ │ Service │ │  Service │
└────┬────┘ └───┬────┘ └────┬────┘ └─────┬────┘
     │          │           │            │
     ▼          ▼           ▼            ▼
┌─────────────────────────────────────────────┐
│         Message Queue (Kafka)               │
└──────────────┬──────────────────────────────┘
               │
     ┌─────────┼──────────┬──────────┐
     ▼         ▼          ▼          ▼
┌─────────┐ ┌──────┐ ┌─────────┐ ┌──────────┐
│ Metadata│ │Object│ │Encoding │ │  Search  │
│   DB    │ │Store │ │ Service │ │(Elastic) │
└─────────┘ │ (S3) │ │(Workers)│ └──────────┘
            └──────┘ └─────────┘
```

### **Video Processing Pipeline**

```
Upload Flow:
1. Client → Upload Service (multipart upload)
2. Store raw video in S3
3. Send message to Kafka (video_uploaded event)
4. Encoding Workers pick up job
5. Transcode to multiple formats:
   - 4K (2160p)
   - 1080p (Full HD)
   - 720p (HD)
   - 480p (SD)
   - 360p (Mobile)
6. Generate thumbnails (multiple timestamps)
7. Store encoded videos in S3
8. Update metadata DB
9. Push to CDN
10. Notify user (WebSocket / Push notification)
```

### **Streaming Strategies**

**Adaptive Bitrate Streaming (HLS / DASH):**
```
Video broken into chunks (2-10 seconds):
- 4K: 20 Mbps
- 1080p: 8 Mbps
- 720p: 4 Mbps
- 480p: 1.5 Mbps
- 360p: 0.7 Mbps

Client downloads manifest file (m3u8):
#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=8000000,RESOLUTION=1920x1080
1080p.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=4000000,RESOLUTION=1280x720
720p.m3u8

Client selects quality based on network speed
```

### **Database Schema**

```sql
-- Videos
CREATE TABLE videos (
    video_id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    duration INT, -- seconds
    views_count BIGINT DEFAULT 0,
    likes_count INT DEFAULT 0,
    status VARCHAR(20), -- processing, ready, failed
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_user_videos ON videos(user_id, created_at DESC);
CREATE INDEX idx_status ON videos(status);

-- Video Files
CREATE TABLE video_files (
    file_id BIGINT PRIMARY KEY,
    video_id BIGINT NOT NULL,
    quality VARCHAR(10), -- 4K, 1080p, 720p, etc.
    format VARCHAR(10), -- mp4, webm
    url TEXT NOT NULL,
    size_bytes BIGINT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_video_files ON video_files(video_id);

-- Comments
CREATE TABLE comments (
    comment_id BIGINT PRIMARY KEY,
    video_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    text TEXT NOT NULL,
    likes_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_video_comments ON comments(video_id, created_at DESC);
```

### **Recommendation System**

```
Approach 1: Collaborative Filtering
- Users who watched A also watched B
- Item-based similarity

Approach 2: Content-Based
- Video metadata (title, tags, description)
- User watch history

Approach 3: Hybrid (Best)
- Combine both approaches
- Use ML model (TensorFlow)
- Features:
  - Watch time
  - Likes/dislikes
  - Comments
  - Video metadata
  - User demographics
  - Time of day

Implementation:
- Batch processing (Spark) - compute nightly
- Store recommendations in Redis
- Real-time adjustments based on current session
```

### **Scalability Solutions**

1. **CDN Strategy**
   - Push popular videos to CDN edge servers
   - Origin server only for long-tail content
   - Regional CDNs (closer to users)

2. **Database Sharding**
   - Shard by video_id (hash-based)
   - Separate DB for analytics (views, likes)

3. **Caching**
   ```
   Video Metadata: Redis
   Key: video:{video_id}
   TTL: 24 hours

   Trending Videos: Redis Sorted Set
   Key: trending:{category}
   Score: view_count + (likes × 10) + (comments × 5)
   ```

4. **Async Processing**
   - Video encoding (Kafka + Workers)
   - View count updates (batch every 10 seconds)
   - Comment indexing (Elasticsearch)

---

## 5️⃣ Design Uber / Ride-Sharing Service

### **Requirements**

**Functional:**
- Riders request rides
- Drivers accept rides
- Real-time location tracking
- ETA calculation
- Fare calculation
- Payment processing
- Ratings

**Non-Functional:**
- Low latency (<1 second for matching)
- High availability (99.99%)
- Global scale (100M rides/day)
- Real-time updates (<1 second)

### **Capacity Estimation**

```
Traffic:
- 100M rides/day = 1157 rides/sec
- Peak: 5000 rides/sec
- Active drivers: 1M
- Active riders: 10M

Location Updates:
- 1M drivers × 1 update/4 sec = 250,000 updates/sec
- Each update: 100 bytes
- Bandwidth: 250K × 100B = 25 MB/s

Database:
- Ride data: 100M rides/day × 365 × 5 years = 180B rides
- Each ride: 1KB
- Storage: 180TB

Map Data:
- Road network, traffic data
- Pre-computed routes
- Size: ~100TB (cached)
```

### **High-Level Architecture**

```
┌─────────────────────────────────────┐
│   Rider App       Driver App        │
└───────┬─────────────────┬───────────┘
        │                 │
        ▼                 ▼
┌────────────────────────────────────┐
│        Load Balancer               │
└────────┬───────────────┬───────────┘
         │               │
         ▼               ▼
┌─────────────┐   ┌──────────────┐
│  API Gateway│   │  WebSocket   │
└──────┬──────┘   │  Server      │
       │          └──────┬───────┘
       │                 │
       ├─────────┬───────┼─────────┬────────┐
       ▼         ▼       ▼         ▼        ▼
┌──────────┐ ┌───────┐ ┌──────┐ ┌──────┐ ┌──────┐
│  Matching│ │Location│ │ ETA  │ │Fare  │ │Payment│
│  Service │ │Service │ │Service│ │Calc  │ │Service│
└────┬─────┘ └───┬───┘ └──┬───┘ └──┬───┘ └──┬───┘
     │           │        │        │        │
     ▼           ▼        ▼        ▼        ▼
┌──────────────────────────────────────────────┐
│           Cache Layer (Redis)                │
└──────────────┬───────────────────────────────┘
               │
     ┌─────────┼─────────┬──────────┐
     ▼         ▼         ▼          ▼
┌─────────┐ ┌──────┐ ┌───────┐ ┌────────┐
│  Users  │ │Rides │ │ Geo   │ │ Map    │
│   DB    │ │  DB  │ │Spatial│ │ Service│
└─────────┘ └──────┘ │  DB   │ │(Google)│
                     └───────┘ └────────┘
```

### **Driver Matching Algorithm**

```python
def find_nearest_drivers(rider_location, radius_km=5):
    """
    Use geospatial indexing (Redis GEO or PostGIS)
    """
    # Redis GEO command
    nearby_drivers = redis.georadius(
        "drivers:online",
        rider_location.lon,
        rider_location.lat,
        radius_km,
        unit='km',
        withdist=True,
        count=10,
        sort='ASC'
    )
    
    # Filter by driver status, ratings, car type
    available_drivers = []
    for driver_id, distance in nearby_drivers:
        driver = get_driver_details(driver_id)
        if driver.status == 'available' and driver.rating >= 4.0:
            available_drivers.append({
                'driver_id': driver_id,
                'distance': distance,
                'rating': driver.rating,
                'eta': calculate_eta(driver.location, rider_location)
            })
    
    # Sort by distance + rating + ETA
    available_drivers.sort(key=lambda x: x['distance'] * 0.5 + (5 - x['rating']) * 0.3 + x['eta'] * 0.2)
    
    return available_drivers[:5]  # Send to top 5 drivers
```

### **Location Tracking**

**Real-Time Location Updates:**
```
Driver App:
1. Send location every 4 seconds
2. Use WebSocket for low latency

Server:
1. Receive location update
2. Update Redis GEO:
   GEOADD drivers:online {lon} {lat} {driver_id}
3. If driver on trip:
   - Push update to rider (WebSocket)
   - Recalculate ETA
   - Update trip path

Rider App:
1. WebSocket connection for live updates
2. Display driver location on map
3. Show ETA
```

**Redis GEO Structure:**
```redis
# Add driver location
GEOADD drivers:online -122.4194 37.7749 driver_12345

# Find nearby drivers (5km radius)
GEORADIUS drivers:online -122.4194 37.7749 5 km WITHDIST ASC

# Get driver location
GEOPOS drivers:online driver_12345

# Remove offline driver
ZREM drivers:online driver_12345
```

### **Database Schema**

```sql
-- Users
CREATE TABLE users (
    user_id BIGINT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE,
    user_type VARCHAR(10), -- rider, driver
    rating DECIMAL(3,2),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Drivers
CREATE TABLE drivers (
    driver_id BIGINT PRIMARY KEY REFERENCES users(user_id),
    license_number VARCHAR(50) NOT NULL,
    vehicle_id BIGINT,
    status VARCHAR(20), -- online, offline, on_trip
    current_lat DECIMAL(10,8),
    current_lon DECIMAL(11,8),
    last_location_update TIMESTAMP
);

CREATE INDEX idx_driver_status ON drivers(status);

-- Rides
CREATE TABLE rides (
    ride_id BIGINT PRIMARY KEY,
    rider_id BIGINT NOT NULL,
    driver_id BIGINT,
    pickup_lat DECIMAL(10,8) NOT NULL,
    pickup_lon DECIMAL(11,8) NOT NULL,
    dropoff_lat DECIMAL(10,8),
    dropoff_lon DECIMAL(11,8),
    status VARCHAR(20), -- requested, accepted, picked_up, completed, cancelled
    fare DECIMAL(10,2),
    distance_km DECIMAL(6,2),
    duration_min INT,
    requested_at TIMESTAMP DEFAULT NOW(),
    started_at TIMESTAMP,
    completed_at TIMESTAMP
);

CREATE INDEX idx_rider_rides ON rides(rider_id, requested_at DESC);
CREATE INDEX idx_driver_rides ON rides(driver_id, requested_at DESC);
CREATE INDEX idx_status ON rides(status);

-- Locations (Trip path tracking)
CREATE TABLE ride_locations (
    id BIGINT PRIMARY KEY,
    ride_id BIGINT NOT NULL,
    lat DECIMAL(10,8) NOT NULL,
    lon DECIMAL(11,8) NOT NULL,
    recorded_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_ride_locations ON ride_locations(ride_id, recorded_at);
```

### **ETA Calculation**

```
Option 1: Simple (Haversine Distance)
- Calculate straight-line distance
- Assume average speed (30 km/h in city)
- ETA = distance / speed

Option 2: Accurate (Map Services)
- Use Google Maps / OpenStreetMap API
- Consider real-time traffic
- Actual route distance
- Cache common routes

Option 3: ML-Based
- Train model on historical data
- Features: time of day, day of week, weather, traffic
- Predict ETA with higher accuracy
```

### **Fare Calculation**

```typescript
function calculateFare(ride: Ride): number {
  const BASE_FARE = 5.00;
  const PER_KM_RATE = 1.50;
  const PER_MIN_RATE = 0.30;
  const SURGE_MULTIPLIER = getSurgeMultiplier(ride.pickup_location, ride.timestamp);
  
  let fare = BASE_FARE;
  fare += ride.distance_km * PER_KM_RATE;
  fare += ride.duration_min * PER_MIN_RATE;
  fare *= SURGE_MULTIPLIER;
  
  // Peak hours (7-9 AM, 5-7 PM)
  if (isPeakHour(ride.timestamp)) {
    fare *= 1.2;
  }
  
  return Math.round(fare * 100) / 100;  // Round to 2 decimals
}

function getSurgeMultiplier(location: Location, time: Date): number {
  // Check demand/supply ratio in the area
  const demandKey = `demand:${location.geohash}:${getHour(time)}`;
  const supplyKey = `supply:${location.geohash}:${getHour(time)}`;
  
  const demand = redis.get(demandKey);  // Number of ride requests
  const supply = redis.get(supplyKey);  // Number of available drivers
  
  const ratio = demand / supply;
  
  if (ratio > 3.0) return 2.0;      // High surge
  else if (ratio > 2.0) return 1.5; // Medium surge
  else if (ratio > 1.5) return 1.2; // Low surge
  else return 1.0;                   // No surge
}
```

### **Scalability Solutions**

1. **Geospatial Sharding**
   - Divide world into regions (geohash)
   - Each region has dedicated servers
   - Drivers/riders connected to nearest region server

2. **WebSocket Optimization**
   - Connection pooling
   - Message compression
   - Dedicated WebSocket servers (not API servers)

3. **Caching Strategy**
   ```
   Driver Locations: Redis GEO (TTL: 30 seconds)
   Active Rides: Redis Hash (no expiry)
   User Profiles: Redis (TTL: 1 hour)
   Map Routes: Redis (TTL: 24 hours)
   ```

4. **Database Optimization**
   - Shard rides by ride_id
   - Separate DB for analytics
   - Use PostGIS for geospatial queries

---

## 🎯 Interview Tips

### **Common Mistakes to Avoid:**

❌ **Jumping to Solution Too Quickly**
- Always clarify requirements first
- Ask about scale, constraints, priorities

❌ **Ignoring Trade-offs**
- Every decision has pros/cons
- Discuss why you chose one approach over another

❌ **Over-Engineering**
- Start simple, then scale
- Don't add complexity unless needed

❌ **Forgetting Non-Functional Requirements**
- Availability, latency, consistency
- Monitoring, logging, alerting

❌ **Not Discussing Bottlenecks**
- Identify single points of failure
- Discuss how to handle failures

### **Good Practices:**

✅ **Think Out Loud**
- Explain your thought process
- Ask clarifying questions

✅ **Draw Diagrams**
- Visual representation helps
- Label components clearly

✅ **Discuss Numbers**
- Back-of-the-envelope calculations
- Show you understand scale

✅ **Consider CAP Theorem**
- Consistency vs Availability trade-offs
- Appropriate for distributed systems

✅ **Mention Monitoring**
- How will you know if system is healthy?
- What metrics to track?

---

## 📚 More Systems to Practice

### **Easy:**
1. ✅ Design Pastebin
2. ✅ Design Rate Limiter
3. Design Web Crawler
4. Design Notification System

### **Medium:**
5. ✅ Design URL Shortener
6. ✅ Design Twitter
7. ✅ Design Instagram
8. Design WhatsApp
9. Design Netflix
10. Design Yelp / Google Maps

### **Hard:**
11. ✅ Design YouTube
12. ✅ Design Uber
13. Design Dropbox / Google Drive
14. Design Ticketmaster
15. Design Amazon / E-Commerce
16. Design Distributed Cache
17. Design Consistent Hashing
18. Design Message Queue
19. Design Search Engine (Google)
20. Design Ad Click Aggregator

---

## 🛠️ Tools to Practice With

1. **Excalidraw** - For drawing diagrams during interviews
2. **Draw.io** - More formal diagrams
3. **dbdiagram.io** - Database schema visualization
4. **Pramp** - Mock interviews
5. **interviewing.io** - Practice with engineers

---

## 📖 Recommended Resources

### **Books:**
- "Designing Data-Intensive Applications" by Martin Kleppmann
- "System Design Interview" by Alex Xu (Volumes 1 & 2)
- "Web Scalability for Startup Engineers" by Artur Ejsmont

### **Courses:**
- Grokking the System Design Interview (educative.io)
- System Design Primer (GitHub)
- ByteByteGo (YouTube & Newsletter)

### **Websites:**
- highscalability.com - Real-world architectures
- engineering blogs (Netflix, Uber, Airbnb, etc.)

---

## ✅ Final Checklist for Interviews

Before the interview:
- [ ] Review CAP theorem, ACID vs BASE
- [ ] Practice 5+ system designs
- [ ] Memorize key numbers (throughput, latency, storage)
- [ ] Know when to use SQL vs NoSQL
- [ ] Understand caching strategies
- [ ] Know load balancing algorithms
- [ ] Understand sharding vs partitioning

During the interview:
- [ ] Clarify requirements (5 mins)
- [ ] Do capacity estimation (5 mins)
- [ ] Draw high-level design (10 mins)
- [ ] Deep dive (15 mins)
- [ ] Identify bottlenecks (5 mins)
- [ ] Discuss trade-offs throughout
- [ ] Ask for feedback at the end

---

**Good luck with your system design interviews! 🚀**