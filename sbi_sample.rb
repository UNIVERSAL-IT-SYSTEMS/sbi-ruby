#!/usr/bin/ruby -Ku
# -*- encoding: utf-8 -*-
#

require 'yaml'
require_relative 'sbi'

account = YAML.load_file('sbi_account.yaml')
banking = SBINetBank.new

# login
unless banking.login(account)
  puts 'LOGIN ERROR'
  exit
end

begin
  puts "total: #{banking.total_balance}"
  banking.recent.each do |row|
    p row
  end
ensure
  # logout
  banking.logout
end
