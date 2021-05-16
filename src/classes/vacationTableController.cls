public class vacationTableController {

	/*
	 * CRUD
	 */

	@AuraEnabled
	public static Vacation_Request__c insertRequest(String requestType, Date startDate, Date endDate){
		User manager = utilController.getManagerObject();
		Vacation_Request__c newRequest = new Vacation_Request__c(StartDate__c = startDate,
				EndDate__c = endDate, RequestType__c = requestType,
				Status__c = 'New', Manager__c = manager.Id);
		try{
			insert newRequest;
			return newRequest;
		} catch (Exception e){
			return null;
		}
	}

	@AuraEnabled
	public static List<Vacation_Request__c> getRequests(){
		List<Vacation_Request__c> requests = [SELECT Owner.Name, RequestType__c,
		 StartDate__c, EndDate__c, WorkingDays__c, Status__c, Manager__r.Name FROM Vacation_Request__c];
		return requests;
	}

	@AuraEnabled
	public static Vacation_Request__c updateStatus(String id, String status){
		Vacation_Request__c request = [SELECT Id, Name, Status__c from Vacation_Request__c WHERE Id =: id];
		request.Status__c = status;
		update request;
		return request;
	}

	@AuraEnabled
	public static Boolean removeRequest(String id){
		Vacation_Request__c request = [SELECT Id, Name from Vacation_Request__c WHERE Id =: id];
		try {
			delete request;
			return true;
		} catch (DmlException e) {
			return false;
		}
	}
}