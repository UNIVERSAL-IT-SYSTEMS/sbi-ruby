# -*- encoding: utf-8 -*-
#
#  SBIネット銀行
#  SBI client
#
# @author binzume  http://www.binzume.net/
#

require 'kconv'
require 'time'

require_relative 'httpclient'

class SBINetBank
  attr_reader :account_status, :accounts, :funds, :last_html
  attr_accessor :account

  def initialize(account = nil)
    @url = "https://www.netbk.co.jp/wpl/NBGate"
    ua = "Mozilla/5.0 (Windows; U; Windows NT 5.1;) NetBankClient/0.1"
    @client = HTTPClient.new(:agent_name => ua)
    login(account) if account
  end

  def login(account)
    # @client.get(@url+'/MS/main/RbS?CurrentPageID=START&&COMMAND=LOGIN')
    postdata = {
      'userName' => account['ID'],
      'loginPwdSet' => account['PASS'],
      'x' => "0",
      'y' => "0"
    }
    res = @client.post(@url + '/i010101CT', postdata)
    puts res.body

    postdata = {}
    res.body.toutf8.scan(/<input\s+type=['"]hidden['"]\s+name=['"]([^'"]+)['"] value=['"]([^'"]*)['"]/i) {|m|
      postdata[$1] = $2
    }
    postdata['ACT_doNext'] = "next."
    p postdata

    res = @client.post(@url, postdata)
    p res
    puts res.body

  end

  def logout
    @client.get(@url + '/i010001CT')
  end

end
