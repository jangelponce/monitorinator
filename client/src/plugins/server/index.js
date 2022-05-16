import axios from 'axios'

const config = {
  serverUrl: process.env.VUE_APP_SERVER_URL || 'http://localhost'
}

const request = axios.create({
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }
})


const client = {}

client.get = function (suffix, args = {}) {
  const url = config.serverUrl + suffix
  return request({
    method: 'get',
    params: args.params || {},
    responseType: args.responseType || 'json',
    url
  })
}

client.post = function (suffix, args) {
  const url = config.serverUrl + suffix
  return request.post(url, args)
}

client.put = function (suffix, args = {}) {
  const url = config.serverUrl + suffix
  return request.put(url, args)
}

client.delete = function (suffix, args = {}) {
  const url = config.serverUrl + suffix
  return request({
    method: 'delete',
    params:  args.params || {},
    responseType: args.responseType || 'json',
    url
  })
}

const server = {}
server.install = function (app) {
  app.config.globalProperties.$server = client
}

export default server
