# Description:
#   Allows Hubot to get stock info.
#
# Commands:
#   hubot 股票|stock stockID

module.exports = (robot) ->
  robot.respond /(?:stock|股票) *([0-9]*) *$/i, (msg) ->
    getStockInfo msg

getStockInfo = (msg) ->
  stockId = msg.match[1]
  hasStockId = stockId.length is 6
  #console.log "stockId=#{stockId}, length=#{stockId.length}, hasStockId=#{hasStockId}"
  if !hasStockId
    msg.send "请输入6位数股票编码"
    return
  if stockId
    if stockId.startsWith "6"
      stockId = "sh" + stockId
    else if stockId.startsWith "0" or stockId.startsWith "3"
      stockId = "sz" + stockId
  else
    hasStockId = false
    stockId = "sz000001"
	
  params = "q=#{stockId}"
  urlPath = "http://qt.gtimg.cn/#{params}"
  req = msg.http(urlPath)
  req.get() (err, res, body) ->
    switch res?.statusCode
      when 200
        content = ""
        list = body.split('~')
        console.log list?.length
        if list?.length isnt 0 and list?.length isnt 1
          content += "====================\n"
          content += "#{list[1]}(#{list[2]})\n#{list[30]}\n"
          content += "当前价格: #{list[3]}\n"
          content += "涨跌: #{list[31]}\n"
          content += "涨幅: #{list[32]}%\n"
          content += "今日开盘价: #{list[5]}\n昨日收盘价: #{list[4]}\n"
          content += "今日最高价: #{list[33]}\n今日最低价: #{list[34]}\n"
          content += "成交的股票数: #{list[36]}\n成交额: #{list[37]} 元\n"
          content += "====================\n"
        else
          content += "找不到该股票(#{msg.match[1]})"
        msg.send content
      when 404
        msg.send "数据已消失: #{res?.statusCode}"
      else
        msg.send "Debug: #{res?.statusCode}"