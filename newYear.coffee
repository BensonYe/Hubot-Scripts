# Description:
#   Allows Hubot to get red package image to fun and celebrate Chinese NY.
#
# Commands:

fs = require 'fs'

module.exports = (robot) ->
  robot.hear /(?:红包|利是|恭喜|发财|新春|大吉)(.*)/i, (msg) ->
    #remaining = msg.match[1]
    #if (remaining.indexOf "请在手机上查看") isnt -1
      #_sendRedPacketImage msg
    #else
      #_sendHappyCNYImage msg
    _sendHappyCNYImage msg

_sendRedPacketImage = (msg) ->
  imgDir = "F\:/BeautyImageDir/"
  if fs.existsSync imgDir
    fileList = fs.readdirSync imgDir
    index = Math.floor(Math.random() * fileList.length)
    msg.emote imgDir + fileList[index]

_sendHappyCNYImage = (msg) ->
  #imgDir = "F\:/BeautyImageDir/"
  #if fs.existsSync imgDir
    #fileList = fs.readdirSync imgDir
    #index = Math.floor(Math.random() * fileList.length)
    #msg.emote imgDir + fileList[index]
  msg.send "恭喜发财"
