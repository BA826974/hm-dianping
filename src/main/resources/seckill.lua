-- 本文件用于判断库存是否充足，传入的用户是否对同一个优惠券进行重复下单
local voucherId = ARGV[1]
local userId = ARGV[2]

local stockKey = 'seckill:stock:' .. voucherId
local orderKey = 'seckill:order:' .. voucherId
-- 判断库存是否重组
if(tonumber(redis.call('get',stockKey))<=0) then
    return 1
end
-- 判断传入的用户id是否对同一个优惠券进行重复下单
if(redis.call('sismember',orderKey,userId)==1) then
    return 2
end
-- 库存-1
redis.call('incrby',stockKey,-1)
-- 订单中添加传入的用户id
redis.call('sadd',orderKey,userId)

redis.call('xadd','stream.orders','*','userId',userId,'voucherId',voucherId,
'id',orderId)
return 0