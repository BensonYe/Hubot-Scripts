# Description:
#   Allows Hubot to interact with http://apis.juhe.cn/idcard/index to search information of ID card
#
# Commands:
#   hubot idcard|身份证 身份证号 - search information of ID card|身份证查询

module.exports = (robot) ->
  robot.respond /(?:idcard|身份证) ([A-Za-z0-9]+) *$/i, (msg) ->
    searchIdCard msg

searchIdCard = (msg) ->
  cardno = msg.match[1]
  key = "ff3ce08f9cb5b37ec6ee26426fc09cfd"
  params = "cardno=#{cardno}&key=#{key}"

  req = msg.http("http://apis.juhe.cn/idcard/index?#{params}")
  req.header "Content-Type", "application/json;charset=UTF-8"
  req.header "Accept", "application/json"
  
  try
    req.get() (err, res, body) ->
      switch res?.statusCode
        when 200
          jsonBody = JSON.parse body
          if jsonBody?.error_code is 0
            area = jsonBody?.result?.area
            sex = jsonBody?.result?.sex
            birthday = jsonBody?.result?.birthday
            msg.send "性别：#{sex}\n出生：#{birthday}\n住址：#{area}"
          else
            msg.send jsonBody?.reason
        when 404
          msg.send "哦噢...查找失败！"
        else
          msg.send "Debug: #{res.statusCode}"
  catch
    console.log "Got error: ", error