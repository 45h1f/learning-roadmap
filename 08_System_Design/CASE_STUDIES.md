# 🏢 System Design Case Studies

> **"The best way to learn system design is to study how real systems work."**

Real-world system design examples from companies like Twitter, Netflix, Uber, and more.

---

## 📋 Table of Contents

1. [Twitter Feed System](#twitter-feed-system)
2. [Netflix Video Streaming](#netflix-video-streaming)
3. [Uber Ride Matching](#uber-ride-matching)
4. [Instagram Photo Storage](#instagram-photo-storage)
5. [WhatsApp Messaging](#whatsapp-messaging)
6. [Spotify Music Streaming](#spotify-music-streaming)
7. [Amazon E-commerce](#amazon-e-commerce)
8. [YouTube Video Platform](#youtube-video-platform)
9. [Design Patterns Summary](#design-patterns-summary)

---

## 🐦 Twitter Feed System

### Requirements

```markdown
## Functional Requirements
- Users can post tweets (280 characters)
- Users can follow other users
- Users can see a feed of tweets from people they follow
- Real-time updates (tweets appear immediately)

## Non-Functional Requirements
- Scale: 500M users, 400M DAU
- 300M tweets per day = 3,500 tweets/second average
- Peak: 20,000 tweets/second
- Read:Write ratio = 100:1 (more reads than writes)
- Latency: Feed loads < 500ms
- Availability: 99.99%
```

### High-Level Architecture

```text
┌─────────────────────────────────────────────────────────────┐
│                        CDN (Static Assets)                  │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────┼───────────────────────────────┐
│                       Load Balancer                         │
└─────────────────────────────┼───────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌──────────────┐      ┌──────────────┐      ┌──────────────┐
│ Tweet Write  │      │  Feed Read   │      │  Timeline    │
│   Service    │      │   Service    │      │   Service    │
└──────┬───────┘      └──────┬───────┘      └──────┬───────┘
       │                     │                     │
       ▼                     ▼                     ▼
┌──────────────┐      ┌──────────────┐      ┌──────────────┐
│   Kafka      │      │  Redis Cache │      │  Cassandra   │
│ (Events)     │      │  (Hot Data)  │      │ (Cold Data)  │
└──────┬───────┘      └──────────────┘      └──────────────┘
       │
       ▼
┌──────────────┐
│  Fan-out     │
│  Service     │
└──────────────┘
```

### Data Model

```typescript
// Tweet Schema (Cassandra)
interface Tweet {
  tweetId: string;          // UUID
  userId: string;
  content: string;          // Max 280 chars
  mediaUrls: string[];      // Images/videos
  createdAt: timestamp;
  likes: number;
  retweets: number;
}

// User Schema
interface User {
  userId: string;
  username: string;
  followersCount: number;
  followingCount: number;
}

// Following Relationship (Graph)
interface Following {
  followerId: string;
  followeeId: string;
  createdAt: timestamp;
}

// Timeline Cache (Redis)
// Key: user:{userId}:timeline
// Value: List of tweet IDs (sorted by timestamp)
```

### Write Path (Posting a Tweet)

```typescript
// 1. User posts tweet
async function postTweet(userId: string, content: string) {
  // Generate tweet ID
  const tweetId = generateSnowflakeId(); // Time-based ID
  
  // Store tweet in Cassandra
  await cassandra.execute(
    'INSERT INTO tweets (tweet_id, user_id, content, created_at) VALUES (?, ?, ?, ?)',
    [tweetId, userId, content, Date.now()]
  );
  
  // Publish event to Kafka
  await kafka.produce('tweet-posted', {
    tweetId,
    userId,
    content,
    createdAt: Date.now()
  });
  
  return { tweetId, status: 'posted' };
}

// 2. Fan-out service consumes event
kafka.subscribe('tweet-posted', async (event) => {
  const { tweetId, userId } = event;
  
  // Get user's followers
  const followers = await getFollowers(userId);
  
  // Strategy: Hybrid approach
  if (followers.length < 10000) {
    // Fan-out on write (for most users)
    await fanOutToFollowers(tweetId, followers);
  } else {
    // Fan-out on read (for celebrities)
    // Don't pre-populate timelines
    await markUserAsHighProfile(userId);
  }
});

// 3. Fan-out on write
async function fanOutToFollowers(tweetId: string, followers: string[]) {
  // Batch insert to Redis (faster)
  const pipeline = redis.pipeline();
  
  for (const followerId of followers) {
    const timelineKey = `user:${followerId}:timeline`;
    pipeline.lpush(timelineKey, tweetId);
    pipeline.ltrim(timelineKey, 0, 799); // Keep only 800 tweets
  }
  
  await pipeline.exec();
}
```

### Read Path (Loading Feed)

```typescript
async function getTimeline(userId: string, limit: number = 50) {
  const timelineKey = `user:${userId}:timeline`;
  
  // 1. Check if user follows high-profile accounts
  const following = await getFollowing(userId);
  const celebrities = following.filter(u => isHighProfile(u));
  
  // 2. Get timeline from Redis (pre-computed)
  let tweetIds = await redis.lrange(timelineKey, 0, limit - 1);
  
  // 3. For celebrities, fetch their recent tweets (fan-out on read)
  if (celebrities.length > 0) {
    const celebrityTweets = await getCelebrityTweets(celebrities, limit);
    tweetIds = mergeAndSort([...tweetIds, ...celebrityTweets]);
  }
  
  // 4. Hydrate tweet data from Cassandra
  const tweets = await cassandra.execute(
    'SELECT * FROM tweets WHERE tweet_id IN ?',
    [tweetIds]
  );
  
  // 5. Cache tweet data
  await cacheHotTweets(tweets);
  
  return tweets;
}

// Optimization: Pagination with cursor
async function getTimelinePaginated(userId: string, cursor?: string, limit: number = 50) {
  const timelineKey = `user:${userId}:timeline`;
  
  let startIndex = 0;
  if (cursor) {
    startIndex = await redis.lpos(timelineKey, cursor) + 1;
  }
  
  const tweetIds = await redis.lrange(timelineKey, startIndex, startIndex + limit - 1);
  const tweets = await hydrateTweets(tweetIds);
  
  return {
    tweets,
    nextCursor: tweetIds[tweetIds.length - 1],
    hasMore: tweetIds.length === limit
  };
}
```

### Key Design Decisions

```markdown
## 1. Hybrid Fan-out Strategy

**Problem:** Pure fan-out on write doesn't scale for celebrities
**Solution:** Hybrid approach
- Regular users (< 10k followers): Fan-out on write
- Celebrities (> 10k followers): Fan-out on read

**Trade-offs:**
- Celebrities: Slower write, faster read
- Regular users: Faster write, instant timeline updates

## 2. Cassandra for Tweet Storage

**Why Cassandra?**
- Write-heavy workload (300M tweets/day)
- Time-series data (tweets ordered by time)
- Horizontal scalability
- No complex joins needed

**Partition Key:** user_id
**Clustering Key:** created_at (descending)

## 3. Redis for Timeline Cache

**Why Redis?**
- Fast reads (< 1ms)
- List data structure (perfect for timeline)
- Pub/sub for real-time updates
- Automatic eviction (LRU)

**Cache Strategy:**
- Store only tweet IDs (not full data)
- Keep 800 tweets per timeline
- TTL: 7 days

## 4. Snowflake ID for Tweet IDs

**Why not auto-increment?**
- Distributed system (multiple servers)
- Roughly sortable by time
- No coordination needed

**Format:** 64-bit
- 41 bits: timestamp
- 10 bits: machine ID
- 12 bits: sequence number
```

### Scaling Considerations

```markdown
## Current Scale
- 400M DAU
- 3,500 tweets/second average
- 20,000 tweets/second peak

## Bottlenecks & Solutions

### 1. Fan-out Service Bottleneck
**Problem:** Can't fan-out fast enough during peak
**Solution:**
- Shard fan-out by user ID
- Scale workers horizontally
- Batch Redis writes (pipeline)

### 2. Hot Celebrity Problem
**Problem:** Celebrity with 100M followers posts tweet
**Solution:**
- Don't fan-out (too expensive)
- Store separately
- Merge on read (cached)

### 3. Database Write Hotspots
**Problem:** Single Cassandra node overloaded
**Solution:**
- Partition by user_id + timestamp
- More partitions = better distribution
- Write to multiple regions

### 4. Real-time Updates
**Problem:** How do users see tweets instantly?
**Solution:**
- WebSocket connections
- Server pushes new tweet IDs
- Client fetches full data
```

---

## 🎬 Netflix Video Streaming

### Requirements

```markdown
## Functional Requirements
- Users can browse catalog (10,000+ titles)
- Users can search for content
- Users can stream videos (720p, 1080p, 4K)
- Adaptive bitrate streaming
- Resume playback from any device

## Non-Functional Requirements
- Scale: 230M subscribers, 100M concurrent streams
- Availability: 99.99%
- Global: 190+ countries
- Bandwidth: Massive (30% of internet traffic)
- Latency: Start streaming < 2 seconds
```

### Architecture

```text
                    ┌──────────────────┐
                    │  Client Apps     │
                    │ (Web, iOS, etc.) │
                    └────────┬─────────┘
                             │
            ┌────────────────┼────────────────┐
            │                │                │
            ▼                ▼                ▼
    ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
    │  API Gateway │  │   CDN/OCAs   │  │  Playback    │
    │  (Metadata)  │  │  (Video)     │  │   Service    │
    └──────┬───────┘  └──────────────┘  └──────┬───────┘
           │                                     │
           ▼                                     ▼
    ┌──────────────┐                    ┌──────────────┐
    │  Microservices│                    │   S3 / CDN   │
    │  - Catalog    │                    │   (Video)    │
    │  - User       │                    └──────────────┘
    │  - Recommendations │
    └──────────────┘
```

### Video Storage & Delivery

```typescript
// 1. Video Encoding (Pre-processing)
async function encodeVideo(videoId: string, sourceFile: string) {
  const encodings = [
    { resolution: '4K', bitrate: '15000k', codec: 'h264' },
    { resolution: '1080p', bitrate: '5000k', codec: 'h264' },
    { resolution: '720p', bitrate: '2500k', codec: 'h264' },
    { resolution: '480p', bitrate: '1000k', codec: 'h264' },
    { resolution: '360p', bitrate: '500k', codec: 'h264' }
  ];
  
  // Parallel encoding (AWS MediaConvert)
  const encodingJobs = encodings.map(async (encoding) => {
    const outputFile = `${videoId}_${encoding.resolution}.mp4`;
    
    // Start encoding job
    const job = await mediaConvert.createJob({
      input: sourceFile,
      output: outputFile,
      settings: {
        videoCodec: encoding.codec,
        bitrate: encoding.bitrate,
        resolution: encoding.resolution
      }
    });
    
    return job;
  });
  
  await Promise.all(encodingJobs);
  
  // 2. Split into chunks (HLS/DASH)
  await createManifest(videoId, encodings);
}

// 2. HLS Manifest (for adaptive streaming)
async function createManifest(videoId: string, encodings: Encoding[]) {
  const manifest = {
    type: 'HLS',
    variants: encodings.map(enc => ({
      resolution: enc.resolution,
      bitrate: enc.bitrate,
      url: `https://cdn.netflix.com/${videoId}/${enc.resolution}/index.m3u8`
    }))
  };
  
  // Upload manifest to S3
  await s3.putObject({
    Bucket: 'netflix-videos',
    Key: `${videoId}/manifest.m3u8`,
    Body: JSON.stringify(manifest)
  });
}

// 3. Video Streaming
async function getVideoStream(videoId: string, userId: string) {
  // Check user subscription
  const user = await getUserSubscription(userId);
  if (!user.isActive) {
    throw new Error('Subscription required');
  }
  
  // Get video metadata
  const video = await db.videos.findById(videoId);
  
  // Determine best quality based on user's bandwidth
  const userBandwidth = await estimateBandwidth(userId);
  const quality = selectQuality(userBandwidth);
  
  // Generate signed URL (temporary access)
  const streamUrl = await generateSignedUrl(videoId, quality, {
    expiresIn: 3600, // 1 hour
    userId
  });
  
  // Track playback
  await trackPlayback(userId, videoId, quality);
  
  return {
    streamUrl,
    manifest: `https://cdn.netflix.com/${videoId}/manifest.m3u8`,
    quality,
    duration: video.duration
  };
}

// 4. Adaptive Bitrate Switching
class AdaptiveStreamingPlayer {
  private currentQuality: string;
  private bandwidthSamples: number[] = [];
  
  async selectBestQuality(): Promise<string> {
    const bandwidth = this.estimateBandwidth();
    
    // Quality ladder
    if (bandwidth > 15000) return '4K';
    if (bandwidth > 5000) return '1080p';
    if (bandwidth > 2500) return '720p';
    if (bandwidth > 1000) return '480p';
    return '360p';
  }
  
  private estimateBandwidth(): number {
    // Average of last 10 samples
    return this.bandwidthSamples.slice(-10).reduce((a, b) => a + b, 0) / 10;
  }
  
  onChunkDownloaded(chunkSize: number, downloadTime: number) {
    const bandwidth = (chunkSize * 8) / downloadTime; // Kbps
    this.bandwidthSamples.push(bandwidth);
    
    // Switch quality if needed
    const optimalQuality = this.selectBestQuality();
    if (optimalQuality !== this.currentQuality) {
      this.switchQuality(optimalQuality);
    }
  }
  
  private switchQuality(newQuality: string) {
    console.log(`Switching from ${this.currentQuality} to ${newQuality}`);
    this.currentQuality = newQuality;
    // Fetch new manifest URL for new quality
  }
}
```

### Content Delivery Network (OCAs)

```markdown
## Netflix's Open Connect Appliances (OCAs)

**Problem:** Streaming video to 100M users globally is expensive

**Solution:** Place cache servers (OCAs) at ISPs

### Architecture:
┌──────────────┐
│   Netflix    │
│   Origin     │
└──────┬───────┘
       │
       ├─────────────────────────────┐
       │                             │
       ▼                             ▼
┌──────────────┐              ┌──────────────┐
│   ISP #1     │              │   ISP #2     │
│   OCA Cache  │              │   OCA Cache  │
│ (Comcast)    │              │ (AT&T)       │
└──────┬───────┘              └──────┬───────┘
       │                             │
       ▼                             ▼
   Customers                     Customers

### How it works:
1. Netflix ships physical servers to ISPs
2. Servers cache popular content (e.g., Stranger Things S4)
3. Users stream from local ISP (low latency, no transit costs)
4. Unpopular content still fetched from origin

### Benefits:
- Reduced latency (50ms → 5ms)
- Reduced bandwidth costs (90% from OCAs)
- Better quality (fewer buffering issues)
```

### Recommendation System

```typescript
// Personalized recommendations
async function getRecommendations(userId: string, limit: number = 20) {
  // 1. Get user profile
  const userProfile = await getUserProfile(userId);
  
  // 2. Get viewing history
  const watchHistory = await getWatchHistory(userId);
  
  // 3. Collaborative filtering
  const similarUsers = await findSimilarUsers(userId, watchHistory);
  const theirWatches = await getWatchHistory(similarUsers);
  
  // 4. Content-based filtering
  const likedGenres = extractGenres(watchHistory);
  const contentMatches = await findByGenres(likedGenres);
  
  // 5. Trending content
  const trending = await getTrending();
  
  // 6. Merge & rank
  const recommendations = mergeAndRank([
    { items: theirWatches, weight: 0.4 },      // Collaborative
    { items: contentMatches, weight: 0.3 },    // Content-based
    { items: trending, weight: 0.2 },          // Trending
    { items: await getNewReleases(), weight: 0.1 } // New
  ]);
  
  // 7. Remove already watched
  const filtered = recommendations.filter(
    item => !watchHistory.includes(item.id)
  );
  
  return filtered.slice(0, limit);
}

// A/B Testing for recommendations
async function getRecommendationsWithTest(userId: string) {
  const testVariant = await getTestVariant(userId, 'recommendation-algo-v2');
  
  if (testVariant === 'control') {
    return getRecommendations(userId); // Old algorithm
  } else {
    return getRecommendationsV2(userId); // New algorithm
  }
}
```

### Key Design Decisions

```markdown
## 1. Pre-encoding Multiple Bitrates

**Why?**
- Adaptive streaming (switch quality based on bandwidth)
- Better user experience (no buffering)
- Storage cost worth it for better QoE

## 2. Open Connect Appliances

**Why?**
- Reduced bandwidth costs (billions saved)
- Lower latency (better UX)
- Control over quality

**Trade-off:**
- Hardware costs
- Complexity

## 3. Microservices Architecture

**Services:**
- User Service
- Catalog Service
- Recommendation Service
- Playback Service
- Billing Service
- Analytics Service

**Why?**
- Independent scaling
- Team autonomy
- Resilience (one service down doesn't kill everything)

## 4. Data Storage

**Cassandra:** User activity, viewing history (write-heavy)
**MySQL:** User accounts, billing (transactional)
**S3:** Video files (blob storage)
**Elasticsearch:** Search catalog
**Redis:** Session data, cache
```

---

## 🚗 Uber Ride Matching

### Requirements

```markdown
## Functional Requirements
- Riders request rides
- Drivers see nearby ride requests
- Match riders with drivers
- Real-time location tracking
- ETA calculation
- Pricing (surge pricing)

## Non-Functional Requirements
- Scale: 15M trips/day = 173 trips/second
- Latency: Match rider with driver < 5 seconds
- Availability: 99.99%
- Real-time: Location updates every 3-5 seconds
```

### Architecture

```text
                  ┌──────────────────┐
                  │   Mobile Apps    │
                  │ (Rider + Driver) │
                  └────────┬─────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│  Location    │   │   Matching   │   │   Pricing    │
│  Service     │   │   Service    │   │   Service    │
└──────┬───────┘   └──────┬───────┘   └──────┬───────┘
       │                  │                  │
       ▼                  ▼                  ▼
┌──────────────┐   ┌──────────────┐   ┌──────────────┐
│   Redis      │   │  PostgreSQL  │   │   Redis      │
│  (Geospatial)│   │  (Trips)     │   │  (Surge)     │
└──────────────┘   └──────────────┘   └──────────────┘
```

### Geospatial Indexing

```typescript
// Using Redis Geospatial
class LocationService {
  private redis: Redis;
  
  // 1. Update driver location
  async updateDriverLocation(driverId: string, lat: number, lon: number) {
    // Store in Redis Geo
    await this.redis.geoadd('drivers:available', lon, lat, driverId);
    
    // Set expiry (if driver doesn't update in 30s, considered offline)
    await this.redis.expire(`driver:${driverId}:location`, 30);
    
    // Store metadata
    await this.redis.hset(`driver:${driverId}:info`, {
      lat,
      lon,
      lastUpdate: Date.now(),
      status: 'available'
    });
  }
  
  // 2. Find nearby drivers
  async findNearbyDrivers(
    lat: number,
    lon: number,
    radiusKm: number = 5,
    limit: number = 10
  ): Promise<Driver[]> {
    // Redis GEORADIUS command
    const results = await this.redis.georadius(
      'drivers:available',
      lon,
      lat,
      radiusKm,
      'km',
      'WITHDIST',
      'ASC', // Closest first
      'COUNT',
      limit
    );
    
    // Hydrate driver info
    const drivers = await Promise.all(
      results.map(async ([driverId, distance]) => {
        const info = await this.redis.hgetall(`driver:${driverId}:info`);
        return {
          driverId,
          distance: parseFloat(distance),
          ...info
        };
      })
    );
    
    return drivers;
  }
  
  // 3. Geohashing for cell-based indexing
  async getDriversInCell(geohash: string): Promise<string[]> {
    // Geohash divides world into cells
    // Nearby locations have similar geohashes
    const pattern = `drivers:geo:${geohash}*`;
    return await this.redis.smembers(pattern);
  }
}
```

### Ride Matching Algorithm

```typescript
class MatchingService {
  async requestRide(riderId: string, pickup: Location, dropoff: Location) {
    // 1. Create ride request
    const rideRequest = await db.rides.create({
      riderId,
      pickup,
      dropoff,
      status: 'searching',
      requestedAt: Date.now()
    });
    
    // 2. Find nearby drivers
    const nearbyDrivers = await locationService.findNearbyDrivers(
      pickup.lat,
      pickup.lon,
      5 // 5km radius
    );
    
    if (nearbyDrivers.length === 0) {
      // No drivers available, increase radius
      return this.expandSearchRadius(rideRequest);
    }
    
    // 3. Score and rank drivers
    const rankedDrivers = this.rankDrivers(nearbyDrivers, pickup);
    
    // 4. Send request to best drivers (top 3)
    const offers = await this.sendOffers(rideRequest.id, rankedDrivers.slice(0, 3));
    
    // 5. Wait for acceptance (timeout after 30s)
    const accepted = await this.waitForAcceptance(offers, 30000);
    
    if (accepted) {
      // Match found!
      await this.confirmMatch(rideRequest.id, accepted.driverId);
      return { matched: true, driver: accepted };
    } else {
      // No acceptance, expand to next batch
      return this.sendToNextBatch(rideRequest, rankedDrivers.slice(3, 6));
    }
  }
  
  private rankDrivers(drivers: Driver[], pickup: Location): Driver[] {
    return drivers
      .map(driver => ({
        ...driver,
        score: this.calculateScore(driver, pickup)
      }))
      .sort((a, b) => b.score - a.score);
  }
  
  private calculateScore(driver: Driver, pickup: Location): number {
    let score = 100;
    
    // Distance penalty (closer is better)
    score -= driver.distance * 2;
    
    // Rating bonus
    score += driver.rating * 10;
    
    // Acceptance rate bonus
    score += driver.acceptanceRate * 5;
    
    // Driver direction bonus (if moving toward pickup)
    if (this.isMovingToward(driver, pickup)) {
      score += 15;
    }
    
    return score;
  }
  
  private async sendOffers(rideId: string, drivers: Driver[]) {
    // Send push notification to drivers
    const offers = drivers.map(driver => ({
      rideId,
      driverId: driver.driverId,
      estimatedPickupTime: this.calculateETA(driver.location, pickup),
      fare: this.calculateFare(pickup, dropoff)
    }));
    
    // Store offers in Redis (for quick acceptance lookup)
    await Promise.all(
      offers.map(offer =>
        redis.setex(`offer:${rideId}:${offer.driverId}`, 30, JSON.stringify(offer))
      )
    );
    
    // Send push notifications
    await notificationService.sendBatch(
      offers.map(offer => ({
        driverId: offer.driverId,
        type: 'ride_offer',
        data: offer
      }))
    );
    
    return offers;
  }
  
  private async waitForAcceptance(offers: Offer[], timeout: number) {
    return new Promise<Offer | null>((resolve) => {
      const timer = setTimeout(() => resolve(null), timeout);
      
      // Subscribe to acceptance events
      const subscription = pubsub.subscribe('ride:accepted', (event) => {
        const accepted = offers.find(o => o.driverId === event.driverId);
        if (accepted) {
          clearTimeout(timer);
          subscription.unsubscribe();
          resolve(accepted);
        }
      });
    });
  }
}

// Driver accepts ride
async function acceptRide(driverId: string, rideId: string) {
  // Atomic check and set
  const acquired = await redis.set(
    `ride:${rideId}:accepted`,
    driverId,
    'NX', // Only set if not exists
    'EX',
    300 // 5 min expiry
  );
  
  if (!acquired) {
    throw new Error('Ride already accepted by another driver');
  }
  
  // Publish acceptance event
  await pubsub.publish('ride:accepted', { rideId, driverId });
  
  // Update ride status
  await db.rides.update(rideId, {
    driverId,
    status: 'accepted',
    acceptedAt: Date.now()
  });
  
  // Notify rider
  await notificationService.send(riderId, {
    type: 'driver_matched',
    driver: await getDriverInfo(driverId)
  });
}
```

### Surge Pricing

```typescript
class PricingService {
  async calculatePrice(pickup: Location, dropoff: Location): Promise<number> {
    // 1. Base fare
    const distance = calculateDistance(pickup, dropoff);
    const baseFare = 5 + (distance * 1.5); // $5 + $1.50/km
    
    // 2. Get surge multiplier
    const surgeMultiplier = await this.getSurgeMultiplier(pickup);
    
    // 3. Time-based multiplier
    const timeMultiplier = this.getTimeMultiplier();
    
    // 4. Calculate final price
    const price = baseFare * surgeMultiplier * timeMultiplier;
    
    return Math.round(price * 100) / 100; // Round to 2 decimals
  }
  
  private async getSurgeMultiplier(location: Location): Promise<number> {
    // Divide city into cells (geohash)
    const cell = geohash.encode(location.lat, location.lon, 6); // ~1km precision
    
    // Get supply/demand ratio for this cell
    const [availableDrivers, activeRides] = await Promise.all([
      redis.scard(`cell:${cell}:drivers:available`),
      redis.scard(`cell:${cell}:rides:active`)
    ]);
    
    const demandSupplyRatio = activeRides / Math.max(availableDrivers, 1);
    
    // Calculate surge
    if (demandSupplyRatio < 0.5) return 1.0; // No surge
    if (demandSupplyRatio < 1.0) return 1.2; // 1.2x
    if (demandSupplyRatio < 2.0) return 1.5; // 1.5x
    if (demandSupplyRatio < 3.0) return 2.0; // 2x
    return 2.5; // Max surge 2.5x
  }
  
  private getTimeMultiplier(): number {
    const hour = new Date().getHours();
    
    // Peak hours (7-9 AM, 5-7 PM)
    if ((hour >= 7 && hour <= 9) || (hour >= 17 && hour <= 19)) {
      return 1.3;
    }
    
    // Late night (12-5 AM)
    if (hour >= 0 && hour <= 5) {
      return 1.2;
    }
    
    return 1.0;
  }
  
  // Real-time surge updates
  async updateSurgeMap() {
    setInterval(async () => {
      // Get all active cells
      const cells = await this.getActiveCells();
      
      for (const cell of cells) {
        const surge = await this.getSurgeMultiplier(cell.location);
        
        // Cache surge value
        await redis.setex(`surge:${cell.geohash}`, 60, surge.toString());
        
        // Notify connected clients via WebSocket
        if (surge > 1.0) {
          await websocket.broadcastToCell(cell.geohash, {
            type: 'surge_update',
            surge,
            cell: cell.geohash
          });
        }
      }
    }, 30000); // Update every 30 seconds
  }
}
```

### Real-time Tracking

```typescript
// WebSocket for real-time location updates
class TrackingService {
  private io: SocketIO.Server;
  
  async trackRide(rideId: string, riderId: string, driverId: string) {
    // Rider joins room
    const riderSocket = this.io.to(`rider:${riderId}`);
    
    // Driver updates location every 3 seconds
    setInterval(async () => {
      const location = await redis.hgetall(`driver:${driverId}:location`);
      
      // Send to rider
      riderSocket.emit('driver_location', {
        lat: location.lat,
        lon: location.lon,
        heading: location.heading,
        eta: await this.calculateETA(location, ride.dropoff)
      });
    }, 3000);
  }
  
  async calculateETA(from: Location, to: Location): Promise<number> {
    // Use routing API (Google Maps, Mapbox, etc.)
    const route = await routingAPI.getRoute(from, to);
    
    // Consider traffic
    const trafficMultiplier = await this.getTrafficMultiplier(route);
    
    return route.duration * trafficMultiplier;
  }
}
```

### Key Design Decisions

```markdown
## 1. Redis Geospatial for Location

**Why Redis Geo?**
- Fast geospatial queries (< 1ms)
- Built-in GEORADIUS command
- In-memory for real-time updates

**Alternative:** PostgreSQL PostGIS
- Slower but persistent
- Better for historical queries

## 2. Cell-based Surge Pricing

**Why cells?**
- Aggregate demand/supply by area
- Scalable (can process in parallel)
- Fair pricing (nearby riders pay similar)

**Cell size:** ~1km (geohash precision 6)

## 3. Multi-phase Driver Matching

**Phase 1:** Top 3 closest drivers (5 seconds timeout)
**Phase 2:** Next 3 drivers (5 seconds timeout)
**Phase 3:** Expand radius, repeat

**Why?**
- Don't spam all drivers immediately
- Give closest drivers priority
- Fall back if no acceptance

## 4. Optimistic Locking for Ride Acceptance

**Problem:** Two drivers accept same ride
**Solution:** Redis SETNX (atomic set-if-not-exists)

Only first driver succeeds, others get error.
```

---

## 📸 Instagram Photo Storage

### Requirements

```markdown
## Functional Requirements
- Users upload photos (max 10MB)
- Photos displayed in feed
- Photos searchable by hashtags
- Support for multiple resolutions

## Non-Functional Requirements
- Scale: 100M photos/day = 1,157 photos/second
- Storage: Petabytes of photos
- Latency: Load photo < 200ms
- Availability: 99.9%
```

### Architecture

```typescript
// Photo upload flow
async function uploadPhoto(userId: string, photo: File) {
  // 1. Validate
  if (photo.size > 10 * 1024 * 1024) {
    throw new Error('Photo too large');
  }
  
  // 2. Generate photo ID
  const photoId = generateUUID();
  
  // 3. Upload original to S3
  const originalKey = `photos/original/${photoId}.jpg`;
  await s3.putObject({
    Bucket: 'instagram-photos',
    Key: originalKey,
    Body: photo,
    ContentType: 'image/jpeg'
  });
  
  // 4. Async: Create thumbnails
  await queue.add('create-thumbnails', {
    photoId,
    originalKey
  });
  
  // 5. Store metadata in database
  await db.photos.create({
    photoId,
    userId,
    originalUrl: `https://cdn.instagram.com/${originalKey}`,
    uploadedAt: Date.now(),
    status: 'processing'
  });
  
  return { photoId, status: 'processing' };
}

// Thumbnail generation (background job)
async function createThumbnails(photoId: string, originalKey: string) {
  // Download original
  const original = await s3.getObject({
    Bucket: 'instagram-photos',
    Key: originalKey
  });
  
  const sizes = [
    { name: 'thumbnail', width: 150 },
    { name: 'medium', width: 640 },
    { name: 'large', width: 1080 }
  ];
  
  // Process in parallel
  await Promise.all(
    sizes.map(async (size) => {
      // Resize image
      const resized = await sharp(original.Body)
        .resize(size.width, null, { fit: 'inside' })
        .jpeg({ quality: 80 })
        .toBuffer();
      
      // Upload to S3
      const key = `photos/${size.name}/${photoId}.jpg`;
      await s3.putObject({
        Bucket: 'instagram-photos',
        Key: key,
        Body: resized,
        ContentType: 'image/jpeg',
        CacheControl: 'public, max-age=31536000' // 1 year
      });
    })
  );
  
  // Update status
  await db.photos.update(photoId, {
    status: 'ready',
    thumbnailUrl: `https://cdn.instagram.com/photos/thumbnail/${photoId}.jpg`,
    mediumUrl: `https://cdn.instagram.com/photos/medium/${photoId}.jpg`,
    largeUrl: `https://cdn.instagram.com/photos/large/${photoId}.jpg`
  });
}
```

---

## 💬 WhatsApp Messaging

### Architecture

```typescript
// Message sending
async function sendMessage(from: string, to: string, content: string) {
  const messageId = generateMessageId();
  
  // 1. Store message
  await cassandra.execute(
    'INSERT INTO messages (message_id, from_user, to_user, content, sent_at) VALUES (?, ?, ?, ?, ?)',
    [messageId, from, to, content, Date.now()]
  );
  
  // 2. Check if recipient is online
  const isOnline = await redis.exists(`user:${to}:online`);
  
  if (isOnline) {
    // Send via WebSocket
    const socket = connectedUsers.get(to);
    socket?.emit('new_message', {
      messageId,
      from,
      content,
      sentAt: Date.now()
    });
    
    // Mark as delivered
    await updateStatus(messageId, 'delivered');
  } else {
    // Queue for offline delivery
    await queue.add('offline-message', { messageId, to });
    
    // Send push notification
    await sendPushNotification(to, {
      title: `New message from ${from}`,
      body: content.substring(0, 50)
    });
  }
  
  return { messageId, status: isOnline ? 'delivered' : 'sent' };
}

// End-to-end encryption
async function encryptMessage(content: string, recipientPublicKey: string) {
  // Signal Protocol / Double Ratchet
  const encrypted = await crypto.encrypt(content, recipientPublicKey);
  return encrypted;
}
```

---

## 🎵 Spotify Music Streaming

### Architecture

```markdown
Similar to Netflix but for audio:

1. **Music Storage**
   - Multiple bitrates (320kbps, 192kbps, 96kbps)
   - Cached on CDN
   - Pre-fetch next song in queue

2. **Recommendations**
   - Collaborative filtering (similar users)
   - Content-based (genre, artist)
   - Discover Weekly algorithm

3. **Offline Mode**
   - Download songs to device
   - Encrypted storage
   - Sync playback stats when online

4. **Social Features**
   - Real-time friend activity
   - Shared playlists (CRDT for conflict resolution)
```

---

## 🛒 Amazon E-commerce

### Key Components

```typescript
// Inventory management with eventual consistency
class InventoryService {
  async reserveItem(itemId: string, quantity: number): Promise<boolean> {
    // Optimistic locking
    const item = await db.inventory.findById(itemId);
    
    if (item.available < quantity) {
      return false; // Out of stock
    }
    
    // Attempt update with version check
    const updated = await db.inventory.updateOne(
      { 
        itemId,
        version: item.version,
        available: { $gte: quantity }
      },
      {
        $inc: { 
          available: -quantity,
          reserved: +quantity
        },
        $set: { version: item.version + 1 }
      }
    );
    
    return updated.modifiedCount === 1;
  }
  
  // Saga pattern for order processing
  async processOrder(orderId: string) {
    try {
      await reserveInventory(orderId);
      await processPayment(orderId);
      await createShipment(orderId);
      await confirmOrder(orderId);
    } catch (err) {
      // Compensating transactions
      await releaseInventory(orderId);
      await refundPayment(orderId);
      await cancelOrder(orderId);
      throw err;
    }
  }
}
```

---

## 📺 YouTube Video Platform

### Key Challenges

```markdown
## 1. Video Upload & Processing
- User uploads → S3
- Transcode to multiple formats (background job)
- Generate thumbnails
- Content ID (copyright detection)

## 2. Video Serving
- CDN for global delivery
- Adaptive bitrate streaming
- Pre-roll ads (separate stream)

## 3. Comments System
- High write volume
- Threaded comments (nested)
- Pagination (cursor-based)

## 4. View Count
- Increment asynchronously (eventual consistency)
- Batch updates every minute
- Don't block video playback
```

---

## 🎯 Design Patterns Summary

### Common Patterns Across All Systems

```markdown
## 1. CDN for Static Content
- Twitter: Profile images, media
- Netflix: Video files
- Instagram: Photos
- Spotify: Audio files

## 2. Caching (Redis)
- Twitter: Timeline cache
- Uber: Driver locations
- WhatsApp: Online status
- Amazon: Product catalog

## 3. Microservices
- All large-scale systems
- Independent scaling
- Team autonomy
- Resilience

## 4. Async Processing
- Instagram: Thumbnail generation
- Twitter: Fan-out
- YouTube: Video transcoding
- Amazon: Order processing

## 5. Sharding/Partitioning
- Twitter: User sharding
- Uber: Geo-based cells
- WhatsApp: Message routing
- Amazon: Inventory partitioning

## 6. Event-Driven Architecture
- Uber: Ride matching
- Twitter: Tweet events
- Amazon: Order saga
- Netflix: User activity tracking

## 7. Read/Write Separation
- Twitter: Cassandra (writes) + Redis (reads)
- Netflix: Microservices + CDN
- Instagram: S3 (writes) + CDN (reads)
```

---

## 📚 Key Takeaways

```markdown
## Scaling Principles

1. **Start Simple, Scale Smart**
   - Don't over-engineer day 1
   - Add complexity when metrics demand it

2. **Embrace Eventual Consistency**
   - Most systems don't need strong consistency
   - Trade consistency for availability/performance

3. **Cache Aggressively**
   - Multi-layer caching (browser, CDN, Redis, DB)
   - Cache invalidation is hard but necessary

4. **Async Everything**
   - Don't block user requests
   - Use queues for heavy processing

5. **Measure Everything**
   - You can't optimize what you don't measure
   - Metrics > Intuition

6. **Design for Failure**
   - Servers will fail
   - Networks will partition
   - Chaos engineering

7. **Geographic Distribution**
   - CDN for static content
   - Multi-region for low latency
   - Data sovereignty requirements

8. **Cost Optimization**
   - Right-size resources
   - Use spot instances
   - Monitor and optimize constantly
```

---

## 🔗 Related Resources

- **[FUNDAMENTALS.md](./FUNDAMENTALS.md)** - Core system design principles
- **[PATTERNS.md](./PATTERNS.md)** - Design pattern catalog
- **[SCALABILITY.md](./SCALABILITY.md)** - Scaling strategies

---

**Remember: These are simplified versions. Real systems are far more complex, but these case studies show the core principles.** 🚀