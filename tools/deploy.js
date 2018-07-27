const fs = require('fs'),
    child_process = require('child_process'),
    path = require('path');

if (!process.env.SFDC_SANDBOX_USERNAME) {
    console.error(`Error: must define SFDC_SANDBOX_USERNAME enviornment variable`);
    process.exit();
}

const username = process.env.SFDC_SANDBOX_USERNAME;
const deployDir = path.join(__dirname, '..');
const deployParams = ['force:mdapi:deploy', '-d', deployDir, '-u', username, '--json'];

console.log(`Deploying ${deployDir} under username ${username}`);

var result = execHandleError('sfdx', deployParams);

var status = result.result.status;
while (-1 == ['Succeeded', 'Canceled', 'Failed'].indexOf(status)) {
    var msg = 'Deployment ' + status;
    if ('Queued' != status) {
        msg += ' (' + result.result.numberComponentsDeployed + '/' + result.result.numberComponentsTotal + ')'
    }
    console.log(msg);
    var reportParams = ['force:mdapi:deploy:report', '-i', result.result.id, '-u', username, '--json'];
    var result = execHandleError('sfdx', reportParams);
    status = result.result.status;
}

console.log('Deployment ' + result.result.status);
if ('Failed' === result.result.status) {
    console.error(result.result);
    if (result.result.details.componentFailures) {
        // handle if single or array of failures
        var failureDetails;
        if (Array.isArray(result.result.details.componentFailures)) {
            failureDetails = result.result.details.componentFailures;
        }
        else {
            failureDetails = [];
            failureDetails.push(result.result.details.componentFailures);
        }
        for (var idx = 0; idx < failureDetails.length; idx++) {
            var failure = failureDetails[idx];
            console.log('Error: ' + failure.fileName +
                ': Line ' + failure.lineNumber +
                ', col ' + failure.columnNumber +
                ' : ' + failure.problem);
        }
    }
}

function execHandleError(cmd, params) {
    try {
        var err = fs.openSync('/tmp/err.log', 'w');
        resultJSON = child_process.execFileSync(cmd, params, { stdio: ['pipe', 'pipe', err] });
        result = JSON.parse(resultJSON);
        fs.closeSync(err);
    }
    catch (e) {
        fs.closeSync(err);
        // the command returned non-zero - this may mean the metadata operation
        // failed, or there was an unrecoverable error
        // Is there an opening brace?
        var errMsg = '' + fs.readFileSync('/tmp/err.log');
        var bracePos = errMsg.indexOf('{');
        if (-1 != bracePos) {
            resultJSON = errMsg.substring(bracePos);
            result = JSON.parse(resultJSON);
        }
        else {
            throw e;
        }
    }

    return result;
}