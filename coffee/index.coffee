fs = require 'fs'
program = require 'commander'
{spawn} = require 'child_process'
request = require 'request'
repl = require 'readline'
tokenmachine = require 'browser-token-machine'

get_scope = (given)->
  return given if given? and given isnt ''
  types = [
    'content'
    'themes'
    'products'
    'customers'
    'orders'
    'script_tags'
    'shipping'
  ]
  scope = []
  for item in types
    scope.push "write_#{item}"
  scope.join ','

fs.readFile __dirname + '/../package.json', (error, data)->
  throw error if error?
  program
    .version(JSON.parse(data).version)
    .option('-n --shopname [string]', 'Shopname')
    .option('-i --client_id [string]', 'ClientId')
    .option('-c --scope [string]' , 'Scope - Defaults to All')
    .option('-s --client_secret [string]', 'ClientSecret')
    .parse(process.argv)
  scope = get_scope program.scope
  base = "https://#{program.shopname}.myshopify.com/admin/oauth"
  url = base + "/authorize?client_id=#{program.client_id}&scope=#{scope}"
  getTempToken = ()->
    tokenmachine url, "Copy the ?code param from the callback url here:", (temp_token) ->
      if not temp_token? or temp_token is ''
        return getTempToken()
      request.post
        url:base + "/access_token"
        qs:
          client_id:program.client_id
          client_secret:program.client_secret
          code:temp_token
      , (error, req, body) ->
        console.log error if error
        console.log body
  getTempToken()

