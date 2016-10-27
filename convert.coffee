# Description:
#   Allows Hubot to interact with http://japi.juhe.cn/charconvert/change.from to convert chars
#
# Commands:
#   hubot convert|转换 简|繁|火星文 原文 - convert chars for you|为你做（简\繁\火星文）转换

module.exports = (robot) ->
  robot.respond /(?:convert|转换) (简|繁|火星文) (.*)/i, (msg) ->
    convertChars msg

convertChars = (msg) ->
  text = msg.match[2]
  type = msg.match[1]
  
  if type is "简"
    type = 0
  else if type is "繁"
    type = 1
  else if type is "火星文"
    type = 2
  console.log type
  params = "text=#{text}&type=#{type}&key=53c1ea4e6dc248cac544d7ba211c15f2"

  req = msg.http("http://japi.juhe.cn/charconvert/change.from?#{params}")
  req.header "Content-Type", "application/json;charset=UTF-8"
  req.header "Accept", "application/json"
  
  try
    req.get() (err, res, body) ->
      switch res?.statusCode
        when 200
          jsonBody = JSON.parse body
          console.log jsonBody
          if jsonBody?.error_code is 0
            instr = jsonBody?.instr
            outstr = jsonBody?.outstr
            msg.send "#{instr}：#{outstr}"
          else
            msg.send "哦噢...转换失败！"
        when 404
          msg.send "哦噢...转换失败！"
        else
          msg.send "Debug: #{res.statusCode}"
  catch
    console.log "Got error: ", error