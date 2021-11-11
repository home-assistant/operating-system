# Use workflows in forked repositories

`forked-helper.yml` workflow helper can help to run custom workflows on the forked repositories.

1. Set `HAOS_SELF_DISPATCH_TOKEN` secret on your repository with `security_events` permissions.
2. Helper will dispatch `repository_dispatch` event `haos-dispatch` on `push`, `release`, `deployment`,
   `pull_request` and `workflow_dispatch` events. All needed event details you can find in `client_payload`
   property of the event.
3. Create empty default branch in forked repository:
```shell
git checkout --orphan my-build-branch
git rm -rf .
git commit --allow-empty -m "Initial commit"
```
4. Create workflow with `repository_dispatch` in default branch.
5. Run any need actions in this workflow.

Workflow example:
```yaml
name: Test haos dispatch

on:
  repository_dispatch:
    types: ["haos-dispatch"]

jobs:
  show-dispatch:
    name: Show dispatch event details
    runs-on: ubuntu-latest
    steps:
      - uses: hmarr/debug-action@v2
```
