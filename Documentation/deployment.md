# Deployment

We know 3 types of release builds:
- development (beta/dev)
- staging (rc)
- production (stable)

## Versioning
The format of version is *MAJOR.BUILD*. Everytime we create a new release with same userland, we bump the build number.
The development use here own major number they will be bump for the stable version and the development version go to next major number.

```
0.x = development
1.x = stable
2.x = development
3.x = stable
```

## GIT Branch/Tag
The branch `dev` ist the actual development branch and from there we never make a release. The `master` branch hould the development
version from they we build a beta release.

If we create a new staging/productive release, we create a new branch `rel-{MAJOR}`. They will be used for the hole cycle of this release.
