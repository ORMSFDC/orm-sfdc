trigger GetThumlnailURL on YoutubeLinks__c (before insert , before update) {
for (YoutubeLinks__c a : Trigger.New){
 string url=a.YoutubeURL__c;
 string ImageID=url.substringAfterLast('embed/');
 a.Thumbnails_Image__c='<img src=https://img.youtube.com/vi/'+ ImageID +'/mqdefault.jpg width="120" height="101"></img>';
 
}
}