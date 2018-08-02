# Setup intelliJ and Illuminated cloud

## One time steps

1. Install [IntelliJ](https://www.jetbrains.com/idea/download) community edition, then install the [illuminated cloud](http://www.illuminatedcloud.com) plugin. **Make sure** to install `illuminated cloud 2` plugin.  This plugin will help you deploy and sync up code with your sandbox.  You will need to [purchase](http://www.illuminatedcloud.com/purchase) a illuminated cloud licence after 30 days.
1. Open IntelliJ. At top choose `Help` > `Edit custom VM options`. Add/modify the following:
    ```
    -Xms1536m
    -Xmx1536m
    -XX:MaxPermSize=2048m
    -XX:ReservedCodeCacheSize=512m
    ```
1. Restart IntelliJ

## Steps for each sprint

[Watch this video](https://drive.google.com/file/d/1NjRUqFybXouLjH7iCMax0V5KEuRpQrkx/view?usp=sharing)