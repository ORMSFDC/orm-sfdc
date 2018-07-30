/** * File Name   : BackendHierarchyUtility.cls
*     Description : Utility class used in ScenarioTriggerHandler and TriggerLoanStatusTrackHandler class
*     Created     : 11/06/2017
*     Copyright   :  
*   * @author     : Prsn
* */
public class BackendHierarchyUtility {
    public static Map<Id,User> getPartnerUserMap() {
        List<User> userList = [Select Id,Name,UserRole.Name,ContactId From User Where ContactId != null AND isActive = true];
        
        Map<Id,User> userMap = new Map<Id,User>();
        
        for(User user: userList){
            userMap.put(user.ContactId, user);
        }
        return userMap;
    }
}