@IsTest
public class tests {

	private static Vacation_Request__c newRequest = new Vacation_Request__c(StartDate__c = Date.today(),
			EndDate__c = Date.today().addDays(1), RequestType__c = 'Vacation',
			Status__c = 'New');

	@IsTest
	static void test_countRequestTypes(){
		Integer entries = 0;
		List<String> expectedTypes = new List<String>{'Vacation', 'Sick', 'Unpaid'};

		Schema.DescribeFieldResult result = Vacation_Request__c.RequestType__c.getDescribe();
		List<Schema.PicklistEntry> typeEntries = result.getPicklistValues();

		for(Schema.PicklistEntry entry : typeEntries){
			System.assertEquals(entry.getValue(), expectedTypes[entries]);
			entries++;
		}
		System.assertEquals(entries, 3, 'Expected number of entries is 3, got '+entries);
	}

	@IsTest
	static void test_getRequests(){
		insert newRequest;

		List<Vacation_Request__c> requests = [SELECT Owner.Name, RequestType__c,
		StartDate__c, EndDate__c, WorkingDays__c, Status__c, Manager__r.Name FROM Vacation_Request__c];

		System.assertEquals(requests.size(), 1);
	}

	@IsTest
	static void test_deleteRequest(){
		insert newRequest;

		Vacation_Request__c request = [SELECT Id, Name from Vacation_Request__c WHERE Id =: newRequest.Id];
		delete request;

		List<Vacation_Request__c> requests = [SELECT Owner.Name, RequestType__c,
		StartDate__c, EndDate__c, WorkingDays__c, Status__c, Manager__r.Name FROM Vacation_Request__c];

		System.assertEquals(requests.size(),0);
	}

	@IsTest
	static void test_insertNewRequest(){
		insert newRequest;
		List<Vacation_Request__c> values =[select id from Vacation_Request__c];
		System.assertEquals(values.size(), 1);
	}

	@IsTest
	static void test_updateRequest(){
		Date endDate = Date.today().addDays(2);
		insert newRequest;

		Vacation_Request__c testRecord =[select id, EndDate__c from Vacation_Request__c].get(0);
		testRecord.EndDate__c = testRecord.EndDate__c.addDays(1);
		update testRecord;

		System.assertEquals(testRecord.EndDate__c, endDate);
	}
}