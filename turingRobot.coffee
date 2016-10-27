# Description:
#   Allows Hubot to interact with turing rebot http://www.tuling123.com/.
#
# Commands:
#   hubot turing|图灵|米图|mitu 你想对它说的话

module.exports = (robot) ->
  robot.hear /(turing|图灵|图图|米图|米兔|mitu|milo|hubot|benson|Benson) (.*)/i, (msg) ->
    turingRobot msg

turingRobot = (msg) ->
  alias = msg.match[1]
  #console.log alias
  info = msg.match[2]
  #console.log info
  key = "a79d47d36aeeece6444ca2e8964e5412"
  params = "info=#{info}&key=#{key}"
  #urlPath = "http://apis.baidu.com/turing/turing/turing?#{params}" // for baidu apis
  urlPath = "https://op.juhe.cn/robot/index?#{params}"
  req = msg.http(urlPath)
  #req.header "apikey", "" // for baidu apis
  try
    req.get() (err, res, body) ->
      getRandomItem = (length) ->
        return Math.floor(Math.random(0, 1) * length)
      sendMsgByCode =
        "100000": (msg, jsonBody) ->
                    msg.send "#{jsonBody?.result?.text}"
        "200000": (msg, jsonBody)->
                    msg.send "#{jsonBody.text}\n#{jsonBody.url if jsonBody.url}"
        "302000": (msg, jsonBody)->
                    randomIdx = getRandomItem jsonBody.list.length
                    item = jsonBody.list[randomIdx]
                    msg.send "#{jsonBody.text}\n#{item.article} from #{item.source}\n#{item.detailurl}"
        "308000": (msg, jsonBody)->
                    randomIdx = getRandomItem jsonBody.list.length
                    item = jsonBody.list[randomIdx]
                    msg.send "#{jsonBody.text}\n#{item.name}\n#{item.info}\n#{item.detailurl}"
      switch res.statusCode
        when 200
          jsonBody = JSON.parse body
          if jsonBody?.error_code is 0
            sendMsgByCode[jsonBody?.result?.code] msg, jsonBody
          else
            msg.send "为啥#{alias}不理我: #{jsonBody?.error_code}"
        when 404
          msg.send "为啥#{alias}不理我: #{res.statusCode}"
        else
          msg.send "Debug: #{res.statusCode}"
  catch
    console.log "Got error: ", error