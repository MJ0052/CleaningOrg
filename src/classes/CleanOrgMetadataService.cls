public with sharing class CleanOrgMetadataService
{
     public static void deleteField()
    {
        MetadataService.MetadataPort service = createService();
        List<MetadataService.DeleteResult> results =
            service.deleteMetadata(
                'CustomField', new String[] { 'Test__c.TestField__c' });
        handleDeleteResults(results[0]);
    }
    public static void deleteObject(List<String> objectList){
        MetadataService.MetadataPort service = createService();
        List<MetadataService.DeleteResult> results = service.deleteMetadata('CustomObject', objectList);
        handleDeleteResults(results[0]);
    }

    
    public static void deleteStaticResource()
    {
        MetadataService.MetadataPort service = createService();
        List<MetadataService.DeleteResult> results =
            service.deleteMetadata(
                'StaticResource', new String[] { 'test' });
        handleDeleteResults(results[0]);
    }

    public static void deleteRecordType()
    {
        // Salesforce bug? The follow results in 'Cannot delete record type through API'
        //   yet the docs say otherwise, http://www.salesforce.com/us/developer/docs/api_meta/Content/meta_recordtype.htm
        //   'For more information, see “Record Types Overview” in the Salesforce online help.
        //    Use this metadata type to create, update, or delete record type definitions for a custom object.'
        MetadataService.RecordType recordType = new MetadataService.RecordType();
        recordType.active = true;
        recordType.fullName = 'Test__c.RecordTypeA';
        MetadataService.MetadataPort service = createService();
        List<MetadataService.DeleteResult> results =
            service.deleteMetadata(
                'RecordType', new String[] { 'Test__c.RecordTypeA' });
        handleDeleteResults(results[0]);
    }

    public static void uninstallPackages()
    {
        // Uninstall packages
        MetadataService.MetadataPort service = createService();
        List<MetadataService.DeleteResult> results =
            service.deleteMetadata(
                'InstalledPackage', new String[] { 'packagea', 'packageb' });
        handleDeleteResults(results[0]);
        handleDeleteResults(results[1]);
    }

    public static void listListViews()
    {
        MetadataService.MetadataPort service = createService();
        List<MetadataService.ListMetadataQuery> queries = new List<MetadataService.ListMetadataQuery>();
        MetadataService.ListMetadataQuery listView = new MetadataService.ListMetadataQuery();
        listView.type_x = 'ListView';
        queries.add(listView);
        MetadataService.FileProperties[] fileProperties = service.listMetadata(queries, 25);
        for(MetadataService.FileProperties fileProperty : fileProperties)
            System.debug(fileProperty.fullName);
    }

    public static void retrieveConnectedApp() {
        // This only seems to work for Connected App's created in the org, not those packaged, see Workbench only created ones get listed
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        MetadataService.ConnectedApp connectedApp =
                (MetadataService.ConnectedApp)service.readMetadata('ConnectedApp', new String[] {'Test' }).getRecords()[0];
        system.debug('connectedApp = ' + connectedApp);        
    }

    public class MetadataServiceExamplesException extends Exception { }

    public static MetadataService.MetadataPort createService()
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }

    /**
     * Example helper method to interpret a SaveResult, throws an exception if errors are found
     **/
    public static void handleSaveResults(MetadataService.SaveResult saveResult)
    {
        // Nothing to see?
        if(saveResult==null || saveResult.success)
            return;
        // Construct error message and throw an exception
        if(saveResult.errors!=null)
        {
            List<String> messages = new List<String>();
            messages.add(
                (saveResult.errors.size()==1 ? 'Error ' : 'Errors ') +
                    'occured processing component ' + saveResult.fullName + '.');
            for(MetadataService.Error error : saveResult.errors)
                messages.add(
                    error.message + ' (' + error.statusCode + ').' +
                    ( error.fields!=null && error.fields.size()>0 ?
                        ' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
            if(messages.size()>0)
                throw new MetadataServiceExamplesException(String.join(messages, ' '));
        }
        if(!saveResult.success)
            throw new MetadataServiceExamplesException('Request failed with no specified error.');
    }

    /**
     * Example helper method to interpret a SaveResult, throws an exception if errors are found
     **/
    public static void handleDeleteResults(MetadataService.DeleteResult deleteResult)
    {
        // Nothing to see?
        if(deleteResult==null || deleteResult.success)
            return;
        // Construct error message and throw an exception
        if(deleteResult.errors!=null)
        {
            List<String> messages = new List<String>();
            messages.add(
                (deleteResult.errors.size()==1 ? 'Error ' : 'Errors ') +
                    'occured processing component ' + deleteResult.fullName + '.');
            for(MetadataService.Error error : deleteResult.errors)
                messages.add(
                    error.message + ' (' + error.statusCode + ').' +
                    ( error.fields!=null && error.fields.size()>0 ?
                        ' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
            if(messages.size()>0)
                throw new MetadataServiceExamplesException(String.join(messages, ' '));
        }
        if(!deleteResult.success)
            throw new MetadataServiceExamplesException('Request failed with no specified error.');
    }

    /**
     * Example helper method to interpret a UpsertResult, throws an exception if errors are found
     **/
    public static void handleUpsertResults(MetadataService.UpsertResult upsertResult)
    {
        // Nothing to see?
        if(upsertResult==null || upsertResult.success)
            return;
        // Construct error message and throw an exception
        if(upsertResult.errors!=null)
        {
            List<String> messages = new List<String>();
            messages.add(
                (upsertResult.errors.size()==1 ? 'Error ' : 'Errors ') +
                    'occured processing component ' + upsertResult.fullName + '.');
            for(MetadataService.Error error : upsertResult.errors)
                messages.add(
                    error.message + ' (' + error.statusCode + ').' +
                    ( error.fields!=null && error.fields.size()>0 ?
                        ' Fields ' + String.join(error.fields, ',') + '.' : '' ) );
            if(messages.size()>0)
                throw new MetadataServiceExamplesException(String.join(messages, ' '));
        }
        if(!upsertResult.success)
            throw new MetadataServiceExamplesException('Request failed with no specified error.');
    }
}