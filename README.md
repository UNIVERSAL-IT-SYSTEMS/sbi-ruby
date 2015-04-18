# SBI NetBank client library for Ruby

住信SBIネット銀行のためのクライアントライブラリです．

- 住信SBIネット銀行 https://www.netbk.co.jp/

## Require:

Ruby 1.9 or later.

## Feature:

残高取得のみです．

- 残高取得

## Exapmple:

sbi_account.yaml

```
ID: "hoge"
PASS: "********"
```

sbi_sample.rb
```
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
```

## License:

- MIT License

