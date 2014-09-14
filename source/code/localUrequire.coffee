findup = require("findup-sync")
resolve = require("resolve").sync

urequirepath = null
urequire = null

try
  urequirepath = resolve("urequire", basedir: process.cwd())
catch ex
  urequirepath = findup("urequire/build/code/urequire.js")

if urequirepath
  try
    urequire = require urequirepath
  catch err
    urequire = null

module.exports = urequire