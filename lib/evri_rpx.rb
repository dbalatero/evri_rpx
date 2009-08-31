$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'
require 'json'
require 'net/http'
require 'net/https'

require 'evri/rpx'
require 'evri/rpx/contact'
require 'evri/rpx/contact_list'
require 'evri/rpx/credentials'
require 'evri/rpx/mappings'
require 'evri/rpx/session'
require 'evri/rpx/user'
