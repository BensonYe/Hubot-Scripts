# Description:
#   Allows Hubot to get the history of today. 
#
# Commands:
#   hubot 历史上的今天 条数

module.exports = (robot) ->
  robot.respond /(?:历史上的今天) *([0-9]*) *$/i, (msg) ->
    tellTodayHistory msg

tellTodayHistory = (msg) ->
  num = msg.match[1]
  console.log "num=#{num}"
  if num.length is 0
    num = 2
  else
    if num <= 0
      msg.send "条数不对，请输入大于0的数字"
      return
  today = new Date()
  month = today.getMonth() + 1
  day = today.getDate()
  key = "6546a68c1cf889c6c6fe2c5554ef4d5e"
  params = "key=#{key}&v=1.0&month=#{month}&day=#{day}"
  req = msg.http("http://api.juheapi.com/japi/toh?#{params}")
  req.header "Content-Type", "application/json;charset=UTF-8"
  req.header "Accept", "application/json"

  req.get() (err, res, body) ->
    switch res?.statusCode
      when 200
        jsonBody = JSON.parse body
        #console.log jsonBody?.result[1].title
        if jsonBody?.error_code is 0
          replyContent = ""
          while num > 0
            item = jsonBody?.result[num]
            content = "#{item?.year}.#{item?.month}.#{item?.day}: #{item?.title}\n"
            replyContent += content
            num -= 1
          msg.send replyContent
      when 404
        msg.send "数据已消失: #{res?.statusCode}"
      else
        msg.send "Debug: #{res?.statusCode}"