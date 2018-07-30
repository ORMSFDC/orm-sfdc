# ORM SFDC

Complete SFDC codebase for ORM

## Development & release cycle flow

**Assertions**
1.  `master` branch is **ALWAYS** production deployable.
1.  Release manager (Mike) will create a gearsets CI to QA as soon as a new sprint branch is created.
1.  Layouts and permissions can not be handled in this codebase, must be assigned in the SFDC setup web UI.  Devs will track these manually in their branch's `README.md` (see below).

TODO: 
*  [] Add actors to the flow

**Flow**

1.  All: Clone this repo
1.  Release manager: every new sprint, release manager creates a git branch for the sprint (ex: `sprint7`) and creates a gearsets CI job, connecting it to QA (ignoring `package.xml`)
1.  Developer: Checkout sprint branch (ex: `git checkout sprint7`)
1.  Create new branch from the sprint branch. Ex: `git checkout -b sprint7-ryan`
1.  Modify [`package.xml`](./package.xml) as you develop, to specify ONLY what you are working on.  Also make note of profiles and permission changes in your `README.md` (template below)
1.  Deploy to your sandbox via `tools/deploy.sh`.  See [tools/README.md](./tools) for more info.
1.  When ready to deliver to QA, [rebase](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) your branch on top of the sprint branch to pull in any changes made since you branched from it.  Ex: `git fetch origin && git rebase sprint7`
1.  If you have lots of un-necessary commit messages, please [squash them](http://gitready.com/advanced/2009/02/10/squashing-commits-with-rebase.html) into a few concise ones.
1.  Send a github pull request from your branch to the sprint branch. 
1.  Release manager will review changes at a high level, and take note of `package.xml` updates.  He will then update the CI on the sprint branch to account for `package.xml` changes.
1.  Release manager merges PR, CI deploy to QA will automatically run
1.  Once biz has signed off on QA, gearsets CI will be updated to deploy to UAT
1.  Once biz signs off on UAT, Release manager will create a PR from feature branch to `master` (rebasing if necessary)
1.  Release manager will create a new [Github release](https://github.com/ORMSFDC/sfdc/releases) incrementing the version number.  [Example](https://github.com/ORMSFDC/sfdc/releases/tag/1.0).
1.  Release manager will deploy `master` to production

## TODO

- [ ] Modify [deploy.sh](./tools/deploy.sh) to NOT deploy `src` dir


# Sprint feature branch README.md template


## New SFDC object/field permissions needed for this feature branch

- [ ] Grant visiblity on `X_Object__c.Y` for Z profile




