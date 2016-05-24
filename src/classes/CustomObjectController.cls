public class CustomObjectController
{
    //List displayed on UI
    public List<selectoption> supportedObject {get; set;}
    public String selectedObject {get; set;}
    //Constructor
    public CustomObjectController()
    {
        //Initialize
        supportedObject = new List<selectoption>() ;
        
        //Get only reference to objects
        for(Schema.SObjectType item : ProcessInstance.TargetObjectId.getDescribe().getReferenceTo())
        {
            //Excluding custom setting objects
            if(!item.getDescribe().CustomSetting)
            {
                //Adding to list
                supportedObject.add(new SelectOption(item.getDescribe().getLocalName().toLowerCase() , item.getDescribe().getLabel() ));
            }
        }
        
    }
}