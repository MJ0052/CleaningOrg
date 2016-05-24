public class CleanOrgController {
    public void CleantheOrg(){
        //MetadataServiceExamples.deleteField();
        //MetadataServiceExamples.deleteRecordType();
        //MetadataServiceExamples.uninstallPackages();
        //MetadataServiceExamples.deleteListView();
        //MetadataServiceExamples.deleteSharingRule();
        //MetadataServiceExamples.deleteFlow();
        //MetadataServiceExamples.deleteStaticResource();
    	DeleteObjects();   
    }
    private void DeleteObjects(){
    	List<String> objectList = GetAllDeletableObjects();
        if(objectList.size() > 10){
        	List<String> objectToDelete = new List<String>();
        	for(Integer iCount = 0; iCount < objectList.size(); iCount++){
	        	objectToDelete.add(objectList[iCount]);
	            if(math.mod(iCount, 10) == 0){//Returns the remainder of integerValue1 divided by integerValue2.
	            	System.debug('iCount ' + iCount);
                    //Limit: 10. (For CustomMetadata only, the limit is 200.)
	                CleanOrgMetadataService.deleteObject(objectToDelete);
	                objectToDelete = new List<String>();
	            }
    	    }
        }
        else{
            CleanOrgMetadataService.deleteObject(objectList);
        }
    }
    private List<String> GetAllDeletableObjects(){
        List<String> supportedObject = new List<String>();
        for(Schema.SObjectType item : ProcessInstance.TargetObjectId.getDescribe().getReferenceTo())
        {
            if(item.getDescribe().isCustom()) //Returns true if the object is a custom object, false if it is a standard object.
            {
                supportedObject.add(item.getDescribe().getLocalName().toLowerCase());
            }
        }
        return supportedObject;
    }
}