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
    @client.insecure = true # debug
    login(account) if account
  end

  def login(account)
    # @client.get(@url+'/MS/main/RbS?CurrentPageID=START&&COMMAND=LOGIN')
    @account = {}
    postdata = {
      'userName' => account['ID'],
      'loginPwdSet' => account['PASS'],
      'x' => "0",
      'y' => "0"
    }
    res = @client.post(@url + '/i010101CT', postdata)
    # puts res.body

    postdata = {}
    res.body.toutf8.scan(/<input\s+type=['"]hidden['"]\s+name=['"]([^'"]+)['"] value=['"]([^'"]*)['"]/i) {|m|
      postdata[$1] = $2
    }
    # p postdata
    #res = @client.post(@url, postdata)

    res = @client.get(@url + '/i020101CT/DI02010100')

    if res.body.toutf8 =~/<strong>お預入れ合計<\/strong>.*?<strong>([\d,]+)\s*円<\/strong>/mi
      @account[:total] = $1
      true
    else
      puts "ERROR"
      false
    end
  end

  ##
  # ログアウト
  def logout
    @client.get(@url + '/i010001CT')
  end

  ##
  # 残高確認
  #
  # @return [int] 残高(yen)
  def total_balance
    @account[:total]
  end

  ##
  # 直近の取引履歴(円口座)
  #
  # @return [Array] 履歴の配列
  def recent
    []
  end

  def get_accounts
    [@account]
  end

end
