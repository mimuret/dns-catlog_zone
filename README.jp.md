# Dns::CatalogZone
[![Build Status](https://travis-ci.org/mimuret/dns-catalog_zone.svg?branch=master)](https://travis-ci.org/mimuret/dns-catalog_zone)
[![Coverage Status](https://coveralls.io/repos/github/mimuret/dns-catalog_zone/badge.svg?branch=master)](https://coveralls.io/github/mimuret/dns-catalog_zone?branch=master)

PoC of catalog zone (draft-muks-dnsop-dns-catalog-zones)
[README in English](https://github.com/mimuret/dns-catalog_zone/blob/master/README.md)  

## supported name server softwares
* NSD4 (default)
* Knot dns
* YADIFA

## インストール方法

```bash
$ git clone https://github.com/mimuret/dns-catalog_zone
$ cd dns-catalog_zone
$ bundle install --path=vendor/bundle
```

## 使い方

+ configuration

CatalogZoneファイルを生成します。

```bash
$ bundle exec catz init
$ cat CatalogZone
```

CatalogZoneの中身
```ruby
setting("catalog.example.jp") do |s|
	s.software="nsd"
	s.source="file"
	s.zonename="catalog.example.jp"
	s.zonefile="/etc/nsd/catalog.example.jp.zone"
end
````

+ name server config生成

```bash
$ bundle exec catz make
```

各実装の反映用のscriptはshare dirにあります。

## Settings attribute
| name | value | default | description |
|:-----------|------------|:------------|:------------|
|zonename|string(domain name)|catalog.example| catalog zone domain name |
|software|string|nsd|software module name|
|source|string|file|source module name|
|output|string|stdout|output module name|

### source modules
#### file module
| name | value | required |
|:-----------|:------------|:------------|
|source|file|true|
|zonefile|path|true|

#### axfr module
| name | value | default |required |
|:-----------|:------------|:------------|:------------|
|source|axfr||true|
|server|ip or hostname||true|
|port|int|53|false|
|tsig|string||false|
|src_address|ip||false|
|timeout|int|30|false|

### software modules
#### nsd module
| name | value | required |
|:-----------|:------------|:------------|
|software|nsd||

#### knot module
| name | value | required |
|:-----------|:------------|:------------|
|software|knot||

#### yadifa module
| name | value | required |
|:-----------|:------------|:------------|
|software|yadifa||

### output modules
#### stdout module
| name | value | required |
|:-----------|:------------|:------------|
|output|stdout||

#### file module
| name | value | required |
|:-----------|:------------|:------------|
|output|file||
|output_path|path|true|

## Contributing

バグレポートとプルリクエストはGitHub(https://github.com/mimuret/dns-catalog_zone)まで

対応するソフトウェアを増やしたい場合はプルリクエストしてマージするか、

Dns::CatalogZone::Provider::(作りたい実装名)のクラスを作ってLOAD_PATHにおいてください。


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

