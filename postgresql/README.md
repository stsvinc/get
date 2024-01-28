
To install postgresql directly form online script you can just copy and paste the following command and execute.

Installation command:
```shell
curl -sSL https://raw.githubusercontent.com/stsvinc/get/main/postgresql/install.sh | sh
```

Command with alternate link:
```shell
curl -sSL https://get.stsvinc.com/postgresql | sh
```


```shell
TDIR=$(mktemp -d) && wget -O $TDIR/xinstall https://raw.githubusercontent.com/stsvinc/get/main/postgresql/install.sh && bash $TDIR/xinstall && rm -rf $TDIR
```