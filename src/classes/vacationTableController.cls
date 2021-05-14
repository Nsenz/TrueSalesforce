public class vacationTableController {

	@AuraEnabled
	public static List<String> getRequestTypes(){
		List<String> requestTypes = new List<String>();
		Schema.DescribeFieldResult result = Vacation_Request__c.RequestType__c.getDescribe();
		List<Schema.PicklistEntry> typeEntries = result.getPicklistValues();

		for(Schema.PicklistEntry entry : typeEntries){
			requestTypes.add(entry.getValue());
		}

		return requestTypes;
	}

	@AuraEnabled
	public static String getManager(){
		User u =  [SELECT Name, ManagerID, Manager.Name, Manager.ManagerID, Manager.Manager.Name FROM User WHERE Id =: UserInfo.getUserId()];
		return u.Manager.Name;
	}

	/*
	 * Validates inputs of the creation form on the server.
	 * The inputs are expected to be non-null, start date must be greater or equal to current date
	 * end date must be greater than start date, request type should match any of the
	 * types provided in the dictionary
	 *
	 * @param 	requestType	String from the form
	 * @param	startDate	Date
	 * @param	endDate		Date
	 */
	@AuraEnabled
	public static Boolean validateFields(String requestType, Date startDate, Date endDate){
		List<String> requestTypes = getRequestTypes();
		if(!requestTypes.contains(requestType)) return false;
		if(startDate == null || endDate == null) return false;
		if(startDate < Date.today() || startDate > endDate) return false;
		return true;
	}
}