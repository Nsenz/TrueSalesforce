public class utilController {

	private static List<String> getPicklistEntries(SObjectField field){
		List<String> options = new List<String>();
		Schema.DescribeFieldResult result = field.getDescribe();
		List<Schema.PicklistEntry> typeEntries = result.getPicklistValues();

		for(Schema.PicklistEntry entry : typeEntries){
			options.add(entry.getValue());
		}
		return options;
	}

	public static User getManagerObject(){
		try{
			User u = [SELECT Name, ManagerID, Manager.Name, Manager.ManagerID, Manager.Manager.Name FROM User WHERE Id =: UserInfo.getUserId()];
			return u.Manager;
		} catch (NullPointerException e){
			return null;
		}
	}

	@AuraEnabled
	public static String meQuery(){
		return UserInfo.getUserId();
	}

	@AuraEnabled
	public static List<String> getRequestTypes(){
		List<String> requestTypes = getPicklistEntries(Vacation_Request__c.RequestType__c);
		return requestTypes;
	}

	@AuraEnabled
	public static List<String> getStatusTypes(){
		List<String> statusTypes = getPicklistEntries(Vacation_Request__c.Status__c);
		return statusTypes;
	}

	@AuraEnabled
	public static String getManager(){
		User manager = getManagerObject();
		if(manager != null) return manager.Name;
		return '';
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