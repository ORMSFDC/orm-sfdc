# ORM SFDC

Complete SFDC codebase for ORM

## Development & release cycle flow

**Assertions**
1.  `master` branch is **ALWAYS** production deployable.
1.  Release manager (Mike) will create a gearsets CI to QA as soon as a new sprint branch is created.
1.  Layouts and permissions can not be handled in this codebase, must be assigned in the SFDC setup web UI.  Devs will track these manually in their branch's `README.md` (see below).
1.  You have [Instaled IntelliJ and Illuminated Cloud plugin](./intellij-setup.md)

**Flow**

1.  **Release manager**: every new sprint:
    1.  creates a git branch for the sprint (ex: `git push origin sprint7`)
    1.  creates a gearsets CI job, connecting it to QA (ignoring `package.xml`) 
    1.  connect gearsets to slack channel (https://hooks.slack.com/services/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)
1.  **Developer**: Checkout sprint branch (ex: `git checkout sprint7`)
1.  **Developer**: Create new branch from the sprint branch. Ex: `git checkout -b sprint7-ryan`
1.  **Developer**: Go to production SFDC UI and [Refresh your sandbox](https://help.salesforce.com/articleView?id=data_sandbox_refresh.htm&type=5) from the QA enviornment.  Make sure to choose `Create From: QA` and `Auto Activate`
1.  **Developer**: [Hookup Illuminated Cloud](./intellij-setup.md) to your sandbox.
1.  **Developer**: Install [Salesforce Lightning Inspector](https://chrome.google.com/webstore/detail/salesforce-lightning-insp/pcpmcffcomlcjgpcheokdfcjipanjdpc?hl=en) plugin for google chrome.
1.  **Developer**: As you develop, make note of profiles and permission changes this `README.md` (template below)
1.  **Developer**: When ready to deliver to QA:    
    1.  [rebase](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) your branch on top of the sprint branch to pull in any changes made since you branched from it.  Ex: `git fetch origin && git rebase sprint7`
    1.  If you have lots of un-necessary commit messages, please [squash them](http://gitready.com/advanced/2009/02/10/squashing-commits-with-rebase.html) into a few concise messages.    
1.  **Developer**: Send a github pull request from your branch to the sprint branch. 
1.  **Release manager**: will review changes at a high level, and take note of `package.xml` updates.  He will then update the CI on the sprint branch to account for `package.xml` changes.
1.  **Release manager**: merge PR, then **delete developer feature branch**.  CI deploy to QA will automatically run.  **NOTE**: The QA CI deploy only supports [these metadata types](https://docs.google.com/spreadsheets/d/1gbJW7k0mVKhb4Sb_IXZM345nGrnQcIXnIEL7V4NZ9o4/edit#gid=0).  If you need to deploy a type not on this list, ping Mike.
1.  **Developer**: delete your feature branch. Ex: `git branch -d sprint7-ryan`
1.  **Release manager**: Once biz has signed off on QA, gearsets CI will be updated to deploy to UAT
1.  **Release manager**: Once biz signs off on UAT, Release manager will create a PR from feature branch to `master` (rebasing if necessary)
1.  **Release manager**: will create a new [Github release](https://github.com/ORMSFDC/sfdc/releases) incrementing the version number.  [Example](https://github.com/ORMSFDC/sfdc/releases/tag/1.0).
1.  **Release manager**: will deploy `master` to production


# Sprint feature branch notes

## New SFDC object/field permissions needed for this feature branch

- [ ] Grant visiblity on `New_Loan__C.Loan_Payment_Plan_Term`
- [ ] Give sys admins permission on `Daily Prodct Rate` permission set

## New ExternalServiceRegistries entries

- [ ] Add `BaydocsProductRateUpdate`
    * Label: `BaydocsProductRateUpdate`
    * Name:  `BaydocsProductRateUpdate`
    * Named Credential:  `BaydocsAPI`
    * Description: `API to update product rates, such as HELO LIBOR swap`
    * Is Active: `yes`
    * username: `4738`
    * password: `see postman`
    * rest of fields empty

## New NamedCredential entries

- [x] `BaydocsAPI`
    * Label: `BaydocsAPI`
    * Name:  `BaydocsAPI`
    * URL:  QA: `https://test.baydocs.net` Production: `https://www.baydocs.net`
    * Callout Options: `leave all unchecked`





