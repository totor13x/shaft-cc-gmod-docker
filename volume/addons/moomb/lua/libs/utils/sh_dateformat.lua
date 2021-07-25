print('test')
-- TTS.Libs.Utils.DateToEpoch = function ( date )

--   -- local date = '05/17/2017 05:17:00 PM'
--   local year, month, day, hours, minutes, seconds = date:match('^(%d%d)-(%d%d)-(%d%d%d%d) (%d%d):(%d%d):(%d%d)$')
--   if not year then
--       -- Our entire match failed, and no captures were made
--       error('could not parse date "' .. date .. '"')
--   end

--   return os.time({
--     day = tonumber(day),
--     hour = tonumber(hours),
--     isdst = false,
--     min = tonumber(minutes),
--     month = tonumber(month),
--     sec = tonumber(seconds),
--     year = tonumber(year)
--   })
--   -- if amPm == 'PM' then
--   --     hours = string.format('%2d', tonumber(hours) + 12)
--   -- end
--   -- local newDate = string.format(
--   --     '%s-%s-%s %s:%s:%s',
--   --     year, month, day, hours, minutes, seconds
--   -- )
--   -- print(newDate) -- 2017-05-17 17:17:00
-- end