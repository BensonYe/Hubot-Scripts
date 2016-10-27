# Description:
#   Allows Hubot to interact with http://api.avatardata.cn/TangShiSongCi/Random to randomly return poem
#
# Commands:
#   hubot poem|诗词|唐诗宋词 - poem|唐诗宋词

module.exports = (robot) ->
  robot.respond /(?:poem|诗词|唐诗宋词) *$/i, (msg) ->
    randomPoem msg

randomPoem = (msg) ->
  key = "549372042dbb4a54a80accbd72baac32"
  params = "key=#{key}"

  req = msg.http("http://api.avatardata.cn/TangShiSongCi/Random?#{params}")
  req.header "Content-Type", "application/json;charset=UTF-8"
  req.header "Accept", "application/json"

  try
    req.get() (err, res, body) ->
      switch res?.statusCode
        when 200
          jsonBody = JSON.parse body
          if jsonBody?.error_code is 0
            data = jsonBody?.result
            author = data?.zuozhe
            author = author.replace /\r|\n|\[.*\]|【.*】|\s*/gm, ""
            title = data?.biaoti
            title = title.replace /\（.*\）|\(.*\)|\s*/gm, ""
            content = data?.neirong
            content = content.replace /\r|\n|\[.*\]|【.*】|\s*/gm, ""
            content = content.replace /。/gm, "。\n"
            msg.send "#{title}  --#{author}\n#{content}"
          else
            msg.send jsonBody?.reason
        when 404
          msg.send "哦噢...查找失败！"
        else
          msg.send "Debug: #{res.statusCode}"
  catch
    console.log "Got error: ", error