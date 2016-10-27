# Description:
#   Allows Hubot to interact with http://api.avatardata.cn/XieHouYu/Random to randomly return xiehouyu
#
# Commands:
#   hubot xiehouyu|歇后语 - xiehouyu|歇后语

module.exports = (robot) ->
  robot.respond /(?:xiehouyu|歇后语) *$/i, (msg) ->
    randomXieHouYu msg

randomXieHouYu = (msg) ->
  key = "e4d7620f221547caab2e55dcd58498ab"
  params = "key=#{key}"

  req = msg.http("http://api.avatardata.cn/XieHouYu/Random?#{params}")
  req.header "Content-Type", "application/json;charset=UTF-8"
  req.header "Accept", "application/json"

  try
    req.get() (err, res, body) ->
      switch res?.statusCode
        when 200
          jsonBody = JSON.parse body
          if jsonBody?.error_code is 0
            data = jsonBody?.result
            question = data?.question
            answers = data?.answer.split ";"
            randomIdx = Math.floor(Math.random() * answers.length)
            msg.send "Q：#{question}\nA：#{answers[randomIdx]}"
          else
            msg.send jsonBody?.reason
        when 404
          msg.send "哦噢...查找失败！"
        else
          msg.send "Debug: #{res.statusCode}"
  catch
    console.log "Got error: ", error