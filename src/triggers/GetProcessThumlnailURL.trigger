trigger GetProcessThumlnailURL on Process_Videos__c (before insert , before update) {
for (Process_Videos__c a : Trigger.New){

 string url=a.ProcessVideoURL__c;
  
 string ImageID=url.substringAfterLast('embed/');
     
 a.ProcessVideoImage__c='<img src=https://img.youtube.com/vi/'+ ImageID+'/mqdefault.jpg width="120" height="101"></img>';
 
}
}