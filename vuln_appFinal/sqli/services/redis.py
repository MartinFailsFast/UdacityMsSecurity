from aiohttp.web import Application
import redis.asyncio as redis


def setup_redis(app: Application):
    app.on_startup.append(_init_redis)
    app.on_shutdown.append(_close_redis)


async def _init_redis(app: Application):
    conf = app['config']['redis']
    #redis = await aioredis.create_pool((conf['host'], conf['port']),
    #                                   db=conf['db'])
    # Creating a Redis client with the new API
    redis_client = redis.Redis(host=conf['host'], port=conf['port'], db=conf['db'])

    app['redis'] = redis_client


async def _close_redis(app: Application):
    await app['redis'].connection_pool.disconnect()
