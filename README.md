# trojan

## 魔改版：主要增加无限流量模式下限制单用户登录

请注意：如果quota大于0则会限制流量不限制IP登录，等于0则禁用账号，小于0则无限流量限制单IP登录

An unidentifiable mechanism that helps you bypass GFW.

Trojan features multiple protocols over `TLS` to avoid both active/passive detections and ISP `QoS` limitations.

Trojan is not a fixed program or protocol. It's an idea, an idea that imitating the most common service, to an extent that it behaves identically, could help you get across the Great FireWall permanently, without being identified ever. We are the GreatER Fire; we ship Trojan Horses.

## Documentations

An online documentation can be found [here](https://trojan-gfw.github.io/trojan/).  
Installation guide on various platforms can be found in the [wiki](https://github.com/trojan-gfw/trojan/wiki/Binary-&-Package-Distributions).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## MySQL

```php
CREATE TABLE users (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    username VARCHAR(64) NOT NULL,
    password CHAR(56) NOT NULL,
    active varchar(64) NOT NULL DEFAULT 0,
    address text NOT NULL DEFAULT 0,
    quota BIGINT NOT NULL DEFAULT -1,
    download BIGINT UNSIGNED NOT NULL DEFAULT 0,
    upload BIGINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    INDEX (password)
);
```

## Dependencies

- [CMake](https://cmake.org/) >= 3.7.2
- [Boost](http://www.boost.org/) >= 1.66.0
- [OpenSSL](https://www.openssl.org/) >= 1.1.0
- [libmysqlclient](https://dev.mysql.com/downloads/connector/c/)

## License

[GPLv3](LICENSE)
