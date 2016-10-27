# Description:
#   Allows Hubot to interact with http://apis.juhe.cn/idcard/index to search information of ID card
#
# Commands:
#   hubot weather|天气 城市 - search weather|天气预报

module.exports = (robot) ->
  robot.respond /(?:weather|天气) (.*) *$/i, (msg) ->
    searchWeather msg

searchWeather = (msg) ->
  cityname = msg.match[1]
  key = "588e935d2afa647389a2330bcd716d10"
  params = "cityname=#{cityname}&key=#{key}"

  req = msg.http("http://op.juhe.cn/onebox/weather/query?#{params}")
  req.header "Content-Type", "application/json;charset=UTF-8"
  req.header "Accept", "application/json"

  try
    req.get() (err, res, body) ->
      switch res?.statusCode
        when 200
          jsonBody = JSON.parse body
          if jsonBody?.error_code is 0
            data = jsonBody?.result?.data
            realtime = data?.realtime
            life = data?.life
            pm25 = data?.pm25
            datetime = "#{realtime?.date} #{realtime?.time}"
            city = realtime?.city_name
            weather = realtime?.weather?.info
            temperature = realtime?.weather?.temperature
            humidity = realtime?.weather?.humidity
            windDirect = realtime?.wind?.direct
            windPower = realtime?.wind?.power
            sex = jsonBody?.result?.sex
            birthday = jsonBody?.result?.birthday
            content = "#{city}(#{datetime})\n天气：   #{weather} -- #{temperature}℃ -- 湿度#{humidity}% -- #{windDirect}#{windPower}\n"
            content += "PM2.5：#{pm25?.pm25?.pm25}(#{pm25?.pm25?.des})"
            msg.send content
          else
            msg.send jsonBody?.reason
        when 404
          msg.send "哦噢...查找失败！"
        else
          msg.send "Debug: #{res.statusCode}"
  catch
    console.log "Got error: ", error