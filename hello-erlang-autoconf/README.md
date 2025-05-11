# Erlang hello world with autoconf

This is a simple hello world application used for demonstrating how erlang can be used with the Yocto project:

```
autoreconf -f -i
./configure
make
sudo make install
```

## Important

This code was borrowed from https://github.com/sirbeancounter/hello and adapted for recent Yocto and meta-erlang layer versions. Graham Crowe, Anders Danne
gave a talk in  Erlang User Conference 2015 showing how integrate Yocto and meta-erlang, [Graham Crowe, Anders Danne - Embedded Erlang Development - Erlang User Conference 2015](https://www.youtube.com/watch?v=REZ93dZZ5uA).