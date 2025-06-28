const { createClient } = require('redis');

const redisClient = createClient({
  username: 'default',
  password: 'wOIuK6RL5RN2e7TZzaQX4vZRTnxKykg4',
  socket: {
    host: 'redis-16985.c295.ap-southeast-1-1.ec2.redns.redis-cloud.com',
    port: 16985
  }
});

redisClient.on('error', (err) => console.error('Redis Client Error', err));

(async () => {
  try {
    await redisClient.connect();
    console.log('Redis 已連線');
  } catch (err) {
    console.error('Redis 連線失敗:', err);
  }
})();

module.exports = redisClient;
