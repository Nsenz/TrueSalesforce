public class vacationTableController {
	//Potentially database calls to get request types from a dictionary
	private static List<String> requestTypes = new List<String>{'Vacation', 'Sick', 'Unpaid'};

	@AuraEnabled
	public static List<String> getRequestTypes(){
		return requestTypes;
	}
}