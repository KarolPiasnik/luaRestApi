local config = require("lapis.config")

config("development", {
  port = 9091,
  greeting = "Hello world",
  mysql = {
    host = "127.0.0.1",
    user = "mysql",
    password = "zaq1@WSX",
    database = "lapisshop"
  }
})