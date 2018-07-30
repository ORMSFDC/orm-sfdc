({
    checkBrowser: function(component) {
        var device = $A.get("$Browser.formFactor");
        var bro = $A.get("$Browser");
        console.log($A.get('$Browser'));
        console.log("<><><><><> Thsi is from lightnign Component  <><><><><><>");
   var a=window.navigator.userAgent.indexOf("Edge") > -1;
//alert(a);
        
        
          if(bro.isFIREFOX || bro.isIE6 || bro.isIE7 || bro.isIE8 || bro.isIE9 || bro.isIE10 ||  bro.isIE11 || bro.isGecko || bro.isSafari || bro.isOpera || bro.isIOS || bro.isIPad || bro.isIPhone || bro.isOSX || bro.isPhone || bro.isTablet || a==true )
         //if(!bro.isChrome)  
        {
              
            // alert("Please Use CHROME for Better experience....!");
             alert("To get the most out of your experience on our site, please update your browser to Google Chrome. Without Google Chrome, you may experience problems on the site.");
              component.set("v.show_popup",true);
              console.log('>>>>>> this is true');
          }
        
        console.log(bro.isFIREFOX);
    }
})