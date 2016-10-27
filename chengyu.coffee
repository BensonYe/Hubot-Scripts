# Description:
#   Allows Hubot to interact with http://v.juhe.cn/chengyu/query to search explaination of idiom
#
# Commands:
#   hubot idiom|成语 输入成语 - search explaination of idiom|成语词典

module.exports = (robot) ->
  robot.respond /(?:idiom|成语) (.*) *$/i, (msg) ->
    explainWord msg

explainWord = (msg) ->
  word = msg.match[1]
  key = "248b374df28fd55a36edaf2128054f32"
  params = "word=#{word}&key=#{key}"

  req = msg.http("http://v.juhe.cn/chengyu/query?#{params}")
  req.header "Content-Type", "application/json;charset=UTF-8"
  req.header "Accept", "application/json"
  
  try
    req.get() (err, res, body) ->
      switch res?.statusCode
        when 200
          jsonBody = JSON.parse body
          if jsonBody?.error_code is 0
            explaination = jsonBody?.result?.chengyujs
            example = jsonBody?.result?.example
            msg.send "#{word}\n解释：#{explaination}\n举例：#{example}"
          else
            msg.send jsonBody?.reason
        when 404
          msg.send "哦噢...查找失败！"
        else
          msg.send "Debug: #{res.statusCode}"
  catch
    console.log "Got error: ", error