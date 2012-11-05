fs = require 'fs'
program = require 'commander'
{spawn} = require 'child_process'
request = require 'request'
repl = require 'readline'

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
    .parse(process.argv)
  scope = get_scope program.scope
  url = "https://#{program.shopname}.myshopify.com/admin/oauth/authorize?client_id=#{program.client_id}&scope=#{scope}"
  console.log url


