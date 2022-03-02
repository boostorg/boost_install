# boost_install

This repository contains the implementation of the
`boost-install` rule. This rule, when called from
a library `Jamfile`, creates an `install` target
that installs the library and its CMake configuration
file. It also invokes the `install` targets of its
dependencies.

## Testing

Build and run steps to test the `build-install` rule a Boost library,
for example, Boost.Filesystem:

```console
git clone --recurse-submodules https://github.com/boostorg/boost.git boost-root
cd boost-root

./bootstrap.sh
./b2 headers
./b2 --layout=versioned --with-filesystem

cd tools/boost_install/test/filesystem
mkdir __build__ && cd __build__

cmake  -DUSE_STAGED_BOOST=ON -DBoost_VERBOSE=ON ..
cmake --build .
cmake --build . --target check
```
