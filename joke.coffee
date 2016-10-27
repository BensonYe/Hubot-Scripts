# Description:
#   Allows Hubot to interact with http://api.laifudao.com/open/xiaohua.json to get a joke.
#
# Commands:
#   hubot joke|"笑话" - make a joke to you|给你讲个笑话

module.exports = (robot) ->
  robot.respond /(?!turing)(?!图灵)(?:joke|笑话).*/i, (msg) ->
    makeJoke msg

makeJoke = (msg) ->
  key = "6c403f58d36249139cf5d13a17724133"
  rows = 20
  params = "key=#{key}&page=1&rows=#{rows}"
  req = msg.http("http://api.avatardata.cn/Joke/NewstJoke?#{params}")
  req.header "Content-Type", "application/json;charset=UTF-8"
  req.header "Accept", "application/json"
  try
    req.get() (err, res, body) ->
      switch res.statusCode
        when 200
          jsonBody = JSON.parse body
          if jsonBody?.error_code is 0
            randomIdx = Math.floor(Math.random() * rows)
            content = jsonBody?.result[randomIdx]?.content
            replyJoke = content.replace /(\<br\/\>\<br\/\>\s*)/g, "\n"
            replyJoke = replyJoke.replace "&nbsp;" "  "
            msg.send "#{replyJoke}"
          else
            msg.send jsonBody?.reason
        when 404
          msg.send "天下最大的笑话就是...，没笑话"
        else
          msg.send "Debug: #{res.statusCode}"
  catch
    console.log "Got error: ", error

