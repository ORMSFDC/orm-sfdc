# Development tooling

## Deploying to sandbox

[`deploy.sh`](./deploy.sh) is used to deploy code that is specified in the `package.xml` file in the root of your repo.

1.  Set the enviornment var `SFDC_SANDBOX_USERNAME` to your sandbox username.  Run `sfdx force:org:list` to view your usernames.
    *  default MacOS shell: `export SFDC_SANDBOX_USERNAME=blah@youruser.blah`
    *  [fish shell](https://fishshell.com/): `set -x SFDC_SANDBOX_USERNAME blah@youruser.blah`
1.  Make sure your `package.xml` in the root of the repo specifies the things you need to deploy    
1.  Run `node tools/deploy.js`
1.  Run `sfdx force:org:open -u <sandbox username>` to open browser to your sandbox